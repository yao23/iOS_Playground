//
//  ViewController.swift
//  RestaurantSearch
//
//  Created by Yao Li on 3/24/17.
//  Copyright © 2017 clouds. All rights reserved.
//

import UIKit
//import Alamofire
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    let apiKey : String = "AIzaSyCqIvNrJKAjiRzdg6QlcFjTY_eD7PaaPzo"
    var lat : float_t = 37.3230
    var lon : float_t =  -122.0322
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.getRestaurant()
//        self.getLocationService()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getRestaurant() {
//        var lat : float_t = -33.8670522
//        var lon : float_t = 151.1957362
//        var radius : Int = 500
//        var type : String = "restaurant"
//        var keyWord : String = "Korean Restaurant"
//        var params : String = "location=" + lat  + "," + lon + "&radius=" + radius + "&type=" + type + "&keyword=" + keyWord + "&key" + apiKey
//        var baseUrl : String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
//        let urlStr : String = baseUrl + params
//        let urlStr : String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&type=restaurant&keyword=cruise&key=YOUR_API_KEY"

    /*
        Alamofire.request(
                        URL(string: baseUrl)!,
                        method: .get,
                        parameters: ["location": lat  + "," + lon, "radius": radius, "type": type, "keyword": keyWord, "key": apiKey],
                        encoding: JSONEncoding.default)
                .validate()
                .responseJSON { (response) -> Void in
                    guard response.result.isSuccess else {
                        print("Error while fetching restaurants: \(response.result.error)")
//                        completion(nil)
                        return
                    }

                    guard let value = response.result.value as? [String: Any],
                          print("response: " + value)/*let rows = value["rows"] as? [[String: Any]]*/ else {
                        print("Malformed data received from fetch restaurants service")
//                        completion(nil)
                        return
                    }

//                    let rooms = rows.flatMap({ (roomDict) -> RemoteRoom? in
//                        return RemoteRoom(jsonData: roomDict)
//                    })

//                    completion(rooms)

                }
                */


            let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lon)&radius=500&type=restaurant&keyword=cruise&key=AIzaSyCykL88HIABtiuzvq0qebtxVkYob2lAszc")!

            var urlRequest = URLRequest(
                    url: url,
                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                    timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

            let session = URLSession.shared

            let task = session.dataTask(with: urlRequest)
            { (data, response, error) -> Void in
                guard error == nil else {
                    print("Error while fetching remote rooms: \(error)")
                    return
                }

                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Nil data received from fetch restaurants service")
                    return
                }

                print("response: \(json)")

//                guard let rows = json?["rows"] as? [[String: Any]] else {
//                    print("Malformed data received from fetch restaurants service")
//                    return
//                }

//                let rooms = rows.flatMap({ (roomDict) -> RemoteRoom? in
//                    return RemoteRoom(jsonData: roomDict)
//                })

//                completion(rooms)
            }

            task.resume()
    }

    func getLocationService() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            if ((UIDevice.current.systemVersion as NSString).floatValue >= 8) {
                locationManager.requestWhenInUseAuthorization()
            }

            locationManager.startUpdatingLocation()
        } else {
            #if debug
                println("Location services are not enabled");
            #endif
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("fail to get location")
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            print(error)
        }
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        print("update location")
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        print("latitude: \(coord.latitude)")
        print("longitude: \(coord.longitude)")

        self.getRestaurant()
    }
}

