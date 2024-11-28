//
//  HomeReactor.swift
//  Poppool
//
//  Created by SeoJunYoung on 11/28/24.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa

final class HomeReactor: Reactor {
    
    // MARK: - Reactor
    enum Action {
        case viewWillAppear
    }
    
    enum Mutation {
        case loadView
    }
    
    struct State {
        var sections: [any Sectionable] = []
    }
    
    // MARK: - properties
    
    var initialState: State
    
    var disposeBag = DisposeBag()
    
    private let homeApiUseCase = HomeUseCaseImpl()
    
    private let userDefaultService = UserDefaultService()
    
    lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        UICollectionViewCompositionalLayout { [weak self] section, env in
            guard let self = self else {
                return NSCollectionLayoutSection(group: NSCollectionLayoutGroup(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    ))
                )
            }
            return getSection()[section].getSection(section: section, env: env)
        }
    }()
    
    // MARK: - init
    init() {
        self.initialState = State()
    }
    
    // MARK: - Reactor Methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            guard let userIDResult = userDefaultService.fetch(key: "userID") else { return Observable.just(.loadView) }
            return homeApiUseCase.fetchHome(userId: userIDResult, page: 0, size: 10, sort: ["viewCount", "desc"])
                .withUnretained(self)
                .map { (owner, response) in
                    print(response)
                    return .loadView
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .loadView:
            newState.sections = getSection()
        }
        return newState
    }
    
    func getSection() -> [any Sectionable] {
        return []
    }
}
