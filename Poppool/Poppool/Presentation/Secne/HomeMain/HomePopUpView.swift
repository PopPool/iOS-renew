//
//  HomePopUpView.swift
//  Poppool
//
//  Created by Porori on 11/27/24.
//

import UIKit
import SnapKit

final class HomePopUpView: UIView {
    
    // MARK: - Components
    
    let header: PPReturnHeaderView = PPReturnHeaderView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - 56) / 2
        let height: CGFloat = 251
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 16
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.contentInset = UIEdgeInsets(top: 24, left: 20, bottom: 0, right: 20)
        return collection
    }()
    
    // MARK: - init
    init() {
        super.init(frame: .zero)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension HomePopUpView {
    
    func setUp() {
        collectionView.showsVerticalScrollIndicator = false
    }
    
    func setUpConstraints() {
        addSubview(header)
        header.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(60)
        }
    }
}
