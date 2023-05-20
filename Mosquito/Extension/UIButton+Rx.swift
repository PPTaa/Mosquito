//
//  UIButton+Rx.swift
//  Mosquito
//
//  Created by leejungchul on 2023/05/20.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIButton {
    var touchDown: ControlEvent<Void> {
        return controlEvent(.touchDown)
    }
    var touchUpInside: ControlEvent<Void> {
        return controlEvent(.touchUpInside)
    }
}
