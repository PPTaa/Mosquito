//
//  ShareViewController.swift
//  Mosquito
//
//  Created by leejungchul on 2023/03/14.
//

import UIKit
import Lottie

class LoadingHUD {
    private static let sharedInstance = LoadingHUD()
    
    private var animationView: LottieAnimationView?
    private var backView: UIView?
    private var containerView: UIView?

    class func show() {
        var backView = UIView()
        backView.backgroundColor = .black.withAlphaComponent(0.65)
        var containerView = UIView(frame: CGRectMake(0, 0, 200, 200))
        var animationView = LottieAnimationView()
//        containerView.backgroundColor = UIColor.cyan
    
        // 2. Start AnimationView with animation name (without extension)
        animationView = .init(name: "loading2")
        animationView.frame = containerView.bounds

        // 3. Set animation content mode
        animationView.contentMode = .scaleAspectFit

        // 4. Set animation loop mode
        animationView.loopMode = .loop

        // 5. Adjust animation speed
        animationView.animationSpeed = 1.0
        containerView.addSubview(animationView)
        
        backView.addSubview(containerView)
        // popupView를 UIApplication의 window에 추가하고, popupView의 center를 window의 center와 동일하게 합니다.
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(backView)
            backView.frame = window.frame
            backView.center = window.center
            containerView.center = backView.center
            
            animationView.play()
            sharedInstance.backView?.removeFromSuperview()
            sharedInstance.backView = backView
            sharedInstance.containerView = containerView
            sharedInstance.animationView = animationView
        }
    }
    class func hide() {
        if let backView = sharedInstance.backView {
            backView.removeFromSuperview()
        }
        if let containerView = sharedInstance.containerView {
            containerView.removeFromSuperview()
        }
        if let animationView = sharedInstance.animationView {
            animationView.removeFromSuperview()
            animationView.stop()
        }
    }
}
