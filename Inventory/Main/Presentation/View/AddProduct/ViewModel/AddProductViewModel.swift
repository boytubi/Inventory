//
//  AddProductViewModel.swift
//  Inventory
//
//  Created by Hoang Truc on 4/8/21.
//  Copyright © 2021 Hoang Truc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Validator

struct ValidatorError: ValidationError {
    public let message: String
    
    public init(message m: String) {
        message = m
    }
}

class AddProductViewModel: ViewModelType {
    typealias Usecase = AddProductUsecaseProtocol
    var usecase : Usecase = AddProductUsecase()
    let disposeBag = DisposeBag()
    
    struct Input {
        let actionAdd: Driver<Void>
        let inputName: Driver<String>
        let inputPrice: Driver<String>
        let inputNumber: Driver<String>
    }
    struct Output {
        let isAdded: PublishRelay<Bool> = .init()
        let isMatched: BehaviorRelay<Bool> = .init(value: false)
    }
    
    var output: Output!
    private var product = Product()
    let valid = ValidationRuleLength(min: 1,
                                     max: 100,
                                     lengthType: .utf8,
                                     error: ValidatorError(message: "Invalidate"))
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        let nameValid = input.inputName.map { [weak self] name -> Bool in
            guard let self = self else { return false }
            self.product.name = name
            return name.validate(rule: self.valid).isValid
        }
        
        let priceValid = input.inputPrice.map { [weak self] price -> Bool in
            guard let self = self else { return false }
            if let price = Double(price) {
                self.product.price = price
            }
            return price.validate(rule: self.valid).isValid
        }
        
        let numberValid = input.inputNumber.map { [weak self] number -> Bool in
            guard let self = self else { return false }
            if let number = Int(number) {
                self.product.quantity = number
            }
            return number.validate(rule: self.valid).isValid
        }
        
        input.actionAdd.drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.addProduct(product: self.product)
        }).disposed(by: disposeBag)
        
        Driver.combineLatest(nameValid, priceValid, numberValid) {
            $0 && $1 && $2
        }.drive(onNext: { isMatched in
            output.isMatched.accept(isMatched)
        }).disposed(by: disposeBag)
        
        self.output = output
        return output
    }
}

extension AddProductViewModel {
    func addProduct(product: Product) {
        usecase.addProduct(product: product)
            .bind(to: output.isAdded)
            .disposed(by: disposeBag)
    }
}
