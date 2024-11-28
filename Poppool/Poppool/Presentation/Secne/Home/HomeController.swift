//
//  HomeController.swift
//  Poppool
//
//  Created by SeoJunYoung on 11/28/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

final class HomeController: BaseViewController, View {
    
    typealias Reactor = HomeReactor
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    private var mainView = HomeView()
}

// MARK: - Life Cycle
extension HomeController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: - SetUp
private extension HomeController {
    func setUp() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods
extension HomeController {
    func bind(reactor: Reactor) {
        rx.viewWillAppear
            .map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
