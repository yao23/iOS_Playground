//
//  MovieTableViewCell.h
//  MovieSearchEngine
//
//  Created by Yao Li on 2/13/17.
//  Copyright © 2017 clouds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

- (void)configCell:(NSDictionary *)postInfo;
@end
