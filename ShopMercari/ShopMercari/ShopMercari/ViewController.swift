//
//  ViewController.swift
//  ShopMercari
//
//  Created by Yao Li on 5/11/17.
//  Copyright © 2017 clouds. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var items : [Item] = []

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let dataFetchAgent = DataFetch()
        items = dataFetchAgent.fetchData()

        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : ItemCollectionViewCell =
                collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for:indexPath as IndexPath) as! ItemCollectionViewCell
        // Configure the cell
        cell.initData(item: items[indexPath.row])
        return cell
    }

    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let w : CGFloat = (screenWidth - 60) / 3 // self.collectionView.frame.size.width
        return CGSize(width: w, height: w)
    }

    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("click at item index: \(indexPath.row)")
        let item : Item? = items[indexPath.row]
        print("click at item: ")
        item!.printInfo()
    }
}

