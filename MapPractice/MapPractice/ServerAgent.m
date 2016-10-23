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
//        NSLog(@"Response: %@", responseObject);
        callback(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[APIAgent manager] GET:queryParam parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            callback(responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            #ifdef DEBUG
                NSLog(@"ServerAgent::getParkingLocations:failure:");
            #endif
            NSLog(@"ERROR: %@", error.description);
            callback(nil);
        }];
    }];
}

+ (void)reserveParkingLocations:(NSNumber*)parkLotId callback:(void(^)(NSInteger))callback {
    NSDictionary *params = @{};
    NSString *queryParam = [NSString stringWithFormat:@"parkinglocations/%@/reserve/", parkLotId];
    [[APIAgent manager] POST:queryParam parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        callback(0);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[APIAgent manager] POST:queryParam parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            callback(0);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            #ifdef DEBUG
                NSLog(@"ServerAgent::reserveParkingLocations:failure:");
            #endif
            NSLog(@"ERROR: %@", error.description);
            callback(1);
        }];
    }];
}

@end