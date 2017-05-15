//
// Created by Yao Li on 5/11/17.
// Copyright (c) 2017 clouds. All rights reserved.
//

import Foundation
import ReactiveSwift
import enum Result.NoError

class Item: NSObject {
    var id : String // "id": "mmen1"
    var name : String // "name": "men1"
    var status : String // "status": "on_sale"
    var numLikes: Int // "num_likes": 91
    var numComments: Int // "num_comments": 59
    var price: Int // "price": 51
    var photo: String // "photo": "https://dummyimage.com/400x400/000/fff?text=men1"
    var sp: SignalProducer<String, NoError>

    init(jsonData : [String: Any]) {
        id = jsonData["id"] as! String
        name = jsonData["name"] as! String
        status = jsonData["status"] as! String
        numLikes = jsonData["num_likes"] as! Int
        numComments = jsonData["num_comments"] as! Int
        price = jsonData["price"] as! Int
        photo = jsonData["photo"] as! String

        sp = SignalProducer<String, NoError> { sink, disposable in
            sink.send(value: (jsonData["status"] as! String))
        }
    }

    func printInfo() {
        print("Item: \(id), \(name), \(status), \(numLikes), \(numComments), \(price), \(photo)")
    }

    func acceptStatus(status: String) {
        sp = SignalProducer<String, NoError> { sink, disposable in
            sink.send(value: status)
        }
    }

    func returnStatus() {
        sp.startWithValues { (status: String) in
            print("item status: " + status)
        }
    }
}
