//
//  RestaurantJSON.swift
//  RestaurantSearch
//
//  Created by Yao Li on 3/26/17.
//  Copyright © 2017 clouds. All rights reserved.
//

import Foundation
import AlamofireObjectMapper

class RestaurantJSON: Mappable {
    var geometry : Geometry


    required init?(map: Map){

    }

    func mapping(map: Map) {
        name <- map["name"]
        geometry <- map["geometry"]
    }
}

class Geometry: Mappable {
    var location : Location

    required init?(map: Map){

    }

    func mapping(map: Map) {
        location <- map["location"]
    }
}

class Location: Mappable {
    let lat : Double
    let lng : Double

    required init?(map: Map){

    }

    func mapping(map: Map) {
        lat <- map["lat"]
        lng <- map["lng"]
    }
}
