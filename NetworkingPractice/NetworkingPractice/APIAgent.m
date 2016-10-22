//
//  APIAgent.m
//  NetworkingPractice
//
//  Created by Yao Li on 10/12/16.
//  Copyright © 2016 clouds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIAgent.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "Constants.h"

@implementation APIAgent

+ (APIAgent *)manager {
    static APIAgent *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[APIAgent alloc] initWithBaseURL:[NSURL URLWithString:API_URL]];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        NSMutableIndexSet* codes = [NSMutableIndexSet indexSetWithIndexesInRange: NSMakeRange(200, 100)];
        [codes addIndex: 400];
        [codes addIndex: 401];
        [codes addIndex: 404];
        [codes addIndex: 409];
        [codes addIndex: 500];
        _manager.responseSerializer.acceptableStatusCodes = codes;
    });

    return _manager;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }

    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    [self setHeaders];

    return self;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                     complete:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error))complete {
    return [self GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (complete) {
            complete(task, responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (complete) {
            complete(task, nil, error);
        }
    }];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters complete:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error))complete {
    return [self POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (complete) {
            complete(task, responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (complete) {
            complete(task, nil, error);
        }
    }];
}


- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {

    return [super GET:URLString parameters:parameters progress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSMutableDictionary *params = [parameters mutableCopy];

    if (parameters == nil) {
        params = [[NSMutableDictionary alloc] init];
    } else {
        if (parameters[@"userId"] != nil) {
            params[@"userId"] = parameters[@"userId"];
        }
        if (parameters[@"name"] != nil) {
            params[@"name"] = parameters[@"name"];
        }
        if (parameters[@"email"] != nil) {
            params[@"email"] = parameters[@"email"];
        }
        if (parameters[@"password"] != nil) {
            params[@"password"] = parameters[@"password"];
        }
        if (parameters[@"followerId"] != nil) {
            params[@"followerId"] = parameters[@"followerId"];
        }
        if (parameters[@"followingId"] != nil) {
            params[@"followingId"] = parameters[@"followingId"];
        }
        if (parameters[@"text"] != nil) {
            params[@"text"] = parameters[@"text"];
        }
        if (parameters[@"postId"] != nil) {
            params[@"postId"] = parameters[@"postId"];
        }
    }

    params[@"key"] = API_KEY; // NSLog(@"params: %@", [params description]);
    self.securityPolicy.allowInvalidCertificates = YES; // self signed certificate
    self.securityPolicy.validatesDomainName = NO;
    return [super POST:URLString parameters:params progress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                    progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSMutableDictionary *params = [parameters mutableCopy];

    if (parameters == nil) {
        params = [[NSMutableDictionary alloc] init];
    } else {
        if (parameters[@"postId"] != nil) {
            params[@"postId"] = parameters[@"postId"];
        }
    }

    params[@"key"] = API_KEY; // NSLog(@"params: %@", [params description]);
    self.securityPolicy.allowInvalidCertificates = YES; // http://stackoverflow.com/questions/27808249/problems-with-ssl-pinning-and-afnetworking-2-5-0-nsurlerrordomain-error-1012
    self.securityPolicy.validatesDomainName = NO;
    return [super POST:URLString parameters:params constructingBodyWithBlock:block progress:nil success:success failure:failure];

}

- (void)setHeaders {
    NSString *time = [NSString stringWithFormat:@"%f", [[[NSDate alloc] init] timeIntervalSince1970]];
    AFHTTPRequestSerializer * serializer = self.requestSerializer;
    [serializer setValue:API_KEY forHTTPHeaderField:@"X-API-KEY"];
    [serializer setValue:time forHTTPHeaderField:@"X-API-TIME"];
    [serializer setValue:[UIDevice currentDevice].identifierForVendor.UUIDString forHTTPHeaderField:@"X-UUID"];

    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    NSString *preferredLang = [NSLocale preferredLanguages].firstObject;
    //    const char *langStr = [preferredLang UTF8String];

    [serializer setValue:preferredLang forHTTPHeaderField:@"X-USER-LANGUAGE"];
}

@end
