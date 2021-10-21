//
//  AddProductView.swift
//  Inventory
//
//  Created by Hoang Truc on 4/8/21.
//  Copyright © 2021 Hoang Truc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddProductView: BaseDialogView {
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnAddProduct: UIButton!
    @IBOutlet weak var edName: UITextField!
    @IBOutlet weak var edPrice: UITextField!
    @IBOutlet weak var edNumber: UITextField!
    
    private var origin: CGPoint = .zero
    private let viewModel: AddProductViewModel = .init()
    
    override func commonSetup() {
        btnCancel.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.hide()
            }).disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        let input = AddProductViewModel.Input(actionAdd: btnAddProduct.rx.tap.asDriver(),
                                              inputName: edName.rx.text.orEmpty.debounce(.milliseconds(500), scheduler: MainScheduler.instance).asDriverOnErrorJustComplete(),
                                              inputPrice: edPrice.rx.text.orEmpty.debounce(.milliseconds(500), scheduler: MainScheduler.instance).asDriverOnErrorJustComplete(),
                                              inputNumber: edNumber.rx.text.orEmpty.debounce(.milliseconds(500), scheduler: MainScheduler.instance).asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.isAdded.subscribe(onNext: { [weak self] isAdded in
            guard let self = self else { return }
            if isAdded {
                self.hide()
            }
        }).disposed(by: disposeBag)
        
        output.isMatched.subscribe(onNext: { [weak self] isMatched in
            guard let self = self else { return }
            if isMatched {
                self.btnAddProduct.isUserInteractionEnabled = true
                self.btnAddProduct.backgroundColor = .systemTeal
            } else {
                self.btnAddProduct.isUserInteractionEnabled = false
                self.btnAddProduct.backgroundColor = .lightGray
            }
        }).disposed(by: disposeBag)
    }
    
    func show(in view: UIView) {
        configView()
        bindViewModel()
        
        for subView in view.subviews {
            if subView is Self {
                subView.removeFromSuperview()
            }
        }
        view.addSubview(self)
        self.dialogView.alpha = 0
        dialogView.center.y = -dialogView.center.y
        UIView.animate(withDuration: 0.4) {
            self.dialogView.alpha = 1
            self.dialogView.center = self.origin
        }
    }
    
    func hide(animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.4, animations: {
                self.dialogView.center.y = -self.dialogView.center.y
                self.dialogView.alpha = 0
            }) { (isCompleted) in
                self.removeFromSuperview()
            }
        } else {
            self.removeFromSuperview()
        }
    }
    
    func configView() {
        edPrice.keyboardType = .numberPad
        edNumber.keyboardType = .numberPad
        edNumber.text = "\(1)"
    }
}
