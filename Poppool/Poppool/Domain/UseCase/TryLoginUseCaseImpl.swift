//
//  TryLoginUseCaseImpl.swift
//  Poppool
//
//  Created by Porori on 11/25/24.
//

import Foundation
import RxSwift

final class TryLoginUseCaseImpl: TryLoginUseCase {
    
    var repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute(userCredential: Encodable, socialType: String) -> Observable<LoginResponse> {
        return repository.tryLogIn(userCredential: userCredential, socialType: socialType)
    }
}
