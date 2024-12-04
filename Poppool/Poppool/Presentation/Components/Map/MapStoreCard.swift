//
//  MapStoreCard.swift
//  Poppool
//
//  Created by 김기현 on 12/3/24.
//

import UIKit
import SnapKit

final class MapStoreCard: UIView {

    // MARK: - Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .w100
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()

    private let handleView: UIView = {
        let view = UIView()
        view.backgroundColor = .g300
        view.layer.cornerRadius = 2
        return view
    }()

    private let storeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .g100
        return imageView
    }()

    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()

    private let categoryLabel: PPLabel = {
        let label = PPLabel(style: .regular, fontSize: 12)
        label.textColor = .blu500
        return label
    }()

    private let titleLabel: PPLabel = {
        let label = PPLabel(style: .bold, fontSize: 16)
        label.numberOfLines = 2
        return label
    }()

    private let locationLabel: PPLabel = {
        let label = PPLabel(style: .regular, fontSize: 12)
        label.textColor = .g400
        return label
    }()

    private let dateLabel: PPLabel = {
        let label = PPLabel(style: .regular, fontSize: 12)
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
private extension MapStoreCard {
    func setUpConstraints() {
        addSubview(containerView)
        containerView.addSubview(handleView)
        containerView.addSubview(storeImageView)
        containerView.addSubview(infoStackView)

        [categoryLabel, titleLabel, locationLabel, dateLabel].forEach {
            infoStackView.addArrangedSubview($0)
        }

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        handleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(4)
        }

        storeImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(handleView.snp.bottom).offset(16)
            make.size.equalTo(60)
        }

        infoStackView.snp.makeConstraints { make in
            make.leading.equalTo(storeImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(storeImageView)
        }
    }
}

// MARK: - Inputable
extension MapStoreCard: Inputable {
    struct Input {
        let image: UIImage?
        let category: String
        let title: String
        let location: String
        let date: String
    }

    func injection(with input: Input) {
        storeImageView.image = input.image
        categoryLabel.text = input.category
        titleLabel.text = input.title
        locationLabel.text = input.location
        dateLabel.text = input.date
    }
}
