//
//  STPTestShippingMethodStore.h STPTestShippingMethodStore.h STPTestShippingMethodStore.h STPTestShippingMethodStore.h STPTestShippingMethodStore.h STPTestShippingMethodStore.h STPTestShippingMethodStore.h STPTestShippingMethodStore.m
//  ApplePayStubs
//
//  Created by Yao Li on 4/23/16.
//  Copyright © 2016 clouds. All rights reserved.
//

#import "STPTestShippingMethodStore.h"
#import <PassKit/PassKit.h>

@interface STPTestShippingMethodStore()
@property(nonatomic)NSArray *shippingMethods;
@end

@implementation STPTestShippingMethodStore
@synthesize selectedItem;

- (instancetype)initWithShippingMethods:(NSArray *)shippingMethods {
    self = [super init];
    if (self) {
        [self setShippingMethods:shippingMethods];
    }
    return self;
}

- (NSArray *)allItems {
    return self.shippingMethods;
}

- (NSArray *)descriptionsForItem:(id)item {
    PKShippingMethod *method = (PKShippingMethod *)item;
    return @[method.label, method.amount.stringValue];
}

- (void)setShippingMethods:(NSArray *)shippingMethods {
    _shippingMethods = shippingMethods;
    for (PKShippingMethod *method in shippingMethods) {
        if ([self.selectedItem isEqual:method]) {
            self.selectedItem = method;
            return;
        }
    }
    if (shippingMethods.count > 0) {
        self.selectedItem = shippingMethods[0];
    }
}

@end

