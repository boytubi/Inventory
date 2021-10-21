//
//  Encodable+Extensions.swift
//  Inventory
//
//  Created by Hoang Truc on 4/7/21.
//  Copyright © 2021 Hoang Truc. All rights reserved.
//

import Foundation

extension Encodable {
    
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data,
                                                  options: .allowFragments))
            .flatMap { $0 as? [String: Any] }
    }
    
    var array: [Any]? {
        let jsonData = try? JSONEncoder().encode(self)
        return try? JSONSerialization.jsonObject(with: jsonData ?? Data.init(), options: .allowFragments) as? [Any]
    }
    
}
