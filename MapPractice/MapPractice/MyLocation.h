//
//  MyLocation.h
//  MapPractice
//
//  Created by Yao Li on 10/22/16.
//  Copyright © 2016 clouds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyLocation : NSObject <MKAnnotation>

- (id)initWithJSON:(NSDictionary*)locationInfo;
- (MKMapItem*)mapItem;

@property (nonatomic) NSNumber *id;
@property (nonatomic) NSNumber *latitude;
@property (nonatomic) NSNumber *longitude;
@property (nonatomic) NSNumber *costPerMinute;
@property (nonatomic) NSNumber *maxResrvTime;
@property (nonatomic) NSNumber *minResrvTime;
@property (nonatomic) BOOL isResrved;
@property (nonatomic) NSString * resrvedUntil;

@end