//
//  SignUpStep1Controller.swift
//  Poppool
//
//  Created by SeoJunYoung on 11/25/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

final class SignUpStep1Controller: BaseViewController, View {
    
    typealias Reactor = SignUpStep1Reactor
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    var mainView = SignUpStep1View()
}

// MARK: - Life Cycle
extension SignUpStep1Controller {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: - SetUp
private extension SignUpStep1Controller {
    func setUp() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(60)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods
extension SignUpStep1Controller {
    func bind(reactor: Reactor) {
    }
}
