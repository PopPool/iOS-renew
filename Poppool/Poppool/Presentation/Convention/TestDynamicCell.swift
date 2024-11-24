//
//  TestDynamicCell.swift
//  MomsVillage
//
//  Created by SeoJunYoung on 9/27/24.
//

import UIKit

import SnapKit
import RxSwift

final class TestDynamicCell: UICollectionViewCell {
    
    // MARK: - Components

    let disposeBag = DisposeBag()
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
private extension TestDynamicCell {
    func setUpConstraints() {
    }
}

extension TestDynamicCell: Inputable {
    struct Input {

    }
    
    func injection(with input: Input) {

    }
}
