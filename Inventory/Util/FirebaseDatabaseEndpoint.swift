//
//  FirebaseDatabaseEndpoint.swift
//  Inventory
//
//  Created by Hoang Truc on 4/7/21.
//  Copyright © 2021 Hoang Truc. All rights reserved.
//

import Foundation

protocol FirebaseDatabaseEndpoint {
    var path: String { get }
    var sysced: Bool { get }
}

extension FirebaseDatabaseEndpoint {
    func retrive<T: Codable>(completion: @escaping (T?) -> Void,
                             onError: ((Error) -> Void)? = nil) {
        FirebaseDatabaseManager.shared.readOnce(from: self,
                                                       completion: completion,
                                                       onError: onError)
    }
    
    func post<T: Codable>(data: T,
                          createNewKey: Bool = false,
                          completion: ((Result<T, Error>) -> Void)? = nil) {
        FirebaseDatabaseManager.shared.post(from: self,
                                            data: data,
                                            createNewKey: createNewKey,
                                            completion: completion)
    }
    
    func remove(completion: (() -> Void)?,
                onError: ((Error) -> Void)?) {
        FirebaseDatabaseManager.shared.remove(from: self, completion: completion, onError: onError)
    }
    
    func retriveSearch<T: Codable>(name: String, completion: @escaping (T?) -> Void) {
        FirebaseDatabaseManager.shared.search(from: self, name: name, completion: completion)
    }
}
