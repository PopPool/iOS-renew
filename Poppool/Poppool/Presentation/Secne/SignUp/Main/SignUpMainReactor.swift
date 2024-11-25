//
//  SignUpMainReactor.swift
//  Poppool
//
//  Created by SeoJunYoung on 11/25/24.
//

import ReactorKit
import RxSwift
import RxCocoa

final class SignUpMainReactor: Reactor {
    
    // MARK: - Reactor
    enum Action {
        case cancelButtonTapped(controller: BaseTabmanController)
        case backButtonTapped(controller: BaseTabmanController, currentIndex: Int)
        case step1ButtonTapped(controller: BaseTabmanController, currentIndex: Int)
        case step2ButtonTapped(controller: BaseTabmanController, currentIndex: Int)
    }
    
    enum Mutation {
        case moveToLoginScene(controller: BaseTabmanController)
        case increasePageIndex(controller: BaseTabmanController, currentIndex: Int)
        case decreasePageIndex(controller: BaseTabmanController, currentIndex: Int)
    }
    
    struct State {
        var currentIndex: Int = 0
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
        case .cancelButtonTapped(let controller):
            return Observable.just(.moveToLoginScene(controller: controller))
        case .backButtonTapped(let controller, let currentIndex):
            return Observable.just(.decreasePageIndex(controller: controller, currentIndex: currentIndex))
        case .step1ButtonTapped(let controller, let currentIndex):
            return Observable.just(.increasePageIndex(controller: controller, currentIndex: currentIndex))
        case .step2ButtonTapped(let controller, let currentIndex):
            return Observable.just(.increasePageIndex(controller: controller, currentIndex: currentIndex))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .moveToLoginScene(let controller):
            controller.navigationController?.popViewController(animated: true)
        case .increasePageIndex(let controller, let currentIndex):
            newState.currentIndex = currentIndex + 1
            controller.scrollToPage(.at(index: currentIndex + 1), animated: false)
        case .decreasePageIndex(let controller, let currentIndex):
            newState.currentIndex = currentIndex - 1
            controller.scrollToPage(.at(index: currentIndex - 1), animated: false)
        }
        return newState
    }
}
