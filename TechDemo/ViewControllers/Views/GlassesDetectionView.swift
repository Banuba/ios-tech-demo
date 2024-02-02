//
//  GlassesDetectionView.swift
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 13.03.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

final class GlassesDetectionView: XibView {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundView.setCornerRadius(4)
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = UIColor.white.cgColor
    }
    
    func update(with isPresent: Bool) {
        backgroundView.backgroundColor = isPresent ? UIColor(rgb: 0x5C8570) : UIColor(rgb: 0xCC4957)
        imageView.image = isPresent ? UIImage(named: "glasses_detected") : UIImage(named: "no_glasses_detected")
    }
}
