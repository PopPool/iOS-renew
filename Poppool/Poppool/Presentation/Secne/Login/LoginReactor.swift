//
//  LoginReactor.swift
//  Poppool
//
//  Created by SeoJunYoung on 11/24/24.
//

import ReactorKit
import RxSwift
import RxCocoa

final class LoginReactor: Reactor {
    
    // MARK: - Reactor
    enum Action {
        case kakaoButtonTapped(controller: BaseViewController)
        case appleButtonTapped(controller: BaseViewController)
    }
    
    enum Mutation {
        case moveToSignUpScene(controller: BaseViewController)
        case loadView
    }
    
    struct State {
    }
    
    // MARK: - properties
    
    var initialState: State
    var disposeBag = DisposeBag()
    
    private let kakaoLoginService = KakaoLoginService()
    private let appleLoginService = AppleLoginService()
    
    // MARK: - init
    init() {
        self.initialState = State()
    }
    
    // MARK: - Reactor Methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .kakaoButtonTapped(let controller):
            return loginWithKakao()
        case .appleButtonTapped(let controller):
            return loginWithApple()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .moveToSignUpScene(let controller):
            let signUpController = SignUpMainController()
            signUpController.reactor = SignUpMainReactor()
            controller.navigationController?.pushViewController(signUpController, animated: true)
        case .loadView:
            print(#function)
        }
        return newState
    }
    
    func loginWithKakao() -> Observable<Mutation> {
        kakaoLoginService.fetchUserCredential()
            .map { authResponse in
                print(authResponse)
                return .loadView
            }
    }
    
    func loginWithApple() -> Observable<Mutation> {
        appleLoginService.fetchUserCredential()
            .map { authResponse in
                print(authResponse)
                return .loadView
            }
    }
}
