//
//  HomeUseCaseImpl.swift
//  Poppool
//
//  Created by Porori on 11/26/24.
//

import Foundation
import RxSwift

final class HomeUseCaseImpl: HomeUseCase {
    var repository: HomeRepository
    
    init(repository: HomeRepository) {
        self.repository = repository
    }
    
    func fetchHome(
        userId: String,
        pagination: PaginationRequestDTO
    ) -> Observable<GetHomeInfoResponse> {
        return repository.fetchHome(userId: userId, pagination: pagination)
    }
    
    func fetchCustomPopUp(
        userId: String,
        pagination: PaginationRequestDTO
    ) -> Observable<GetHomeInfoResponse> {
        return repository.fetchCustomPopUp(userId: userId, pagination: pagination)
    }
    
    func fetchNewPopUp(
        pagination: PaginationRequestDTO
    ) -> Observable<GetHomeInfoResponse> {
        return repository.fetchNewPopUp(pagination: pagination)
    }
    
    func fetchPopularPopUp(
        pagination: PaginationRequestDTO
    ) -> Observable<GetHomeInfoResponse> {
        return repository.fetchPopularPopUp(pagination: pagination)
    }
}
