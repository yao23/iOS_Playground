//
//  ViewController.h
//  MapPractice
//
//  Created by Yao Li on 10/22/16.
//  Copyright © 2016 clouds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationManager *locationManager;

@end

