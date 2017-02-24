//
//  ServerAgent.m
//  MovieSearchEngine
//
//  Created by Yao Li on 2/13/17.
//  Copyright © 2017 clouds. All rights reserved.
//

#import "ServerAgent.h"
#import "APIAgent.h"
#import "Constants.h"

@implementation ServerAgent

+ (void)getMovie:(NSString*)searchTerm page:(NSInteger)page callback:(void(^)(NSArray*, NSInteger))callback {
    NSDictionary *params = @{};
    // https://api.themoviedb.org/3/search/movie?api_key=2a61185ef6a27f400fd92820ad9e8537&query=harry%20potter
    NSString *queryParam = [NSString stringWithFormat:@"?api_key=%@&query=%@&page=%d", API_KEY, searchTerm, (int)page];
    [[APIAgent manager] POST:queryParam parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"Response: %@", responseObject);
        callback(responseObject[@"results"], [responseObject[@"total_pages"] integerValue]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[APIAgent manager] POST:queryParam parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            callback(responseObject[@"results"], [responseObject[@"total_pages"] integerValue]);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            #ifdef DEBUG
                NSLog(@"ServerAgent::getMovie:failure:");
            #endif
            NSLog(@"ERROR: %@", error.description);
            callback(nil, 0);
        }];
    }];
}

@end
