//
//  ScreenShotViewController.swift
//  Mosquito
//
//  Created by leejungchul on 2023/03/14.
//

import UIKit

final class ScreenShotViewController: UIViewController {
    
    @IBOutlet weak var screenShotImageView: UIImageView!
    
    var imageFrame = CGRect()
    var screenShotImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenShotImageView.frame = imageFrame
        screenShotImageView.image = screenShotImage
    }
    
    @IBAction func tapBack(_ sender: Any) {
        dismiss(animated: true)
    }
}
