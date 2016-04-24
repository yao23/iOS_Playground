//
//  STPTestDataStore.h
//  ApplePayStubs
//
//  Created by Yao Li on 4/23/16.
//  Copyright © 2016 clouds. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STPTestDataStore <NSObject>

@property (nonatomic) id selectedItem;
@property (nonatomic, readonly) NSArray *allItems;
- (NSArray *)descriptionsForItem:(id)item;

@end