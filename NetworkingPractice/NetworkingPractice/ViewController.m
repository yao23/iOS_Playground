//
//  ViewController.m
//  NetworkingPractice
//
//  Created by Yao Li on 10/12/16.
//  Copyright © 2016 clouds. All rights reserved.
//

#import "ViewController.h"
#import "ServerAgent.h"
#import "Utility.h"
#import "UIImageView+AFNetworking.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

//    [self getMovie:@"batman"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getMovie:(NSString *)searchTerm {
    [ServerAgent getMovie:searchTerm callback:^(NSArray *movies) {
        if (movies && ![movies isEqual:[NSNull null]]) {
//            NSLog(@"Movies: %@", movies);
            if (movies.count > 0) {
                NSDictionary *movieObj = movies[0];
                NSLog(@"%@, %@, %@, %@, %@", movieObj[@"Poster"], movieObj[@"Title"], movieObj[@"Type"], movieObj[@"Year"],
                        movieObj[@"imdbID"]);
                _titleLabel.text = movieObj[@"Title"];
                [_postImgView setImageWithURL:[NSURL URLWithString:movieObj[@"Poster"]] placeholderImage:nil];
//              _postImgView.image =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:<#(NSString *)path#>]]]

            }
//            for (int i = 0; i < movies.count; i++) {
////                NSLog(@"%d: %@", (int)i, results[i]);
//                NSDictionary *movieObj = movies[i];
//                NSLog(@"%@, %@, %@, %@, %@", movieObj[@"Poster"], movieObj[@"Title"], movieObj[@"Type"], movieObj[@"Year"],
//                        movieObj[@"imdbID"]);
//            }
        } else {
            [Utility blankAlertWithMessage:@"Error" message:@"Try again later" owner:self];
        }
    }];
}

- (IBAction)searchTapped:(id)sender {
    NSString *searchTerm = _searchField.text;
    NSLog(@"%@", searchTerm);
    searchTerm = [searchTerm stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSLog(@"after: %@", searchTerm);
    [self getMovie:searchTerm];
}
@end
