//
//  UICollectionView+Extension.swift
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 02.02.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

import UIKit

extension UICollectionView {
    func registerReusableCell(_ cell: ReusableCell.Type) {
        register(cell.nib, forCellWithReuseIdentifier: cell.reuseIdentifier)
    }
}
