//
//  HomeTitleSectionCell.swift
//  Poppool
//
//  Created by SeoJunYoung on 11/30/24.
//

import UIKit

import SnapKit
import RxSwift

final class HomeTitleSectionCell: UICollectionViewCell {
    
    // MARK: - Components

    var disposeBag = DisposeBag()
    
    private var blueLabel: PPLabel = {
        let label = PPLabel(style: .bold, fontSize: 16)
        label.textColor = .blu500
        return label
    }()
    
    private let subLabel: PPLabel = {
        let label = PPLabel(style: .bold, fontSize: 16)
        return label
    }()
    
    private let bottomLabel: PPLabel = {
        let label = PPLabel(style: .bold, fontSize: 16)
        return label
    }()
    
    let detailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_right_gray"), for: .normal)
        return button
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

// MARK: - SetUp
private extension HomeTitleSectionCell {
    func setUpConstraints() {
        contentView.addSubview(blueLabel)
        blueLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview()
        }
        contentView.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.leading.equalTo(blueLabel.snp.trailing)
            make.top.equalToSuperview()
        }
        contentView.addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
        contentView.addSubview(detailButton)
        detailButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }
}

extension HomeTitleSectionCell: Inputable {
    struct Input {
        var blueText: String?
        var topSubText: String?
        var bottomText: String?
        var backgroundColor: UIColor? = .clear
        var textColor: UIColor? = .g1000
    }
    
    func injection(with input: Input) {
        blueLabel.setLineHeightText(text: input.blueText)
        subLabel.setLineHeightText(text: input.topSubText)
        bottomLabel.setLineHeightText(text: input.bottomText)
        contentView.backgroundColor = input.backgroundColor
        subLabel.textColor = input.textColor
        bottomLabel.textColor = input.textColor
    }
}
