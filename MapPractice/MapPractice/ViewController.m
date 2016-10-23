//
//  ViewController.m
//  MapPractice
//
//  Created by Yao Li on 10/22/16.
//  Copyright © 2016 clouds. All rights reserved.
//

#import "ViewController.h"
#import "ServerAgent.h"
#import "Utility.h"
#import "MyLocation.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self setDefaulLocation];
    
    [self getParkingLocations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDefaulLocation {
    double lat = 37.740288; // 37.7749, 37.787359
    double lng = -122.465570; // -122.4194, -122.408227
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestAlwaysAuthorization];
    MKCoordinateRegion region = [_mapView
            regionThatFits:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(lat, lng), 200, 200)];
    [_mapView setRegion:region animated:YES];
}

- (void)getParkingLocations {
    [ServerAgent getParkingLocations:^(NSArray *parkingLocations) {
        if (parkingLocations && ![parkingLocations isEqual:[NSNull null]]) {
            if (parkingLocations.count > 0) {
                NSDictionary *parkingLotObj = parkingLocations[0];
                NSLog(@"Parking lot: %@", parkingLotObj);
            }

            [self plotParkingLocations:parkingLocations];
        } else {
            [Utility blankAlertWithMessage:@"Error" message:@"Try again later" owner:self];
        }
    }];
}

- (void)plotParkingLocations:(NSArray *)parkingLocations {
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }

    for (int i = 0; i < parkingLocations.count; i++) {
        MyLocation *annotation = [[MyLocation alloc] initWithJSON:parkingLocations[i]];
        [_mapView addAnnotation:annotation];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];

    [self addAnnotation:userLocation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MyLocation class]]) {
        MKPinAnnotationView *annoView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if(!annoView) {
            annoView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                    reuseIdentifier:identifier];
            MyLocation *curLocation = (MyLocation *)annotation;
            if (curLocation.isResrved) {
                annoView.pinTintColor = [UIColor redColor];
            } else {
                annoView.pinTintColor = [UIColor greenColor];
            }

            annoView.enabled = YES;
            annoView.canShowCallout = YES;
            annoView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        } else {
            annoView.annotation = annotation;
        }

        return annoView;
    }

    return nil;
}

- (void)addAnnotation:(MKUserLocation *)userLocation {
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";

    [_mapView addAnnotation:point];
}
@end
