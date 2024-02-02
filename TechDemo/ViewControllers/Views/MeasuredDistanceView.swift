//
//  MeasuredDistanceView.swift
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 13.03.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

final class MeasuredDistanceView: XibView {
    @IBOutlet weak var label: UILabel!

    func update(with distance: String) {
        label.text = "Distance: \(distance) cm"
    }
}
