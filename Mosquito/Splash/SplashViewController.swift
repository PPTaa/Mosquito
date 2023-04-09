//
//  SplashViewController.swift
//  Mosquito
//
//  Created by leejungchul on 2023/03/13.
//

import UIKit

final class SplashViewController: UIViewController {
    
    let viewModel = SplashViewModel(service: MosquitoService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bind()
        viewModel.getMosquitoInfo()
    }
    
    private func bind() {
        let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeVC.modalTransitionStyle = .crossDissolve
        homeVC.modalPresentationStyle = .fullScreen
        viewModel.didMosquitoInfoEnd = { [weak self] in
//            print(#function)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.present(homeVC, animated: true)
            }
        }
    }
    
}

