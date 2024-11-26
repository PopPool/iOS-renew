//
//  AgeSelectedView.swift
//  Poppool
//
//  Created by SeoJunYoung on 11/26/24.
//

import UIKit

import SnapKit

final class AgeSelectedView: UIView {
    
    // MARK: - Components
    private let titleLabel: PPLabel = {
        let label = PPLabel(style: .bold, fontSize: 18, text: "나이를 선택해주세요")
        return label
    }()
    
    let picker: PPPicker = {
        let ageRange = (0...100).map { "\($0)세"}
        let picker = PPPicker(components: ageRange)
        return picker
    }()
    
    let cancelButton: PPButton = {
        let button = PPButton(style: .secondary, text: "취소")
        return button
    }()
    
    let completeButton: PPButton = {
        let button = PPButton(style: .primary, text: "확인", disabledText: "확인")
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.spacing = 12
        return view
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
private extension AgeSelectedView {
    
    func setUpConstraints() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.addSubview(picker)
        picker.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(208)
        }
        
        self.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(picker.snp.bottom).offset(24)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(completeButton)
    }
}