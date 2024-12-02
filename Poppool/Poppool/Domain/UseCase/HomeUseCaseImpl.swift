//
//  HomeUseCaseImpl.swift
//  Poppool
//
//  Created by Porori on 11/26/24.
//

import Foundation
import RxSwift

final class HomeUseCaseImpl {
    var repository = HomeAPIRepository(provider: ProviderImpl())
    
    func fetchHome(
        userId: String,
        page: Int32?,
        size: Int32?,
        sort: String?
    ) -> Observable<GetHomeInfoResponse> {
        return repository.fetchHome(request: .init(userId: userId, page: page, size: size, sort: sort))
    }
    
    func fetchCustomPopUp(
        userId: String,
        page: Int32?,
        size: Int32?,
        sort: String?
    ) -> Observable<GetHomeInfoResponse> {
        return repository.fetchCustomPopUp(request: .init(userId: userId, page: page, size: size, sort: sort))
    }
    
    func fetchNewPopUp(
        userId: String,
        page: Int32?,
        size: Int32?,
        sort: String?
    ) -> Observable<GetHomeInfoResponse> {
        return repository.fetchNewPopUp(request: .init(userId: userId, page: page, size: size, sort: sort))
    }
    
    func fetchPopularPopUp(
        userId: String,
        page: Int32?,
        size: Int32?,
        sort: String?
    ) -> Observable<GetHomeInfoResponse> {
        return repository.fetchPopularPopUp(request: .init(userId: userId, page: page, size: size, sort: sort))
    }
}
