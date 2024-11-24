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
    
    private var disposeBag = DisposeBag()
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        }
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: any Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        Logger.log(message: "TokenInterceptor Retry Start", category: .network)
    }
}
