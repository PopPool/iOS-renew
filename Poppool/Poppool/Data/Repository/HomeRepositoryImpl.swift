//
//  HomeRepositoryImpl.swift
//  Poppool
//
//  Created by Porori on 11/26/24.
//

import Foundation
import RxSwift

final class HomeRepositoryImpl: HomeRepository {
    
    private let provider: Provider
    private let tokenInterceptor = TokenInterceptor()
    
    init(provider: Provider) {
        self.provider = provider
    }
    
    func fetchHome(userId: String, pagination: PaginationRequestDTO) -> Observable<GetHomeInfoResponse> {
        let endPoint = HomeAPIEndpoint.fetchHome(userId: userId, request: pagination)
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor).map({ $0.toDomain() })
    }
    
    func fetchCustomPopUp(userId: String, pagination: PaginationRequestDTO) -> Observable<GetHomeInfoResponse> {
        let endPoint = HomeAPIEndpoint.fetchCustomPopUp(userId: userId, request: pagination)
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor).map({ $0.toDomain() })
    }
    
    func fetchNewPopUp(pagination: PaginationRequestDTO) -> Observable<GetHomeInfoResponse> {
        let endPoint = HomeAPIEndpoint.fetchNewPopUp(request: pagination)
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor).map({ $0.toDomain() })
    }
    
    func fetchPopularPopUp(pagination: PaginationRequestDTO) -> Observable<GetHomeInfoResponse> {
        let endPoint = HomeAPIEndpoint.fetchPopularPopUp(request: pagination)
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor).map({ $0.toDomain() })
    }
}
