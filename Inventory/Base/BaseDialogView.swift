//
//  BaseDialogView.swift
//  Inventory
//
//  Created by Hoang Truc on 4/8/21.
//  Copyright © 2021 Hoang Truc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseDialogView: UIView {
    
    var nibNameView: String?
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initWithNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initWithNib()
    }
    
    func initWithNib() {
        guard let view = UINib(nibName: nibNameView ?? self.className(), bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
        self.backgroundColor = .clear
        commonSetup()
    }
    
    func commonSetup() {}
    
    func className() -> String {
        if let name = NSStringFromClass(type(of: self)).components(separatedBy: ".").last {
            return name
        } else {
            return ""
        }
    }
}
