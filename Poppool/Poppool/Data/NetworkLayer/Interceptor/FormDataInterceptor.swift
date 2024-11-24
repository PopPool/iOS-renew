//
//  FormDataInterceptor.swift
//  MomsVillage
//
//  Created by SeoJunYoung on 10/25/24.
//

import Foundation
import Alamofire
import RxSwift

final class FormDataInterceptor: RequestInterceptor {
    
    private var disposeBag = DisposeBag()
    
    private let keyChainService = KeyChainService()
    
    private let loginAPIUseCase = LoginAPIUseCase()
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, any Error>) -> Void) {
            Logger.log(message: "FormDataInterceptor Adapt Token", category: .network)
            var urlRequest = urlRequest
            keyChainService.fetchToken(type: .accessToken)
                .subscribe { accessToken in
                    urlRequest.setValue(accessToken, forHTTPHeaderField: "authorization")
                    completion(.success(urlRequest))
                } onFailure: { error in
                    completion(.failure(error))
                }
                .disposed(by: disposeBag)
        }
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: any Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        Logger.log(message: "FormDataInterceptor Retry Start", category: .network)
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        let loginAPIUseCase = LoginAPIUseCase()
        keyChainService.fetchToken(type: .refreshToken)
            .subscribe { [weak self] refreshToken in
                guard let self = self else { return }
                loginAPIUseCase.postRefreshToken(refreshToken: refreshToken)
                    .withUnretained(self)
                    .subscribe { (owner, response) in
                        owner.keyChainService.saveToken(type: .accessToken, value: response.data)
                            .subscribe {
                                completion(.retry)
                            } onError: { _ in
                                completion(.doNotRetry)
                            }
                            .disposed(by: owner.disposeBag)
                    }
                    .disposed(by: disposeBag)
            }
            .disposed(by: disposeBag)
    }
}
