//
//  STPTestAddressStore.h
//  ApplePayStubs
//
//  Created by Yao Li on 4/23/16.
//  Copyright © 2016 clouds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STPTestDataStore.h"
#import <AddressBook/AddressBook.h>

@interface STPTestAddressStore : NSObject<STPTestDataStore>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (ABRecordRef)contactForSelectedItemObscure:(BOOL)obscure;
#pragma clang diagnostic pop

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
- (PKContact *)pkContactForSelectedItemObscure:(BOOL)obscure;
#endif

@end