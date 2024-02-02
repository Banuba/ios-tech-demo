//
//  UIView+Extension.swift
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 02.02.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

import UIKit

extension UIView {
    func addBorderConstraints(toView: UIView) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: toView.topAnchor),
            leadingAnchor.constraint(equalTo: toView.leadingAnchor),
            trailingAnchor.constraint(equalTo: toView.trailingAnchor),
            bottomAnchor.constraint(equalTo: toView.bottomAnchor)
        ])
    }
    
    func setCornerRadius(_ radius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
    }
}
