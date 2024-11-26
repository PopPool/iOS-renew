//
//  AuthRepository.swift
//  Poppool
//
//  Created by Porori on 11/25/24.
//

import Foundation
import RxSwift

final class AuthRepositoryImpl: AuthRepository {
    
    var provider: Provider
    
    init(provider: Provider) {
        self.provider = provider
    }
    
    func tryLogIn(userCredential: Encodable, socialType: String) -> Observable<LoginResponse> {
        let endPoint = PopPoolAPIEndPoint.auth_tryLogin(with: userCredential, path: socialType)
        return provider
            .requestData(with: endPoint, interceptor: nil)
            .map { responseDTO in
                return responseDTO.toDomain()
            }
    }
}
