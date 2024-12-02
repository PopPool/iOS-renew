//
//  TokenInterceptor.swift
//  MomsVillage
//
//  Created by SeoJunYoung on 10/14/24.
//

import Foundation
import Alamofire
import RxSwift

final class TokenInterceptor: RequestInterceptor {
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, any Error>) -> Void) {
            Logger.log(message: "TokenInterceptor Adapt Token", category: .network)
            let keyChainService = KeyChainService()
            var urlRequest = urlRequest
            let accessTokenResult = keyChainService.fetchToken(type: .accessToken)
            switch accessTokenResult {
            case .success(let accessToken):
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                completion(.success(urlRequest))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: any Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        Logger.log(message: "TokenInterceptor Retry Start", category: .network)
        completion(.doNotRetry)
    }
}
