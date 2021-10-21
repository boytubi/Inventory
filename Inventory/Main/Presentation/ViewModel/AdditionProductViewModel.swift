//
//  AdditionProductViewModel.swift
//  Inventory
//
//  Created by Hoang Truc on 4/7/21.
//  Copyright © 2021 Hoang Truc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

class AdditionProductViewModel: ViewModelType {
    let disposeBag = DisposeBag()
    
    struct Input {
        let triggerAppear: Driver<Void>
        let inputSearch: Driver<String>
    }
    
    struct Output {
        let product: PublishRelay<Product> = .init()
        let products: BehaviorRelay<[Product]> = .init(value: [])
    }
    
    let usecase : ProductInteractorProtocol = ProductInteractorRepository()
    var output : Output!
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.triggerAppear.drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.createNewProduct()
        }).disposed(by: disposeBag)
        
        input.inputSearch.drive(onNext: { [weak self] text in
            guard let self = self else { return }
            self.searchProduct(name: text)
        }).disposed(by: disposeBag)
        
        self.output = output
        return output
    }
}

extension AdditionProductViewModel {
    func createNewProduct() {
//        let productRequest = Product(name: "Ốc", price: 10000, quantity: 2)
//        self.usecase
//            .onNewProductPosted(product: productRequest)
//            .subscribe(onNext: { [weak self] product in
//                guard let self = self else { return }
//                self.output.product.accept(product)
//        }).disposed(by: disposeBag)
    }
    
    func searchProduct(name: String) {
        self.usecase
            .onSearchProduct(name: name)
            .bind(to: self.output.products)
            .disposed(by: disposeBag)
    }
}
