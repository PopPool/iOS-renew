//
//  SignUpMainController.swift
//  Poppool
//
//  Created by SeoJunYoung on 11/25/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift
import ReactorKit
import Pageboy
import Tabman

final class SignUpMainController: BaseTabmanController, View {
    
    typealias Reactor = SignUpMainReactor
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    private var mainView = SignUpMainView()
    
    var step1Controller: SignUpStep1Controller = {
        let controller = SignUpStep1Controller()
        controller.reactor = SignUpStep1Reactor()
        return controller
    }()
    
    var temp2: BaseViewController = {
        let temp = BaseViewController()
        return temp
    }()
    
    lazy var controllers = [step1Controller, temp2]
}

// MARK: - Life Cycle
extension SignUpMainController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: - SetUp
private extension SignUpMainController {
    func setUp() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        self.dataSource = self
    }
}

// MARK: - Methods
extension SignUpMainController {
    func bind(reactor: Reactor) {
        
        // 취소버튼 이벤트
        mainView.headerView.cancelButton.rx.tap
            .withUnretained(self)
            .map { (owner, _) in
                return Reactor.Action.cancelButtonTapped(controller: owner)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 뒤로가기 버튼
        mainView.headerView.backButton.rx.tap
            .withUnretained(self)
            .map { (owner, _) in
                owner.mainView.progressIndicator.decreaseIndicator()
                return Reactor.Action.backButtonTapped(controller: owner, currentIndex: owner.currentIndex ?? 0)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // step1 button tap 이벤트
        step1Controller.mainView.completeButton.rx.tap
            .withUnretained(self)
            .map { (owner, _) in
                owner.mainView.progressIndicator.increaseIndicator()
                return Reactor.Action.step1ButtonTapped(controller: owner, currentIndex: owner.currentIndex ?? 0)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .withUnretained(self)
            .subscribe { (owner, state) in
                
            }
            .disposed(by: disposeBag)
    }
}

extension SignUpMainController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: any Tabman.TMBar, at index: Int) -> any Tabman.TMBarItemable {
        return TMBarItem(title: "")
    }
    
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return controllers.count
    }
    
    func viewController(
        for pageboyViewController: Pageboy.PageboyViewController,
        at index: Pageboy.PageboyViewController.PageIndex
    ) -> UIViewController? {
        return controllers[index]
    }
    
    func defaultPage(
        for pageboyViewController: Pageboy.PageboyViewController
    ) -> Pageboy.PageboyViewController.Page? {
        if let currentIndex = currentIndex { return .at(index: currentIndex) }
        return .at(index: 0)
    }
}
