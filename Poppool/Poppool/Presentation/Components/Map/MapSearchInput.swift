//
//  MapSearchInput.swift
//  Poppool
//
//  Created by 김기현 on 12/3/24.
//

import UIKit
import SnapKit

final class MapSearchInput: UIView {

    // MARK: - Components
    let searchContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .w100
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        return view
    }()

    let searchIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_search")
        imageView.tintColor = .g900
        return imageView
    }()

    let searchLabel: PPLabel = {
        let label = PPLabel(style: .regular, fontSize: 14)
        label.text = "지역, 팝업스토어를 검색해보세요"
        label.textColor = .g400
        return label
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
private extension MapSearchInput {
    func setUpConstraints() {
        addSubview(searchContainerView)
        searchContainerView.addSubview(searchIconImageView)
        searchContainerView.addSubview(searchLabel)

        searchContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(48)
        }

        searchIconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }

        searchLabel.snp.makeConstraints { make in
            make.leading.equalTo(searchIconImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
}
