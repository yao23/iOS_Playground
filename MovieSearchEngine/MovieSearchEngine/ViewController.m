//
//  ViewController.m
//  MovieSearchEngine
//
//  Created by Yao Li on 2/13/17.
//  Copyright © 2017 clouds. All rights reserved.
//

#import "ViewController.h"
#import "ServerAgent.h"
#import "MovieTableViewCell.h"
#import <MJRefresh/MJRefreshComponent.h>
#import <MJRefresh/MJRefreshAutoStateFooter.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configRefreshControl];
    [self configLoadingSpinner];
    [self configTableViewFooter];
    _page = 1;
    _postNum = 0;
    _currentTerm = @"Harry Potter";
    _searchBar.text = _currentTerm;
    [self configSearchBar];
    [self search];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configRefreshControl {
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.backgroundColor = [UIColor whiteColor];
    _refreshControl.tintColor = [UIColor blackColor];
    [_refreshControl addTarget:self
                        action:@selector(getLatestPosts)
              forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
}

- (void)configTableViewFooter {
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self
                                                                           refreshingAction:@selector(loadMorePosts)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"Loading..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"No more data" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    footer.stateLabel.textColor = [UIColor darkGrayColor];
    _tableView.footer = footer;
}

- (void)loadMorePosts {
    if (_isLoadingMore) {
        return;
    }
    _isLoadingMore = YES;
    if (!_hasNoMorePosts) {
        _page++;
        [self search];
    } else {
        _tableView.footer.hidden = YES;
    }

    [_tableView.footer endRefreshing];
}

- (void)getLatestPosts {
    if (_postNum > 0) {
        [_posts removeAllObjects];
        _postNum = 0;
    }
    [self search];
}

- (void)configLoadingSpinner {
    _loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_loadingSpinner setColor:[UIColor grayColor]];
    [_loadingSpinner setCenter:self.view.center];
    [_tableView addSubview: _loadingSpinner];
    [self hideLoadSpinner];
}

- (void)showLoadSpinner {
    _loadingSpinner.hidden = NO;
    [_loadingSpinner startAnimating];
    [self.view bringSubviewToFront:_loadingSpinner];
}

- (void)hideLoadSpinner {
    if (!_loadingSpinner.hidden) {
        [self.view sendSubviewToBack:_loadingSpinner];
        [_loadingSpinner stopAnimating];
        _loadingSpinner.hidden = YES;
    }
}

- (void)configSearchBar {
    _searchBar.showsCancelButton = NO;
    _searchBar.searchBarStyle = UISearchBarStyleDefault;
    // remove UISearchBarBackground bottom line, http://stackoverflow.com/questions/6868214/remove-the-1px-border-under-uisearchbar
    [_searchBar setBackgroundImage:[UIImage new]];
}

- (void)reloadPostData {
    // Reload collection data
    [_tableView reloadData];

    // End the refreshing
    if (_refreshControl) {
        NSString *title = @"Loading...";
        NSDictionary *attrsDictionary = @{NSForegroundColorAttributeName: [UIColor blackColor]};
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        _refreshControl.attributedTitle = attributedTitle;

        [_refreshControl endRefreshing];
    }
}

- (void)getMovie:(NSString *)searchTerm {
    [self showLoadSpinner];
    [ServerAgent getMovie:searchTerm page:_page callback:^(NSArray *movies, NSInteger totalPage) {
        [self hideLoadSpinner];
        if (movies != nil && ![movies isEqual:[NSNull null]]) {
            if (_postNum == 0) {
                _posts = [[NSMutableArray alloc] init];
            }
            [_posts addObjectsFromArray:movies];
            _postNum += movies.count;
            if (_page == totalPage) {
                _hasNoMorePosts = YES;
            }
            if (_postNum == movies.count) {
                [_tableView setContentOffset:CGPointZero animated:NO];
            }
            if (_isLoadingMore) {
                [_tableView.footer endRefreshing];
                _isLoadingMore = NO;
            }
            [self performSelectorOnMainThread:@selector(reloadPostData) withObject:nil waitUntilDone:NO];
        } else {
            [self blankAlertWithMessage:@"Error" message:@"Try again later" owner:self];
        }
    }];
}

- (void)blankAlertWithMessage:(NSString*)title message:(NSString*)message owner:(UIViewController*)vc {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: title message: message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];

    [vc presentViewController:alertController animated:YES completion:nil];
}

- (void)search {
    if ([_currentTerm isEqualToString:@""]) {
        [self blankAlertWithMessage:@"Oops" message:@"Search term is empty" owner:self];
    }
    NSString *searchTerm = _currentTerm;// @"harry potter"
    searchTerm = [searchTerm stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    [self getMovie:searchTerm];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    NSLog(@"Text change - %ld", (long)self.doingSearch);
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar {
    [_searchBar resignFirstResponder];
    if ([searchBar.text isEqualToString:_currentTerm]) {
        return;
    } else {
        _currentTerm = searchBar.text;
        [_posts removeAllObjects];
        _postNum = 0;
        [self search];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar*)searchBar {
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    _searchBar.showsCancelButton = YES;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    _searchBar.showsCancelButton = NO;
    return YES;
}

#pragma mark - table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _postNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];

    if (_postNum <= indexPath.row) {
        return cell;
    }

    NSDictionary *postInfo = _posts[indexPath.section];
    [cell configCell:postInfo];

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc]init];
    header.backgroundColor = [UIColor clearColor];
    return header;
}
@end
