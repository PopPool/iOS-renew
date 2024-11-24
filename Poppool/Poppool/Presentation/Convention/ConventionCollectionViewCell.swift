//
//  ConventionCollectionViewCell.swift
//  MomsVillage
//
//  Created by SeoJunYoung on 9/27/24.
//

import UIKit

import SnapKit

final class ConventionCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Components

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - SetUp
private extension ConventionCollectionViewCell {
    func setUpConstraints() {
    }
}

extension ConventionCollectionViewCell: Inputable {
    struct Input {
    }
    
    func injection(with input: Input) {
    }
}
