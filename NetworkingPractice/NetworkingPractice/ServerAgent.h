//
//  ServerAgent.h
//  NetworkingPractice
//
//  Created by Yao Li on 10/12/16.
//  Copyright © 2016 clouds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerAgent : NSObject
+ (void)getMovie:(NSString*)searchTerm callback:(void(^)(NSArray*))callback;
@end