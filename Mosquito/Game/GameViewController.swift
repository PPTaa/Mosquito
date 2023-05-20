//
//  GameViewController.swift
//  Mosquito
//
//  Created by leejungchul on 2023/05/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class GameViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = GameViewModel()
    
    private let clickerButton = UIButton()
    
    private let timerLabel = UILabel()
    private let countLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        bind(viewModel: viewModel)
    }
    
    private func bind(viewModel: GameViewModel) {
        // button blink animation
        clickerButton.rx.touchDown
            .bind(onNext: { [weak self] in
//                self?.clickerButton.backgroundColor = .black
                self?.clickerButton.setBackgroundImage(UIImage(named: "stageIcon4"), for: .normal)
            })
            .disposed(by: disposeBag)
        
        clickerButton.rx.touchUpInside
            .bind(onNext: { [weak self] in
//                self?.clickerButton.backgroundColor = .red
                self?.clickerButton.setBackgroundImage(UIImage(named: "stageIcon1"), for: .normal)
            })
            .disposed(by: disposeBag)
        
        // vc -> vm
        clickerButton.rx.tap
            .bind(to: viewModel.tapButton)
            .disposed(by: disposeBag)
        
        
        
        // vm -> vc
        viewModel.tapCount
            .map { String($0) }
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white

        clickerButton.adjustsImageWhenHighlighted = false
        clickerButton.setTitle("tap Mosquito", for: .normal)
        clickerButton.setTitleColor(.yellow, for: .normal)
        clickerButton.setBackgroundImage(UIImage(named: "stageIcon1"), for: .normal)
        
        timerLabel.text = "timer"
        
        countLabel.text = "0"
    }
    
    private func layout() {
        [clickerButton, timerLabel, countLabel].forEach {
            view.addSubview($0)
        }
        
        timerLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        countLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(clickerButton.snp.top).offset(20)
        }
        clickerButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.width.equalTo(200)
        }
        
    }
    
}
