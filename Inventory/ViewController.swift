//
//  ViewController.swift
//  Inventory
//
//  Created by Hoang Truc on 4/6/21.
//  Copyright © 2021 Hoang Truc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var tableResult: UITableView!
    @IBOutlet weak var edSearch: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    
    let viewModel = AdditionProductViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        tableResult.registerCell(for: "ProductCell")
        tableResult.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        let observerInputSearch = edSearch.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .asDriverOnErrorJustComplete()
        let input = AdditionProductViewModel.Input(triggerAppear: rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).mapToVoid().asDriverOnErrorJustComplete(),
                                                   inputSearch: observerInputSearch)
        let output = viewModel.transform(input: input)
        
        output.product.subscribe(onNext: { product in
            print(product)
        }).disposed(by: disposeBag)
        
        output.products.bind(to: tableResult.rx.items(cellIdentifier: "ProductCell", cellType: ProductCell.self)) { (_, element, cell) in
            cell.configCell(product: element)
        }.disposed(by: disposeBag)
        
        btnAdd.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let addView = AddProductView(frame: self.view.bounds)
            addView.show(in: self.view)
        }).disposed(by: disposeBag)
    }
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        return map { _ in}
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            assertionFailure("Error \(error)")
            return Driver.empty()
        }
    }
}

extension UITableView {
    func registerCell(for id: String) {
        let nib = UINib(nibName: id, bundle: nil)
        register(nib, forCellReuseIdentifier: id)
    }
}
