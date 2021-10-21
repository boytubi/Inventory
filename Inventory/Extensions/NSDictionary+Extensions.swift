//
//  NSDictionary+Extensions.swift
//  Inventory
//
//  Created by Hoang Truc on 4/7/21.
//  Copyright © 2021 Hoang Truc. All rights reserved.
//

import Foundation
extension NSDictionary {
    
    func decode<T>(_ type: T.Type) -> T? where T: Decodable {
        let jsonData = (try? JSONSerialization.data(withJSONObject: self, options: [])) ?? Data.init()
        return try? JSONDecoder().decode(type, from: jsonData)
    }

    func encode<T>(_ value: T) -> Any? where T: Encodable {
        let jsonData = try? JSONEncoder().encode(value)
        return try? JSONSerialization.jsonObject(with: jsonData ?? Data.init(), options: .allowFragments)
    }
    
    func decodeAsArray<T>(_ type: T.Type) -> T? where T: Decodable {
        let jsonData = (try? JSONSerialization.data(withJSONObject: self.allValues, options: [])) ?? Data.init()
        return try? JSONDecoder().decode(type, from: jsonData)
    }
    
}
