//
//  HomeListController.swift
//  Poppool
//
//  Created by SeoJunYoung on 12/2/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

final class HomeListController: BaseViewController, View {
    
    typealias Reactor = HomeListReactor
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    private var mainView = HomeListView()
}

// MARK: - Life Cycle
extension HomeListController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: - SetUp
private extension HomeListController {
    func setUp() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods
extension HomeListController {
    func bind(reactor: Reactor) {
    }
}
