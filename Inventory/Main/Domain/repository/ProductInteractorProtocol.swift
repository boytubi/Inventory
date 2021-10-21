//
//  ProductInteractorProtocol.swift
//  Inventory
//
//  Created by Hoang Truc on 4/7/21.
//  Copyright © 2021 Hoang Truc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ProductInteractorProtocol {
    func onNewProductPosted(product: Product) -> Observable<Bool>
    func onProductsRetrived(product: [Product])
    func onProductDetailFetched(product: Product)
    func onSearchProduct(name: String) -> Observable<[Product]>
}

class ProductInteractorRepository : ProductInteractorProtocol {
    
    func onNewProductPosted(product: Product) -> Observable<Bool> {
        return Observable<Bool>.create { observer -> Disposable in
            ProductEndPoint.postProduct.post(data: product, createNewKey: true) { result in
                switch result {
                case .success(_):
                    observer.onNext(true)
                case .failure(let error):
                    observer.onNext(false)
                    print(error.localizedDescription)
                }
            }
            return Disposables.create()
        }
    }
    
    func onProductsRetrived(product: [Product]) {
        
    }
    
    func onProductDetailFetched(product: Product) {
        
    }
    
    func onSearchProduct(name: String) -> Observable<[Product]> {
        return Observable<[Product]>.create { observer -> Disposable in
            ProductEndPoint.searchProduct.retriveSearch(name: name) { (products: [Product]?) in
                if let products = products {
                    observer.onNext(products)
                } else {
                    observer.onNext([])
                }
            }
            return Disposables.create()
        }
    }
}
