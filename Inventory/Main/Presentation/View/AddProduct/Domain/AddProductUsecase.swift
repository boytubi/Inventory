//
//  AddProductUsecase.swift
//  Inventory
//
//  Created by Hoang Truc on 4/8/21.
//  Copyright © 2021 Hoang Truc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol AddProductUsecaseProtocol {
    func addProduct(product: Product) -> Observable<Bool>
}

class AddProductUsecase: AddProductUsecaseProtocol {
    let repository : ProductInteractorProtocol = ProductInteractorRepository()
    let disposeBag = DisposeBag()
    
    func addProduct(product: Product) -> Observable<Bool> {
        return Observable<Bool>.create { [weak self] observer -> Disposable in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            self.repository
                .onNewProductPosted(product: product)
                .bind(to: observer)
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}
