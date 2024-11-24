//
//  LoginController.swift
//  Poppool
//
//  Created by SeoJunYoung on 11/24/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

final class LoginController: BaseViewController, View {
    
    typealias Reactor = LoginReactor
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    private var mainView = LoginView()
}

// MARK: - Life Cycle
extension LoginController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: - SetUp
private extension LoginController {
    func setUp() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods
extension LoginController {
    func bind(reactor: Reactor) {
    }
}
