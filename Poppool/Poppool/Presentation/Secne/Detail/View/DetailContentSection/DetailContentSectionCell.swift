//
//  DetailContentSectionCell.swift
//  Poppool
//
//  Created by SeoJunYoung on 12/10/24.
//

import UIKit

import SnapKit
import RxSwift

final class DetailContentSectionCell: UICollectionViewCell {
    
    // MARK: - Components

    private let contentLabel: PPLabel = {
        let label = PPLabel(style: .regular, fontSize: 13)
        label.numberOfLines = 0
        return label
    }()
    
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
private extension DetailContentSectionCell {
    func setUpConstraints() {
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension DetailContentSectionCell: Inputable {
    struct Input {
        var content: String?
    }
    
    func injection(with input: Input) {
        contentLabel.setLineHeightText(text: input.content)
    }
}
