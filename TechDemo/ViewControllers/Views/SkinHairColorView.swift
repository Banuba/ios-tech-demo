//
//  SkinHairColorView.swift
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 17.03.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

final class SkinHairColorView: XibView {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundView.setCornerRadius(4)
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = UIColor.white.cgColor
    }
    
    func showSkinColor(_ color: UIColor) {
        label.text = "Skin Color"
        backgroundView.backgroundColor = color
    }
    
    func showHairColor(_ color: UIColor) {
        label.text = "Hair Color"
        backgroundView.backgroundColor = color
    }
}
