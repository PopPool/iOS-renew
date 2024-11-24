//
//  LoginView.swift
//  Poppool
//
//  Created by SeoJunYoung on 11/24/24.
//

import UIKit

import SnapKit

final class LoginView: UIView {
    
    // MARK: - Components
    
    // MARK: - init
    init() {
        super.init(frame: .zero)
        setUpConstraints()
        self.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension LoginView {
    
    func setUpConstraints() {
    }
}
