//
//  TechnologyCell.swift
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 02.02.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

import UIKit

struct TechnologyCellViewModel: Hashable {
    let title: String
    let isSelected: Bool
    
    init(technology: Technology, isSelected: Bool) {
        title = technology.title
        self.isSelected = isSelected
    }
}

final class TechnologyCell: ReusableCell {
    @IBOutlet weak var titleLabel: UILabel!

    func update(with viewModel: TechnologyCellViewModel) {
        titleLabel.text = viewModel.title.uppercased()
        let font = UIFont.systemFont(ofSize: 14, weight: viewModel.isSelected ? .bold : .light)
        titleLabel.font = font
        titleLabel.textColor = viewModel.isSelected ? .black : .init(gray: 102)
    }
}
