//
//  ViewController.m
//  ApplePayStubs
//
//  Created by Yao Li on 4/23/16.
//  Copyright © 2016 clouds. All rights reserved.
//

#import "ViewController.h"
#import "STPTestPaymentAuthorizationViewController.h"
#import <STPTestPayment/STPTestPaymentAuthorizationViewController.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    PKPaymentRequest *request;
    UIViewController *controller;
#if DEBUG
    controller = [[STPTestPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    // controller.delegate = self;
#else
    controller = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    // controller.delegate = self;
#endif

//    [self presentViewController: controller];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                  didSelectShippingAddress:(ABRecordRef)address
                                completion:(void (^)(PKPaymentAuthorizationStatus status, NSArray *shippingMethods, NSArray *summaryItems))completion {
    [self fetchShippingCostsForAddress:address completion:^(NSArray *shippingMethods, NSError *error) {
        if (error) {
            completion(PKPaymentAuthorizationStatusFailure, nil, nil);
            return;
        }
        completion(PKPaymentAuthorizationStatusSuccess, shippingMethods, [self summaryItemsForShippingMethod:shippingMethods.firstObject]);
    }];
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                   didSelectShippingMethod:(PKShippingMethod *)shippingMethod
                                completion:(void (^)(PKPaymentAuthorizationStatus, NSArray *summaryItems))completion {
    completion(PKPaymentAuthorizationStatusSuccess, [self summaryItemsForShippingMethod:shippingMethod]);
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus))completion {

    [[STPAPIClient sharedClient] createTokenWithPayment:payment
         completion:^(STPToken *token, NSError *error) {
             [self createBackendChargeWithToken:token
                 completion:^(STPBackendChargeResult status, NSError *error) {
                     if (status == STPBackendChargeResultSuccess) {
                         completion(PKPaymentAuthorizationStatusSuccess);
                     } else {
                         completion(PKPaymentAuthorizationStatusFailure);
                     }
                 }];
         }];
}

@end
