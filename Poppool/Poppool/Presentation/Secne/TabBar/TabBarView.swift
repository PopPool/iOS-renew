//
//  TabBarView.swift
//  Poppool
//
//  Created by Porori on 11/28/24.
//

import UIKit
import SnapKit

final class TabBarView: UIView {
    
    // MARK: - Components
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    let dotPointer: UIView = {
        let view = UIView()
        view.backgroundColor = .purple
        return view
    }()
    
    let firstIcon: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "map"), for: .normal)
        return button
    }()
    
    let firstIconLabel: UILabel = {
        let label = UILabel()
        label.text = "지도"
        label.font = .KorFont(style: .regular, size: 11)
        return label
    }()
    
    let secondIcon: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "lasso"), for: .normal)
        return button
    }()
    
    let secondIconLabel: UILabel = {
        let label = UILabel()
        label.text = "홈"
        label.font = .KorFont(style: .regular, size: 11)
        return label
    }()
    
    let thirdIcon: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "person"), for: .normal)
        return button
    }()
    
    let thirdIconLabel: UILabel = {
        let label = UILabel()
        label.text = "홈"
        label.font = .KorFont(style: .regular, size: 11)
        return label
    }()
    
    lazy var mapButton: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(firstIcon)
        stack.addArrangedSubview(firstIconLabel)
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    lazy var homeButton: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(secondIcon)
        stack.addArrangedSubview(secondIconLabel)
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    lazy var myPageButton: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(thirdIcon)
        stack.addArrangedSubview(thirdIconLabel)
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(mapButton)
        stack.addArrangedSubview(homeButton)
        stack.addArrangedSubview(myPageButton)
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private var dotPosition: CGFloat = 0.0
    
    // MARK: - init
    init() {
        super.init(frame: .zero)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dotPointer.layer.cornerRadius = dotPointer.frame.width/2
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let wavePath = UIBezierPath()
        wavePath.move(to: CGPoint(x: 0, y: bounds.height))
        wavePath.addCurve(to: CGPoint(x: bounds.width, y: bounds.height),
                          controlPoint1: CGPoint(x: dotPosition - 40, y: bounds.height - 20),
                          controlPoint2: CGPoint(x: dotPosition + 40, y: bounds.height - 20))
        wavePath.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        wavePath.close()
        
        context.setFillColor(UIColor.purple.cgColor)
        context.addPath(wavePath.cgPath)
        context.fillPath()
    }
}

// MARK: - SetUp
private extension TabBarView {
    
    func setUpConstraints() {
        self.backgroundColor = .yellow
        
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(88)
        }
        
        containerView.addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.bottom.equalToSuperview().inset(21)
            make.height.equalTo(49)
        }
        
        [firstIcon, secondIcon, thirdIcon].forEach {
            $0.snp.makeConstraints { make in
                make.size.equalTo(32)
            }
        }
        
        [firstIconLabel, secondIconLabel, thirdIconLabel].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(17)
            }
        }
        
        addSubview(dotPointer)
        dotPointer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(12)
        }
    }
}

// MARK: - Methods
extension TabBarView {
    func moveDotPointer(to index: Int, animated: Bool) {
        let target: UIButton
        switch index {
            case 0: target = firstIcon
            case 1: target = secondIcon
            case 2: target = thirdIcon
            default: return
        }
        
        layoutIfNeeded()
        let targetCenterX = target.superview?.convert(target.center, to: self).x ?? 0
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.dotPointer.center.x = targetCenterX
            }
        } else {
            dotPointer.center.x = targetCenterX
        }
    }
}
