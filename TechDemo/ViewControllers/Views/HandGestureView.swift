//
//  HandGestureView.swift
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 21.02.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

final class HandGestureView: XibView {
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!

    func update(with gesture: HandGesture) {
        emojiLabel.text = gesture.emoji
        textLabel.text = gesture.title
    }
}
