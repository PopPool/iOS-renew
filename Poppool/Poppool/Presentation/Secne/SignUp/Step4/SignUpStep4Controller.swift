//
//  SignUpStep4Controller.swift
//  Poppool
//
//  Created by SeoJunYoung on 11/25/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

final class SignUpStep4Controller: BaseViewController, View {
    
    typealias Reactor = SignUpStep4Reactor
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    private var mainView = SignUpStep4View()
}

// MARK: - Life Cycle
extension SignUpStep4Controller {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: - SetUp
private extension SignUpStep4Controller {
    func setUp() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(60)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods
extension SignUpStep4Controller {
    func bind(reactor: Reactor) {
    }
}
