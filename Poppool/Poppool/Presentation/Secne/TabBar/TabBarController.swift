//
//  TabBarController.swift
//  Poppool
//
//  Created by Porori on 11/28/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

final class TabBarController: UITabBarController, View {
    
    typealias Reactor = TabBarReactor
    
    // MARK: - Properties
    private var mainView = TabBarView()
    var disposeBag = DisposeBag()
    
    private let childControllers: [UIViewController] = [
        ControllerConvention(),
        ControllerConvention(),
        TestVC()
    ]
}

// MARK: - Life Cycle
extension TabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: - SetUp
private extension TabBarController {
    func setUp() {
        view.backgroundColor = .white
        viewControllers = childControllers
        
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(94)
        }
    }
}

// MARK: - Methods
extension TabBarController {
    func bind(reactor: Reactor) {
        mainView.firstIcon.rx.tap
            .map { Reactor.Action.selectTab(0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.secondIcon.rx.tap
            .map { Reactor.Action.selectTab(1) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.thirdIcon.rx.tap
            .map { Reactor.Action.selectTab(2) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedTabIndex }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] index in
                self?.mainView.moveDotPointer(to: index, animated: true)
                self?.selectedIndex = index
            })
            .disposed(by: disposeBag)
    }
}
