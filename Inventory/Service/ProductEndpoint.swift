//
//  ProductEndpoint.swift
//  Inventory
//
//  Created by Hoang Truc on 4/7/21.
//  Copyright © 2021 Hoang Truc. All rights reserved.
//

import Foundation

enum ProductEndPoint: FirebaseDatabaseEndpoint {
    case getAllProducts
    case postProduct
    case getProductDetail(id: String)
    case deleteProduct(id: String)
    case searchProduct
    
    var path: String {
        switch self {
        case .getAllProducts, .postProduct, .searchProduct:
            return "products"
        case .getProductDetail(let id), .deleteProduct(let id):
            return "products/\(id)"
        }
    }
    
    var sysced: Bool {
        switch self {
        case .getAllProducts, .getProductDetail:
            return true
        case .postProduct, .deleteProduct, .searchProduct:
            return false
        }
    }
}
