//
//  SignUpCompleteReactor.swift
//  Poppool
//
//  Created by SeoJunYoung on 11/27/24.
//

import ReactorKit
import RxSwift
import RxCocoa

final class SignUpCompleteReactor: Reactor {
    
    // MARK: - Reactor
    enum Action {
    }
    
    enum Mutation {
    }
    
    struct State {
        var nickName: String
        var categoryTitles: [String]
    }
    
    // MARK: - properties
    
    var initialState: State
    var disposeBag = DisposeBag()
    
    // MARK: - init
    init(nickName: String, categoryTitles: [String]) {
        self.initialState = State(nickName: nickName, categoryTitles: categoryTitles)
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
