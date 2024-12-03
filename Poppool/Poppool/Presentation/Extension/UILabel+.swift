//
//  UILabel+.swift
//  Poppool
//
//  Created by SeoJunYoung on 11/30/24.
//

import UIKit

extension UILabel {
    func setLineHeightText(text: String?) {
        guard let text = text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        self.attributedText = NSMutableAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
    }
}
