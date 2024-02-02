//
//  ReusableCell.swift
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 03.02.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

import UIKit

class ReusableCell: UICollectionViewCell {
    static var reuseIdentifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: reuseIdentifier, bundle: nil) }
}
