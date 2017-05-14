//
//  ShopMercariTests.swift
//  ShopMercariTests
//
//  Created by Yao Li on 5/11/17.
//  Copyright © 2017 clouds. All rights reserved.
//

import XCTest

@testable import ShopMercari

class ShopMercariTests: XCTestCase {

    var systemUnderTest: ViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        //get the storyboard the ViewController under test is inside
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

        //get the ViewController we want to test from the storyboard (note the identifier is the id explicitly set in the identity inspector)
        systemUnderTest = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController

        //load view hierarchy
        _ = systemUnderTest.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testSUT_CanInstantiateViewController() {

        XCTAssertNotNil(systemUnderTest)
    }

    func testSUT_CollectionViewIsNotNilAfterViewDidLoad() {

        XCTAssertNotNil(systemUnderTest.collectionView)
    }

    func testSUT_HasItemsForCollectionView() {

        XCTAssertNotNil(systemUnderTest.items)
    }

    func testSUT_ShouldSetCollectionViewDataSource() {

        XCTAssertNotNil(systemUnderTest.collectionView.dataSource)
    }

    func testSUT_ConformsToCollectionViewDataSource() {

        XCTAssert(systemUnderTest.conforms(to: UICollectionViewDataSource.self))
        XCTAssertTrue(systemUnderTest.responds(to: #selector(systemUnderTest.collectionView(_:numberOfItemsInSection:))))
//        XCTAssertTrue(systemUnderTest.responds(to: #selector(systemUnderTest.collectionView(_:cellForItemAtIndexPath:)))) // cellForItemAt indexPath
    }

    func testSUT_ShouldSetCollectionViewDelegate() {

        XCTAssertNotNil(systemUnderTest.collectionView.delegate)
    }
}
