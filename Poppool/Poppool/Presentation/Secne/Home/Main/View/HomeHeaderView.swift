//
//  HomeHeaderView.swift
//  Poppool
//
//  Created by SeoJunYoung on 11/30/24.
//

import UIKit

import SnapKit

final class HomeHeaderView: UIView {
    
    // MARK: - Components
    
    let searchBarButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        return button
    }()
    
    let noticeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_notice"), for: .normal)
        return button
    }()
    
    let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
    lazy var blurView = UIVisualEffectView(effect: blurEffect)
    
    private let searchIconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "icon_search")
        return view
    }()
    
    private let searchLabel: PPLabel = {
        let label = PPLabel(style: .regular, fontSize: 14, text: "팝업스토어명을 입력해보세요")
        label.textColor = .w100
        label.isUserInteractionEnabled = false
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
    
    func setHeaderState(isDarkMode: Bool) {
        blurView.isHidden = !isDarkMode
        blurView.isUserInteractionEnabled = false
        if isDarkMode {
            searchBarButton.backgroundColor = .clear
            searchLabel.textColor = .w100
            searchIconImageView.image = UIImage(named: "icon_search")
            searchIconImageView.tintColor = .white
            let image = UIImage(named: "icon_notice")?.withRenderingMode(.alwaysTemplate)
            noticeButton.setImage(image, for: .normal)
            noticeButton.tintColor = .white
        } else {
            searchBarButton.backgroundColor = .white
            searchLabel.textColor = .g400
            searchIconImageView.image = UIImage(named: "icon_search_gray")
            searchIconImageView.tintColor = .blu500
            let image = UIImage(named: "icon_notice")?.withRenderingMode(.alwaysTemplate)
            noticeButton.setImage(image, for: .normal)
            noticeButton.tintColor = .g400
        }
    }
}

// MARK: - SetUp
private extension HomeHeaderView {
    
    func setUpConstraints() {
        self.addSubview(noticeButton)
        noticeButton.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
 
        blurView.layer.cornerRadius = 4
        blurView.clipsToBounds = true
        searchBarButton.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalTo(searchBarButton)
        }
        
        self.addSubview(searchBarButton)
        searchBarButton.snp.makeConstraints { make in
            make.height.equalTo(37)
            make.leading.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(noticeButton.snp.leading).offset(-28)
        }
        
        searchBarButton.addSubview(searchIconImageView)
        searchIconImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
        }
        
        searchBarButton.addSubview(searchLabel)
        searchLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(searchIconImageView.snp.trailing)
        }
    }
}
