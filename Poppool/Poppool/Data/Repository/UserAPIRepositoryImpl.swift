//
//  UserAPIRepositoryImpl.swift
//  Poppool
//
//  Created by SeoJunYoung on 12/3/24.
//

import Foundation

import RxSwift

final class UserAPIRepositoryImpl {
    
    private let provider: Provider
    private let tokenInterceptor = TokenInterceptor()
    
    init(provider: Provider) {
        self.provider = provider
    }
 
    func postBookmarkPopUp(userID: String, request: PostBookmarkPopUpRequestDTO) -> Completable {
        let endPoint = UserAPIEndPoint.postBookmarkPopUp(userID: userID, request: request)
        return provider.request(with: endPoint, interceptor: tokenInterceptor)
    }
    
    func deleteBookmarkPopUp(userID: String, request: PostBookmarkPopUpRequestDTO) -> Completable {
        let endPoint = UserAPIEndPoint.deleteBookmarkPopUp(userID: userID, request: request)
        return provider.request(with: endPoint, interceptor: tokenInterceptor)
    }
}
