//
//  ProductCell.swift
//  Inventory
//
//  Created by Hoang Truc on 4/7/21.
//  Copyright © 2021 Hoang Truc. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var priceProduct: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(product: Product) {
        if let name = product.name, let price = product.price {
            nameProduct.text = name
            priceProduct.text = "\(price)"
        }
    }
}
