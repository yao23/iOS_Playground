//
//  Restaurant.swift
//  RestaurantSearch
//
//  Created by Yao Li on 3/25/17.
//  Copyright © 2017 clouds. All rights reserved.
//

import Foundation
import CoreLocation

class Restaurant: NSObject {
    var name : String
    var distance : String

    init(jsonData : [String: Any]) {
        name = jsonData["name"] as! String

        let geometry : [String : Any] = jsonData["geometry"] as! [String : Any]
        let location : [String : Any] = geometry["location"] as! [String : Any]
        let lat : Double = NumberFormatter().number(from:location["lat"] as! String)!.doubleValue
        let lng : Double = NumberFormatter().number(from:location["lat"] as! String)!.doubleValue
        let coordinate0 = CLLocation(latitude: lat, longitude: lng) // target location
        let coordinate1 = CLLocation(latitude: 37.3230, longitude: -122.0322) // Apple headquarter as default location, Cupertino, CA

        let distanceInMeters = coordinate0.distance(from: coordinate1) // result is in meters
        distance = String(distanceInMeters)
    }

    func printInfo() {
        print("Restaurant: \(name), \(distance) meters far away")
    }
}
