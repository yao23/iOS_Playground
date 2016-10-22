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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self getParkingLocations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getParkingLocations {
    [ServerAgent getParkingLocations:^(NSArray *parkingLocations) {
        if (parkingLocations && ![parkingLocations isEqual:[NSNull null]]) {
//            NSLog(@"parkingLocations: %@", parkingLocations);
            if (parkingLocations.count > 0) {
                NSDictionary *parkingLotObj = parkingLocations[0];
                NSLog(@"Parking lot: %@", parkingLotObj);
//                NSLog(@"%@, %@, %@, %@, %@", parkingLotObj[@"Poster"], parkingLotObj[@"Title"], parkingLotObj[@"Type"], parkingLotObj[@"Year"],
//                        parkingLotObj[@"imdbID"]);
//                _titleLabel.text = parkingLotObj[@"Title"];
//                [_postImgView setImageWithURL:[NSURL URLWithString:parkingLotObj[@"Poster"]] placeholderImage:nil];
//              _postImgView.image =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:<#(NSString *)path#>]]];

            }
//            for (int i = 0; i < parkingLocations.count; i++) {
//                NSLog(@"%d: %@", (int)i, results[i]);
//                NSDictionary *parkingLotObj = parkingLocations[i];
//                NSLog(@"%@, %@, %@, %@, %@", parkingLotObj[@"Poster"], parkingLotObj[@"Title"], parkingLotObj[@"Type"], parkingLotObj[@"Year"],
//                        parkingLotObj[@"imdbID"]);
//            }
        } else {
            [Utility blankAlertWithMessage:@"Error" message:@"Try again later" owner:self];
        }
    }];
}

@end
