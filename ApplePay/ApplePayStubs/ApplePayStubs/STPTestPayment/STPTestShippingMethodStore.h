//
//  STPTestShippingMethodStore.h
//  ApplePayStubs
//
//  Created by Yao Li on 4/23/16.
//  Copyright © 2016 clouds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STPTestDataStore.h"

@interface STPTestShippingMethodStore : NSObject<STPTestDataStore>

- (instancetype)initWithShippingMethods: (NSArray *)shippingMethods;
- (void)setShippingMethods:(NSArray *)shippingMethods;

@end