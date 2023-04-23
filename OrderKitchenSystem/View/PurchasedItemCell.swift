//
//  PurchasedItemCell.swift
//  OrderKitchenSystem
//
//  Created by Hao Yu Yeh on 2023/4/22.
//

import UIKit

class PurchasedItemCell: UITableViewCell {
    static let identifier = "\(PurchasedItemCell.self)"
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var quantity: UILabel!
}
