//
//  HomeListReactor.swift
//  Poppool
//
//  Created by SeoJunYoung on 12/2/24.
//

import ReactorKit
import RxSwift
import RxCocoa

final class HomeListReactor: Reactor {
    
    // MARK: - Reactor
    enum Action {
    }
    
    enum Mutation {
    }
    
    struct State {
        var popUpType: HomePopUpType
    }
    
    // MARK: - properties
    
    var initialState: State
    var disposeBag = DisposeBag()
    var popUpType: HomePopUpType
    
    // MARK: - init
    init(popUpType: HomePopUpType) {
        self.initialState = State(popUpType: popUpType)
        self.popUpType = popUpType
    }
    
    // MARK: - Reactor Methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        }
        return newState
    }
}
