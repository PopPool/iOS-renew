//
//  ViewConvention.swift
//  MomsVillage
//
//  Created by SeoJunYoung on 9/20/24.
//
import UIKit

import SnapKit

final class ViewConvention: UIView {
    
    // MARK: - Components
    
    // MARK: - init
    init() {
        super.init(frame: .zero)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension ViewConvention {
    
    func setUpConstraints() {
    }
}
