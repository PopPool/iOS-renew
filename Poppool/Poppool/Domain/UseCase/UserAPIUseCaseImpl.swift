//
//  UserAPIUseCaseImpl.swift
//  Poppool
//
//  Created by SeoJunYoung on 12/3/24.
//

import RxSwift

final class UserAPIUseCaseImpl {
    
    var repository: UserAPIRepositoryImpl
    
    init(repository: UserAPIRepositoryImpl) {
        self.repository = repository
    }
    
    func postBookmarkPopUp(userID: String, popUpID: Int64) -> Completable {
        return repository.postBookmarkPopUp(userID: userID, request: .init(popUpStoreId: popUpID))
    }
    
    func deleteBookmarkPopUp(userID: String, popUpID: Int64) -> Completable {
        return repository.deleteBookmarkPopUp(userID: userID, request: .init(popUpStoreId: popUpID))
    }
}
