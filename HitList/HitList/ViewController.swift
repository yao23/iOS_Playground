//
//  ViewController.swift
//  HitList
//
//  Created by Yao Li on 11/27/16.
//  Copyright © 2016 clouds. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var people = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "\"The List\""
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func saveName(name: String) {
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

        //2
        let entity =  NSEntityDescription.entityForName("Person", inManagedObjectContext:managedContext)
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)

        //3
        person.setValue(name, forKey: "name")

        //4
        do {
            try managedContext.save()
            //5
            people.append(person)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

    @IBAction func addName(_ sender: Any) {
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) -> Void in
                    let textField = alert.textFields!.first
                    self.saveName(name:textField!.text!)
                    self.tableView.reloadData()
                })

        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in }

        alert.addTextField(configurationHandler: {(textField: UITextField) -> Void in })

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated:true, completion:nil)
    }

    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")

        let person = people[indexPath.row]
        cell!.textLabel!.text = person.value(forKey: "name") as? String

        return cell!
    }
}

