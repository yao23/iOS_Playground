//
//  UnitBasicTests.m
//  MovieSearchEngine
//
//  Created by Yao Li on 2/14/17.
//  Copyright © 2017 clouds. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ServerAgent.h"

@interface UnitBasicTests : XCTestCase

@end

@implementation UnitBasicTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

// Test fetching movies. Because fetching is asynchronous,
// use XCTestCase's asynchronous APIs to wait until it has
// finished fetching.
- (void)testMoviesFetching {
    // Create an expectation object.
    // This test only has one, but it's possible to wait on multiple expectations.
    XCTestExpectation *movieFetchExpectation = [self expectationWithDescription:@"movie fetch"];
    NSString *searchTerm = @"Harry Potter";
    searchTerm = [searchTerm stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSInteger page = 1;
    [ServerAgent getMovie:searchTerm page:page callback:^(NSArray *movies, NSInteger totalPage) {
        XCTAssertNotNil(movies);
        XCTAssertGreaterThanOrEqual(totalPage, 0);

        // Fulfill the expectation-this will cause -waitForExpectation
        // to invoke its completion handler and then return.
        [movieFetchExpectation fulfill];
    }];

    // The test will pause here, running the run loop, until the timeout is hit
    // or all expectations are fulfilled.
    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        NSLog(@"Movie fetching is completed.");
    }];
}


@end
