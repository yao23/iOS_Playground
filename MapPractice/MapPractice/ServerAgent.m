//
//  ServerAgent.m
//  MapPractice
//
//  Created by Yao Li on 10/22/16.
//  Copyright © 2016 clouds. All rights reserved.
//

#import "ServerAgent.h"
#import "APIAgent.h"

@implementation ServerAgent

+ (void)getParkingLocations:(void(^)(NSArray*))callback {
    NSDictionary *params = @{};
    NSString *queryParam = @"parkinglocations"; //[NSString stringWithFormat:@"?s=%@", searchTerm];
    [[APIAgent manager] GET:queryParam parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        callback(responseObject);
//        NSArray *results = [responseObject objectForKey:@"Search"];
//        if (results != nil && ![results isEqual:[NSNull null]]) {
//            NSLog(@"results: %@", results);
//            callback(results);
//            for (int i = 0; i < results.count; i++) {
//                NSLog(@"%d: %@", (int)i, results[i]);
//                NSDictionary *movieObj = results[i];
//                NSLog(@"%@, %@, %@, %@, %@", movieObj[@"Poster"], movieObj[@"Title"], movieObj[@"Type"], movieObj[@"Year"],
//                    movieObj[@"imdbID"]);
//            }
//            NSArray *movies = results[@"movie"];
//            if (movies) {
//                callback(movies);
//            } else {
//                callback(nil);
//            }
//        } else {
//            callback(nil);
//        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[APIAgent manager] POST:queryParam parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            callback(responseObject);
//            NSDictionary *results = [responseObject objectForKey:@"Search"];
//            if (results != nil && ![results isEqual:[NSNull null]]) {
//                NSArray *movies = results[@"movie"];
//                if (movies) {
//                    callback(movies);
//                } else {
//                    callback(nil);
//                }
//            } else {
//                callback(nil);
//            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            #ifdef DEBUG
                NSLog(@"ServerAgent::getParkingLocations:failure:");
            #endif
            NSLog(@"ERROR: %@", error.description);
            callback(nil);
        }];
    }];
}

@end