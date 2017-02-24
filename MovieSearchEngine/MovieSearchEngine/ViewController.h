//
//  ViewController.h
//  MovieSearchEngine
//
//  Created by Yao Li on 2/13/17.
//  Copyright © 2017 clouds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic) NSMutableArray *posts;
@property (nonatomic) NSInteger postNum;
@property (nonatomic) NSInteger page;
@property (nonatomic) NSString *currentTerm;
@property (nonatomic) BOOL hasNoMorePosts;
@property (nonatomic) BOOL isLoadingMore;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) UIActivityIndicatorView *loadingSpinner;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

