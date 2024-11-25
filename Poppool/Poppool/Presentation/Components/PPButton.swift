//
//  PPButton.swift
//  Poppool
//
//  Created by SeoJunYoung on 11/25/24.
//

import UIKit

class PPButton: UIButton {
    
    enum ButtonStyle {
        case primary
        case secondary
        case tertiary
        
        var backgroundColor: UIColor {
            switch self {
            case .primary:
                return .blu500
            case .secondary:
                return .g50
            case .tertiary:
                return .blu500
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .primary:
                return .w100
            case .secondary:
                return .g50
            case .tertiary:
                return .blu500
            }
        }
        
        var disabledBackgroundColor: UIColor {
            switch self {
            case .primary:
                return .blu500
            case .secondary:
                return .g50
            case .tertiary:
                return .blu500
            }
        }
        
        var disabledTextColor: UIColor {
            switch self {
            case .primary:
                return .w100
            case .secondary:
                return .g50
            case .tertiary:
                return .blu500
            }
        }
    }
    
    
    init(
        style: ButtonStyle,
        text: String,
        disabledText: String = "",
        font: UIFont? = .KorFont(style: .medium, size: 16),
        cornerRadius: CGFloat = 4
    ) {
        super.init(frame: .zero)
        
        self.setTitle(text, for: .normal)
        self.setTitle(disabledText, for: .disabled)
        
        self.setTitleColor(style.textColor, for: .normal)
        self.setTitleColor(style.disabledTextColor, for: .disabled)
        
        self.setBackgroundImage(.init(color: style.backgroundColor), for: .normal)
        self.setBackgroundImage(.init(color: style.disabledBackgroundColor), for: .disabled)
    
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
