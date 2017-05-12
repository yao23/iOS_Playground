//
//  DataFetch.swift
//  ShopMercari
//
//  Created by Yao Li on 5/11/17.
//  Copyright © 2017 clouds. All rights reserved.
//

import Foundation

class DataFetch: NSObject {
    var items : [Item] = []

    public func fetchData() -> [Item] {
        readJson()
        print("parsing json file is done")
        for item in items {
            item.printInfo()
        }

        return items
    }

    private func readJson() {
        do {
            if let file = Bundle.main.url(forResource: "all", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    print("json is a dictionary")
                    print(object)

                    guard let items = object["data"] as? [[String: Any]] else {
                        print("Malformed data received from json file")
                        return
                    }

                    self.items = items.flatMap({ (itemDict) -> Item? in
                        return Item(jsonData: itemDict)
                    })

                } else if let object = json as? [Any] {
                    // json is an array
                    print("json is an array")
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}