//
//  String+Extensions.swift
//  Inventory
//
//  Created by Hoang Truc on 4/7/21.
//  Copyright © 2021 Hoang Truc. All rights reserved.
//

import Foundation

extension Swift.Optional where Wrapped == String {
    
    var orEmptyString: String {
        if let unwrappedString = self {
            return unwrappedString
        }
        return ""
    }
    
}
