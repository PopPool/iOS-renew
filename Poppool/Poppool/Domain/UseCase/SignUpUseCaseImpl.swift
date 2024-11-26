//
//  SignUpUseCaseImpl.swift
//  Poppool
//
//  Created by Porori on 11/25/24.
//

import Foundation
import RxSwift

final class SignUpUseCaseImpl: SignUpUseCase {
    var repository: SignUpRepository
    
    init(repository: SignUpRepository) {
        self.repository = repository
    }
    func trySignUp(
        userId: String,
        nickName: String,
        gender: String,
        age: Int32,
        socialEmail: String,
        socialType: String,
        interests: [Int64]
    ) -> Completable {
        return repository.trySignUp(
            userId: userId,
            nickName: nickName,
            gender: gender,
            age: age,
            socialEmail: socialEmail,
            socialType: socialType,
            interests: interests
        )
    }
    func checkNickName(nickName: String) -> Observable<Bool> {
        return repository.checkNickName(nickName: nickName)
    }
    
    func fetchCategoryList() -> Observable<[Category]> {
        return repository.fetchCategoryList()
    }
}
