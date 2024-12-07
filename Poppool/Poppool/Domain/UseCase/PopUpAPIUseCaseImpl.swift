//
//  PopUpAPIUseCaseImpl.swift
//  Poppool
//
//  Created by SeoJunYoung on 12/6/24.
//

import Foundation

import RxSwift

final class PopUpAPIUseCaseImpl {
    
    var repository: PopUpAPIRepositoryImpl
    
    init(repository: PopUpAPIRepositoryImpl) {
        self.repository = repository
    }
    
    func getSearchBottomPopUpList(isOpen: Bool, categories: [Int64], page: Int32?, size: Int32, sort: String?) -> Observable<GetSearchBottomPopUpListResponse> {
        var categoryString: String?
        if !categories.isEmpty {
            categoryString = categories.map { String($0) + "," }.reduce("", +)
        }
        let request = GetSearchPopUpListRequestDTO(categories: categoryString, page: page, size: size, sort: sort)
        if isOpen {
            return repository.getOpenPopUpList(request: request).map { $0.toDomain() }
        } else {
            return repository.getClosePopUpList(request: request).map { $0.toDomain() }
        }
    }
    
    func getSearchPopUpList(query: String?) -> Observable<GetSearchPopUpListResponse> {
        return repository.getSearchPopUpList(request: .init(query: query)).map { $0.toDomain() }
    }
}
