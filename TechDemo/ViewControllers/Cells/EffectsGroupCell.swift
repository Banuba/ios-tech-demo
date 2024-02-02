//
//  EffectsGroupCell.swift
//  TechDemo
//
//  Created by Alexey Ereschenko on 28/08/2018.
//  Copyright © 2018 Banuba. All rights reserved.
//

import UIKit

struct EffectsGroupCellViewModel: Hashable {
    let title: String
    let isSelected: Bool
}

final class EffectsGroupCell: ReusableCell {
    @IBOutlet weak var label: UILabel!
    
    override var bounds: CGRect {
        didSet {
            layer.cornerRadius = bounds.height / 2
        }
    }

    static func requiredWidth(with viewModel: EffectsGroupCellViewModel) -> CGFloat {
        let padding: CGFloat = 27
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .light)]
        let requiredWidth = (viewModel.title as NSString).size(withAttributes: fontAttributes).width.rounded(.up) + padding * 2
        return requiredWidth
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.black.cgColor
    }
    
    func update(with viewModel: EffectsGroupCellViewModel) {
        label.text = viewModel.title
        layer.borderWidth = viewModel.isSelected ? 1 : 0
    }
}
