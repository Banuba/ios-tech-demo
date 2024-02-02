//
//  NoCameraAccessViewController.swift
//  TechDemo
//
//  Created by Nickolai Nikishin on 9/12/18.
//  Copyright © 2018 Banuba. All rights reserved.
//

import UIKit

class NoCameraAccessViewController: UIViewController {

    @IBOutlet weak var allowCameraAccessButton: UIButton!
    @IBOutlet weak var noCameraImageViewCanvas: UIView!
    
    // MARK: - Styling
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allowCameraAccessButton.layer.cornerRadius = 21.0
        allowCameraAccessButton.layer.borderColor = UIColor.black.cgColor
        allowCameraAccessButton.layer.borderWidth = 1.0
        
        noCameraImageViewCanvas.layer.cornerRadius = 48.0
    }
    
    @IBAction func allowCameraAccessButtonTapped(_ sender: Any) {
        let settingsUrl = URL(string: UIApplication.openSettingsURLString)
        if let url = settingsUrl {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
