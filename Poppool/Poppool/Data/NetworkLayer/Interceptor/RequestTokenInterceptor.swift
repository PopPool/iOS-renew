//
//  RequestTokenInterceptor.swift
//  Poppool
//
//  Created by Porori on 11/25/24.
//

import Foundation
import Alamofire
import RxSwift

final class RequestTokenInterceptor: RequestInterceptor {
    
    private var disposeBag = DisposeBag()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest

        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        /// KeyChainService 별도로 생성 이후 적용
//        let keyChainService = KeyChainServiceImpl()
        
        // Request Header에 Token 추가
//        keyChainService.fetchToken(type: .accessToken)
//            .subscribe { accessToken in
//                urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//                completion(.success(urlRequest))
//            } onFailure: { error in
//                completion(.failure(error))
//            }
//            .disposed(by: disposeBag)
    }
}
