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
        case moveToHomeScene(controller: BaseViewController)
        case loadView
    }
    
    struct State {
    }
    
    // MARK: - properties
    
    var initialState: State
    var disposeBag = DisposeBag()
    
    private let kakaoLoginService = KakaoLoginService()
    private let appleLoginService = AppleLoginService()
    private let authApiUseCase = TryLoginUseCaseImpl(repository: AuthRepositoryImpl(provider: ProviderImpl()))
    
    // MARK: - init
    init() {
        self.initialState = State()
    }
    
    // MARK: - Reactor Methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .kakaoButtonTapped(let controller):
            return loginWithKakao(controller: controller)
        case .appleButtonTapped(let controller):
            return loginWithApple(controller: controller)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .moveToSignUpScene(let controller):
            let signUpController = SignUpMainController()
            signUpController.reactor = SignUpMainReactor()
            controller.navigationController?.pushViewController(signUpController, animated: true)
        case .moveToHomeScene(let controller):
            let homeTabbar = BaseViewController()
            controller.view.window?.rootViewController = homeTabbar
        case .loadView:
            print(#function)
        }
        return state
    }
    
    func loginWithKakao(controller: BaseViewController) -> Observable<Mutation> {
        return kakaoLoginService.fetchUserCredential()
            .withUnretained(self)
            .flatMap { owner, response in
                owner.authApiUseCase.execute(userCredential: response, socialType: "kakao")
            }
            .map { loginResponse in
                if loginResponse.isRegisteredUser {
                    return .moveToHomeScene(controller: controller)
                } else {
                    return .moveToSignUpScene(controller: controller)
                }
            }
    }
    
    func loginWithApple(controller: BaseViewController) -> Observable<Mutation> {
        return appleLoginService.fetchUserCredential()
            .withUnretained(self)
            .flatMap { owner, response in
                owner.authApiUseCase.execute(userCredential: response, socialType: "apple")
            }
            .map { loginResponse in
                if loginResponse.isRegisteredUser {
                    return .moveToHomeScene(controller: controller)
                } else {
                    return .moveToSignUpScene(controller: controller)
                }
            }
    }
}
