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
        let lat : Double = location["lat"] as! Double
        let lng : Double = location["lng"] as! Double
        print("location: \(lat), \(lng)")
        let coordinate0 = CLLocation(latitude: lat, longitude: lng) // target location
        let coordinate1 = CLLocation(latitude: 37.3230, longitude: -122.0322) // Apple headquarter as default location, Cupertino, CA

        let distanceInMeters = coordinate0.distance(from: coordinate1) // result is in meters
        print("distance in meters: \(distanceInMeters)")
        let distanceInMiles : Float = Float(distanceInMeters / 1609);
        print("distance in miles: \(distanceInMiles)")
        distance = String(distanceInMiles)
        print("distance: " + distance)
    }

    func printInfo() {
        print("Restaurant: \(name), \(distance) miles far away")
    }
}
