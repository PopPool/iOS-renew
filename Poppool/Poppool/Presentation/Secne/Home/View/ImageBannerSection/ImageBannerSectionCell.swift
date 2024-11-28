//
//  ImageBannerSectionCell.swift
//  Poppool
//
//  Created by SeoJunYoung on 11/28/24.
//

import UIKit

import SnapKit
import RxSwift

final class ImageBannerSectionCell: UICollectionViewCell {
    
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
private extension ImageBannerSectionCell {
    func setUpConstraints() {
    }
}

extension ImageBannerSectionCell: Inputable {
    struct Input {

    }
    
    func injection(with input: Input) {

    }
}
