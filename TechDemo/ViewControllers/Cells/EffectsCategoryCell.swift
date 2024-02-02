//
//  TechnologyCell.swift
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 03.02.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

import UIKit

struct EffectsCategoryCellViewModel: Hashable {
    let title: String
    let isSelected: Bool
    
    init(category: EffectsCategory, isSelected: Bool) {
        self.title = category.title
        self.isSelected = isSelected
    }
}

final class EffectsCategoryCell: ReusableCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var indicatorView: UIView!

    class func requiredWidth(with viewModel: EffectsCategoryCellViewModel) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .light)]
        let requiredWidth = (viewModel.title.uppercased() as NSString).size(withAttributes: fontAttributes).width.rounded(.up)
        return requiredWidth
    }
    
    func update(with viewModel: EffectsCategoryCellViewModel) {
        label.text = viewModel.title.uppercased()
        indicatorView.isHidden = !viewModel.isSelected
    }
}
