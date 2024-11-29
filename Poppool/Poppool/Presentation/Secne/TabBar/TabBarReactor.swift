//
//  TabBarReactor.swift
//  Poppool
//
//  Created by Porori on 11/28/24.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

final class TabBarReactor: Reactor {
    
    // MARK: - Reactor
    enum Action {
        case selectTab(_ tab: Int)
    }
    
    enum Mutation {
        case selectedTab(Int)
    }
    
    struct State {
        var selectedTabIndex: Int = 0
    }
    
    // MARK: - properties
    
    var initialState: State
    var disposeBag = DisposeBag()
    
    // MARK: - init
    init() {
        self.initialState = State()
    }
    
    // MARK: - Reactor Methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectTab(let index):
            return Observable.just(.selectedTab(index))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .selectedTab(let index):
            newState.selectedTabIndex = index
        }
        return newState
    }
}
