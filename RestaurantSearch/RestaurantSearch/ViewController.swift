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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    let apiKey : String = "AIzaSyCqIvNrJKAjiRzdg6QlcFjTY_eD7PaaPzo"
    var restaurants : [Restaurant] = []
    var selectedRestaurant : Restaurant?
    var keyWord : String = ""

    // Apple headquarter as default location, Cupertino, CA
    var lat : float_t = 37.3230
    var lon : float_t =  -122.0322
    let locationManager = CLLocationManager()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

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
        let lat : float_t = -33.8670522
        let lon : float_t = 151.1957362
        let radius : Int = 5000
        let type : String = "restaurant"
        if (keyWord.isEmpty) {
            keyWord = "Korean Restaurant"
            searchBar.text = keyWord
        }
        let locationParam : String = "location=\(lat),\(lon)"
        let radiusParam : String = "&radius=\(radius)"
        let typeParam : String = "&type=" + type
        let keyWordParam : String = "&keyword=" + keyWord
        // http://stackoverflow.com/questions/24551816/swift-encode-url
        let escapedKeyWordParam = keyWordParam.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let apiKeyParam : String = "&key=" + apiKey
        let params : String = locationParam + radiusParam + typeParam + escapedKeyWordParam! + apiKeyParam
        let baseUrl : String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        let urlStr : String = baseUrl + params
        let url = URL(string: urlStr)
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

                    print("response: \(json)")

//                    let rooms = rows.flatMap({ (roomDict) -> RemoteRoom? in
//                        return RemoteRoom(jsonData: roomDict)
//                    })

//                    completion(rooms)

                }
                */


//            let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lon)&radius=500&type=restaurant&keyword=cruise&key=AIzaSyCykL88HIABtiuzvq0qebtxVkYob2lAszc")!

            var urlRequest = URLRequest(
                    url: url!,
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

                guard let results = json?["results"] as? [[String: Any]] else {
                    print("Malformed data received from fetch restaurants service")
                    return
                }

                self.restaurants = results.flatMap({ (resultDict) -> Restaurant? in
                    return Restaurant(jsonData: resultDict)
                })

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
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
        if (error != nil) {
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

    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath)

        let restaurant : Restaurant = restaurants[indexPath.row]
        cell.textLabel!.text = restaurant.name
        cell.detailTextLabel!.text = (restaurant.distance + " miles")
//        cell.imageView.image = nil  // TODO: add image in async way
        return cell
    }

    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("click at restaurant index: \(indexPath.row)")
        selectedRestaurant = restaurants[indexPath.row]
        print("click at restaurant: ")
        selectedRestaurant!.printInfo()

        self.performSegue(withIdentifier: "showDetail", sender: self)
    }

    // MARK: UISearch​Bar​Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // TODO: show recommended results in real time
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        keyWord = searchBar.text!
        self.getRestaurant()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetail") {
            let detailVC = segue.destination as! DetailViewController
            detailVC.updateRestaurant(restaurant: self.selectedRestaurant!)
        }
    }
}

