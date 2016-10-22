//
//  ServerAgent.h
//  MapPractice
//
//  Created by Yao Li on 10/22/16.
//  Copyright © 2016 clouds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerAgent : NSObject
+ (void)getParkingLocations:(void(^)(NSArray*))callback;
@end