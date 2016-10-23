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

// Add the following method
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    MyLocation *location = (MyLocation*)view.annotation;

//    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
//    [location.mapItem openInMapsWithLaunchOptions:launchOptions];

    [self showParkingInfo:location];
}

- (void)addAnnotation:(MKUserLocation *)userLocation {
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";

    [_mapView addAnnotation:point];
}

- (void)showParkingInfo:(MyLocation *)curLocation {
    NSString *reserved = @"NO";
    if (curLocation.isResrved) {
        reserved = @"YES";
    }
    NSString *title = [NSString stringWithFormat:@"Parking Location (name: %@, id: %@)", curLocation.title, curLocation.id];
    NSString *message = [NSString stringWithFormat:@"Reserved: %@, Cost/Minute: %@, Max Time: %@, Min Time: %@, Reserve until: %@",
        reserved, curLocation.costPerMinute, curLocation.maxResrvTime, curLocation.minResrvTime, curLocation.resrvedUntil];
    NSString *actionName0 = @"Reserve";
    NSString *actionName1 = @"Cancel";
    if ([UIAlertController class]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField* field) {
            field.placeholder = @"Add minutes";
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:actionName0 style:UIAlertActionStyleDefault
          handler:^(UIAlertAction * action){
//              if (curLocation.isResrved) {
//                  [Utility blankAlertWithMessage:@"Oops" message:@"The parking location is reserved" owner:self];
//                  return;
//              }
              NSInteger minutes = 0;
              UITextField *tf = (UITextField*)alertController.textFields[0];
              if (tf.text.length > 0) {
                  minutes = (long)[tf.text longLongValue];
              }
              NSLog(@"minutes: %d", (int)minutes);

              [ServerAgent reserveParkingLocations:curLocation.id minutes:minutes callback:^(NSInteger status) {
                  if (status == 0) {
                    NSString *msg = [NSString stringWithFormat:@"Name: %@, ID: %@, Cost/Minute: %@, Max Time: %@, Min Time: %@, Reserve until: %@",
                                                               curLocation.title, curLocation.id, curLocation.costPerMinute, curLocation.maxResrvTime, curLocation.minResrvTime, curLocation.resrvedUntil];
                    [Utility blankAlertWithMessage:@"Success" message:msg owner:self];
                  } else {
                    [Utility blankAlertWithMessage:@"Error" message:@"Try again later" owner:self];
                  }
              }];
          }]];
        [alertController addAction:[UIAlertAction actionWithTitle:actionName1 style:UIAlertActionStyleDefault
          handler:^(UIAlertAction * action){
              [self.navigationController popViewControllerAnimated:NO];
          }]];

        [self presentViewController:alertController animated:YES completion:nil];
    }
}
@end
