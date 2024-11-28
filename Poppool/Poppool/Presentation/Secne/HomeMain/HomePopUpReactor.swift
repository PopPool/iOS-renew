//
//  HomePopUpReactor.swift
//  Poppool
//
//  Created by Porori on 11/27/24.
//

import ReactorKit
import RxSwift
import RxCocoa

final class HomePopUpReactor: Reactor {
    
    // MARK: - Reactor
    enum Action {
        case backButtonTapped
        case bookmarkButtonTapped(Int)
    }
    
    enum Mutation {
        case returnToScreen
        case updateBookmarkButton(Int)
    }
    
    struct State {
        var dismissed: Bool = false
        var items: [CellItem] = []
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
        case .backButtonTapped:
            return Observable.just(.returnToScreen)
        case .bookmarkButtonTapped(let index):
            return Observable.just(.updateBookmarkButton(index))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .returnToScreen:
            newState.dismissed = true
        case .updateBookmarkButton(let index):
            newState.items[index].isBookmarked.toggle()
        }
        return newState
    }
}
