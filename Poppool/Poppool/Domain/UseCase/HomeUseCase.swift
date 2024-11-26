//
//  HomeUseCase.swift
//  Poppool
//
//  Created by Porori on 11/26/24.
//

import Foundation
import RxSwift

protocol HomeUseCase {
    var repository: HomeRepository { get set }
    
    func fetchHome(
        userId: String,
        pagination: PaginationRequestDTO
    ) -> Observable<GetHomeInfoResponse>
    
    func fetchCustomPopUp(
        userId: String,
        pagination: PaginationRequestDTO
    ) -> Observable<GetHomeInfoResponse>
    
    func fetchNewPopUp(
        pagination: PaginationRequestDTO
    ) -> Observable<GetHomeInfoResponse>
    
    func fetchPopularPopUp(
        pagination: PaginationRequestDTO
    ) -> Observable<GetHomeInfoResponse>
}
