//
//  ServerAgent.h
//  MovieSearchEngine
//
//  Created by Yao Li on 2/13/17.
//  Copyright © 2017 clouds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerAgent : NSObject
+ (void)getMovie:(NSString*)searchTerm page:(NSInteger)page callback:(void(^)(NSArray*, NSInteger))callback;
@end