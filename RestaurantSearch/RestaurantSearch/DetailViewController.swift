//
//  DetailViewController.swift
//  RestaurantSearch
//
//  Created by Yao Li on 3/26/17.
//  Copyright © 2017 clouds. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var restaurant : Restaurant?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.navigationController!.navigationBar.backgroundColor = UIColor.white
        tableView.reloadData()
    }

    func updateRestaurant(restaurant : Restaurant) -> Void {
        self.restaurant = restaurant
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.restaurant!.numAttribute + 1)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)

        let rowIdx : Int = indexPath.row
        var text : String = ""
        switch (rowIdx) {
            case 0:
                text = "Restaurant info"
                break
            case 1:
                text = "Name: " + self.restaurant!.name
                break
            case 2:
                text = "Distance: " + (self.restaurant!.distance + " miles")
                break
            default:
                text = ""
                break
        }
        cell.textLabel!.text = text
        
//        cell.imageView.image = nil  // TODO: add image in async way
        return cell
    }

    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("click at detail info index: \(indexPath.row)")
    }
    
    @IBAction func backTapped(_ sender: Any) {
        print("go back")
        self.navigationController!.popViewController(animated: true)
    }
}
