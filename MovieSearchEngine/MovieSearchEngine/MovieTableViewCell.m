//
//  MovieTableViewCell.m
//  MovieSearchEngine
//
//  Created by Yao Li on 2/13/17.
//  Copyright © 2017 clouds. All rights reserved.
//


#import "MovieTableViewCell.h"
#import "Constants.h"
#import "UIImageView+AFNetworking.h"

@implementation MovieTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setSeparatorInset: UIEdgeInsetsMake(0, 0, 0, 0)];

    return self;
}

- (void)configCell:(NSDictionary *)postInfo {
    [self clear];
    _titleLabel.text = postInfo[@"title"];
    _descLabel.text = postInfo[@"overview"];
    NSString *postCoverURL = [[NSString alloc] initWithFormat:@"%@%@", API_IMG_URL, postInfo[@"poster_path"]];
    [_imgView setImageWithURL:[NSURL URLWithString:postCoverURL] placeholderImage:[UIImage imageNamed:@"twitter.png"]];
}

- (void)clear {
    _titleLabel.text = @"";
    _descLabel.text = @"";
    _imgView.image = nil;
}
@end