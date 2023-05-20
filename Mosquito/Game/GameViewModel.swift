//
//  GameViewModel.swift
//  Mosquito
//
//  Created by leejungchul on 2023/05/20.
//

import RxSwift
import RxCocoa

final class GameViewModel {
    private let disposeBag = DisposeBag()
    
    // vc -> vm
    let tapButton: PublishSubject<Void> = PublishSubject()
    
    // vm -> vc
    let tapCount: BehaviorSubject<Int> = BehaviorSubject(value: 0)
        
    init() {
        tapButton
            .withLatestFrom(tapCount)
            .map { $0 + 1 }
            .bind(to: tapCount)
            .disposed(by: disposeBag)
        
        
    }
}
