//
//  TestVC.swift
//  Poppool
//
//  Created by Porori on 11/29/24.
//

import Foundation
import RxSwift
import ReactorKit

final class TestVC: BaseViewController, View {
    
    typealias Reactor = ReactorConvention
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    private var mainView = ViewConvention()
}

// MARK: - Life Cycle
extension TestVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: - SetUp
private extension TestVC {
    func setUp() {
        view.backgroundColor = .red
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods
extension TestVC {
    func bind(reactor: Reactor) {
    }
}
