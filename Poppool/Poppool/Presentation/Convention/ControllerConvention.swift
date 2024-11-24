//
//  ControllerConvention.swift
//  MomsVillage
//
//  Created by SeoJunYoung on 9/20/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

final class ControllerConvention: BaseViewController, View {
    
    typealias Reactor = LoginViewReactor
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    private var mainView = LoginView()
}

// MARK: - Life Cycle
extension ControllerConvention {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: - SetUp
private extension ControllerConvention {
    func setUp() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods
extension ControllerConvention {
    func bind(reactor: Reactor) {
    }
}
