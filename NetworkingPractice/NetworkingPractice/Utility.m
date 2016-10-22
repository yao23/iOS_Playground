//
//  Utility.m
//  NetworkingPractice
//
//  Created by Yao Li on 10/12/16.
//  Copyright © 2016 clouds. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (void)blankAlertWithMessage:(NSString*)title message:(NSString*)message owner:(UIViewController*)vc {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: title message: message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];

    [vc presentViewController:alertController animated:YES completion:nil];
}

@end
