//
//  DetailView.swift
//  Poppool
//
//  Created by SeoJunYoung on 12/9/24.
//

import UIKit

import SnapKit

final class DetailView: UIView {
    
    // MARK: - Components
    let contentCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    let commentPostButton: PPButton = {
        let button = PPButton(style: .primary, text: "코멘트 작성하기")
        return button
    }()
    
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
private extension DetailView {
    
    func setUpConstraints() {
        self.addSubview(commentPostButton)
        commentPostButton.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
        self.addSubview(contentCollectionView)
        contentCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(commentPostButton.snp.top)
        }
    }
}
