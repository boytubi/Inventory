//
//  FirebaseDatabaseManager.swift
//  Inventory
//
//  Created by Hoang Truc on 4/7/21.
//  Copyright © 2021 Hoang Truc. All rights reserved.
//

import Foundation
import FirebaseDatabase

enum FirebaseError: Error {
    case encodingError
    case decodingError
}

class FirebaseDatabaseManager {
    static let shared = FirebaseDatabaseManager()
    
    private let databaseReference: DatabaseReference
    
    private init() {
        databaseReference = Database.database().reference()
    }
    
    func readOnce<T: Codable>(from endpoint: FirebaseDatabaseEndpoint,
                              completion: @escaping (T?) -> Void,
                              onError: ((Error) -> Void)? = nil) {
        let query = databaseReference.child(endpoint.path)
        query.keepSynced(endpoint.sysced)
        query.observeSingleEvent(of: .value, with: { snapshot in
            var decodedValue: T?
            if let value = snapshot.value as? NSDictionary {
                decodedValue = value.decodeAsArray(T.self)
                if decodedValue == nil {
                    decodedValue = value.decode(T.self)
                }
            }
            if let value = snapshot.value as? NSArray {
                decodedValue = value.decode(T.self)
            }
            if decodedValue == nil {
                onError?(FirebaseError.decodingError)
                return
            }
            completion(decodedValue)
        }) { (error) in
            onError?(error)
        }
    }
    
    func post<T: Codable>(from endpoint: FirebaseDatabaseEndpoint,
                          data: T,
                          createNewKey:Bool = false,
                          completion: ((Result<T, Error>) -> Void)? = nil) {
        var encodedData: Any?
        if let value = data.dictionary {
            encodedData = value
        }
        if let value = data.array {
            encodedData = value
        }
        if encodedData == nil {
            completion?(.failure(FirebaseError.encodingError))
            return
        }
        
        var reference: DatabaseReference = databaseReference.child(endpoint.path)
        if createNewKey { reference = reference.childByAutoId() }
        reference.setValue(encodedData) { (error, _) in
            if let error = error {
                completion?(.failure(error))
            }
            completion?(.success(data))
        }
    }
    
    func remove(from endpoint: FirebaseDatabaseEndpoint,
                completion: (() -> Void)?,
                onError: ((Error) -> Void)?) {
        databaseReference.child(endpoint.path).removeValue { (error, data) in
            if let error = error {
                onError?(error)
                return
            }
            completion?()
        }
    }
    
    func search<T: Codable>(from endPoint: FirebaseDatabaseEndpoint,
                            name value: String,
                            completion: @escaping (T?) -> Void) {
        let databaseRef = databaseReference.child(endPoint.path)
        let query = databaseRef.queryOrdered(byChild: "name")
                                .queryStarting(atValue: value)
                                .queryEnding(atValue: "\(value)\\u{f8ff}")
        query.keepSynced(endPoint.sysced)
        
        query.observeSingleEvent(of: .value, with: { snapshot in
            var decodeValue: T?
            guard snapshot.exists() != false else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                
                if let value = snapshot.value as? NSDictionary {
                    decodeValue = value.decodeAsArray(T.self)
                    if decodeValue == nil {
                        decodeValue = value.decode(T.self)
                    }
                }
                if let value = snapshot.value as? NSArray {
                    decodeValue = value.decode(T.self)
                }
                if decodeValue == nil {
                    return
                }
                completion(decodeValue)
            }
        })
    }
}
