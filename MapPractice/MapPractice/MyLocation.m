//
//  MyLocation.m
//  MapPractice
//
//  Created by Yao Li on 10/22/16.
//  Copyright © 2016 clouds. All rights reserved.
//

#import "MyLocation.h"
#import <AddressBook/AddressBook.h>

@interface MyLocation ()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;
@end

@implementation MyLocation

- (id)initWithJSON:(NSDictionary*)locationInfo {
    if ((self = [super init])) {
        if ([locationInfo[@"name"] isKindOfClass:[NSString class]]) {
            _name = locationInfo[@"name"];
        } else {
            _name = @"";
        }
        _address = @"";

        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [locationInfo[@"lat"] doubleValue];
        coordinate.longitude = [locationInfo[@"lng"] doubleValue];
        _theCoordinate = coordinate;

        _id = locationInfo[@"id"];
        _costPerMinute = locationInfo[@"cost_per_minute"];
        _maxResrvTime = locationInfo[@"max_reserve_time_mins"];
        _minResrvTime = locationInfo[@"min_reserve_time_mins"];
        _isResrved = (BOOL)locationInfo[@"is_reserved"];
        _resrvedUntil = locationInfo[@"reserved_until"];
    }
    return self;
}

- (NSString *)title {
    return _name;
}

- (NSString *)subtitle {
    return [NSString stringWithFormat:@"%@\n%@/minute", _id, _costPerMinute];
}

- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

- (MKMapItem*)mapItem {
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : _address};

    MKPlacemark *placemark = [[MKPlacemark alloc]
            initWithCoordinate:self.coordinate
             addressDictionary:addressDict];

    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;

    return mapItem;
}

@end