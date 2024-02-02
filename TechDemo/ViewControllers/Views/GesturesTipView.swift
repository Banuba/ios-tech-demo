//
//  GesturesTipView.swift
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 21.02.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

final class GesturesTipView: XibView {
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var closeHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let text =
        """
        \t👍\t”Like”
        \t👌\t”Ok”
        \t🤘\t”Rock”
        \t✌️\t”Victory”
        \t✋\t”Palm”
        """
        let paragraphStyle = NSMutableParagraphStyle()
        let first = NSTextTab(textAlignment: .right, location: 30)
        let second = NSTextTab(textAlignment: .left, location: 40)
        paragraphStyle.tabStops = [first, second]
        paragraphStyle.lineSpacing = 18

        listLabel.attributedText = NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ])
        
        closeButton.setCornerRadius(21)
        self.setCornerRadius(16)
    }
    
    @IBAction private func closeTapped(_ sender: UIButton) {
        closeHandler?()
    }
}
