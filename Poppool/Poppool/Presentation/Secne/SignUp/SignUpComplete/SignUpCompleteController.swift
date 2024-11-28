//
//  SignUpCompleteController.swift
//  Poppool
//
//  Created by SeoJunYoung on 11/27/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

final class SignUpCompleteController: BaseViewController, View {
    
    typealias Reactor = SignUpCompleteReactor
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    private var mainView = SignUpCompleteView()
}

// MARK: - Life Cycle
extension SignUpCompleteController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: - SetUp
private extension SignUpCompleteController {
    func setUp() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods
extension SignUpCompleteController {
    func bind(reactor: Reactor) {
        
        mainView.bottomButton.rx.tap
            .withUnretained(self)
            .map { (owner, _) in
                Reactor.Action.completeButtonTapped(controller: owner)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .withUnretained(self)
            .subscribe { (owner, state) in
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineHeightMultiple = 1.3
                owner.mainView.nickNameLabel.attributedText = NSMutableAttributedString(
                    string: state.nickName,
                    attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
                )
                
                if state.categoryTitles.isEmpty {
                    owner.mainView.descriptionStackView.isHidden = true
                } else {
                    let transformedString = state.categoryTitles.enumerated()
                        .map { "#\($0.element)" }
                        .joined(separator: ", ")
                    owner.mainView.categoryLabel.text = transformedString
                }
            }
            .disposed(by: disposeBag)
    }
}
