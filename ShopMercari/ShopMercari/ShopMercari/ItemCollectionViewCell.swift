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

    public func initData(item : Item) {
        titleLabel.text = item.name
        soldImgView.image = (item.status == "sold_out") ? UIImage(named: "sold") : nil
        priceLabel.text = "$\(item.price)"
    }
}
