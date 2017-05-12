//
//  ItemCollectionViewCell.swift
//  ShopMercari
//
//  Created by Yao Li on 5/11/17.
//  Copyright © 2017 clouds. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var soldImgView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var contentImgView: UIImageView!

    public func initData(item : Item) {
        titleLabel.text = item.name
        soldImgView.image = (item.status == "sold_out") ? UIImage(named: "sold") : nil
//        self.insertSubview(soldImgView, aboveSubview: contentImgView)
        priceLabel.text = "$\(item.price)"
        configImg(urlString: item.photo)
        soldImgView.superview!.bringSubview(toFront: soldImgView)
//        self.bringSubview(toFront: soldImgView)
//        self.sendSubview(toBack: contentImgView)
    }

    public func configImg(urlString: String) {

        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.contentImgView.image = image
//                self.sendSubview(toBack: self.contentImgView)
//                self.bringSubview(toFront: self.soldImgView)
            })

        }).resume()
    }
}
