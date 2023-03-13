//
//  ShareViewController.swift
//  Mosquito
//
//  Created by leejungchul on 2023/03/14.
//

import UIKit

class ShareViewController: UIViewController {
    @IBOutlet weak var screenShotImageView: UIImageView!
    
    var imageFrame = CGRect()
    var screenShotImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
    }
    
    private func attribute() {
        // imageSetting
        screenShotImageView.frame = imageFrame
        screenShotImageView.image = screenShotImage
        
        //
        
    }
    
    @IBAction func tapShareContent(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            print(#function, "카카오톡")
        case 2:
            print(#function, "인스타그램")
        case 3:
            print(#function, "페이스북")
        case 4:
            print(#function, "링크복사")
        default:
            print(#function, "error")
        }
    }
    
    
    
    @IBAction func tapBack(_ sender: Any) {
        print(#function, sender)
        dismiss(animated: true)
    }

}
