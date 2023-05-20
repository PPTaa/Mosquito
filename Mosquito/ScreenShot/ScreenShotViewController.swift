//
//  ScreenShotViewController.swift
//  Mosquito
//
//  Created by leejungchul on 2023/03/14.
//

import UIKit
import SnapKit
import GoogleMobileAds

final class ScreenShotViewController: UIViewController {
    
    @IBOutlet weak var screenShotImageView: UIImageView!
    
    private var bannerView = GADBannerView()
    
    var imageFrame = CGRect()
    var screenShotImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenShotImageView.frame = imageFrame
        screenShotImageView.image = screenShotImage
        attribute()
        layout()
    }
    
    private func attribute() {
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = Constants.GoogleAds.realBannerAdKey
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
    
    private func layout() {
        [bannerView].forEach {
            view.addSubview($0)
        }
        bannerView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
        }
    }
    
    @IBAction func tapBack(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension ScreenShotViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 1
        }
    }
}
