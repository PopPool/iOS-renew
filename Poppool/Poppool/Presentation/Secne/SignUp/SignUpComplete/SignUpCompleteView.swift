//
//  SignUpCompleteView.swift
//  Poppool
//
//  Created by SeoJunYoung on 11/27/24.
//

import UIKit

import SnapKit

final class SignUpCompleteView: UIView {
    
    // MARK: - Components
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "image_signUp_complete")
        return view
    }()
    
    private let titleTopLabel: PPLabel = {
        let label = PPLabel(style: .bold, fontSize: 20, text: "가입완료")
        return label
    }()
    
    private let titleMiddleStackView: UIStackView = {
        let view = UIStackView()
        return view
    }()
    
    let nickNameLabel: PPLabel = {
        let label = PPLabel(style: .bold, fontSize: 20)
        label.textColor = .blu500
        return label
    }()
    
    private let nickNameSubLabel: PPLabel = {
        let label = PPLabel(style: .bold, fontSize: 20, text: "님의")
        return label
    }()
    
    private let titleBottomLabel: PPLabel = {
        let label = PPLabel(style: .bold, fontSize: 20, text: "피드를 확인해보세요")
        return label
    }()
    
    private let titleStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        return view
    }()
    
    let categoryLabel: PPLabel = {
        let label = PPLabel(style: .bold, fontSize: 15)
        label.textColor = .g600
        return label
    }()
    
    private let categorySubLabel: PPLabel = {
        let label = PPLabel(style: .bold, fontSize: 15, text: "와")
        label.textColor = .g600
        return label
    }()
    
    private let categoryStackView: UIStackView = {
        let view = UIStackView()
        return view
    }()
    
    private let categoryBottomLabel: PPLabel = {
        let label = PPLabel(style: .bold, fontSize: 15, text: "연관된 팝업스토어 정보를 안내해드릴게요.")
        label.textColor = .g600
        return label
    }()
    
    let descriptionStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        return view
    }()
    
    let bottomButton: PPButton = {
        let button = PPButton(style: .primary, text: "바로가기")
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
private extension SignUpCompleteView {
    
    func setUpConstraints() {
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(80)
            make.top.equalToSuperview().inset(124)
        }
        
        titleMiddleStackView.addArrangedSubview(nickNameLabel)
        titleMiddleStackView.addArrangedSubview(nickNameSubLabel)
        
        titleStackView.addArrangedSubview(titleTopLabel)
        titleStackView.addArrangedSubview(titleMiddleStackView)
        titleStackView.addArrangedSubview(titleBottomLabel)
        
        self.addSubview(titleStackView)
        titleStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(32)
        }
        
        
        categoryStackView.addArrangedSubview(categoryLabel)
        categoryStackView.addArrangedSubview(categorySubLabel)
        
        descriptionStackView.addArrangedSubview(categoryStackView)
        descriptionStackView.addArrangedSubview(categoryBottomLabel)
        
        self.addSubview(descriptionStackView)
        descriptionStackView.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(bottomButton)
        bottomButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
    }
}
