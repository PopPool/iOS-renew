//
//  HomePopUpReactor.swift
//  Poppool
//
//  Created by Porori on 11/27/24.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

final class HomePopUpReactor: Reactor {
    
    // MARK: - Reactor
    enum Action {
        case viewWillAppear
        case backButtonTapped
        case bookmarkButtonTapped(indexPath: IndexPath)
    }
    
    enum Mutation {
        case returnToScreen
        case loadView([CellItem])
        case toggleBookmark(indexPath: IndexPath)
    }
    
    struct State {
        var dismissed: Bool = false
        var toggledBookmark: [CellItem] = []
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
        case .viewWillAppear:
            let items = (0..<10).map { CellItem(id: $0, isBookmarked: false) }
            return Observable.just(.loadView(items))
        case .backButtonTapped:
            return Observable.just(.returnToScreen)
        case .bookmarkButtonTapped(indexPath: let indexPath):
            return Observable.just(.toggleBookmark(indexPath: indexPath))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .returnToScreen:
            newState.dismissed = true
            
        case .loadView(let items):
            newState.toggledBookmark = items
            
        case .toggleBookmark(let indexPath):
            newState.toggledBookmark[indexPath.item].isBookmarked.toggle()
        }
        return newState
    }
}
