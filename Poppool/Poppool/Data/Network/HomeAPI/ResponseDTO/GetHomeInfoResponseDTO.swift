//
//  GetHomeInfoResponseDTO.swift
//  Poppool
//
//  Created by Porori on 11/26/24.
//

import Foundation

struct GetHomeInfoResponseDTO: Decodable {
    var bannerPopUpStoreList: [BannerPopUpStoreDTO]?
    var nickname: String?
    var customPopUpStoreList: [GetHomeInfoDataResponseDTO]?
    var customPopUpStoreTotalPages: Int32
    var customPopUpStoreTotalElements: Int64
    var popularPopUpStoreList: [GetHomeInfoDataResponseDTO]?
    var popularPopUpStoreTotalPages: Int32
    var popularPopUpStoreTotalElements: Int64
    var newPopUpStoreList: [GetHomeInfoDataResponseDTO]?
    var newPopUpStoreTotalPages: Int32
    var newPopUpStoreTotalElements: Int64
    var loginYn: Bool
}

extension GetHomeInfoResponseDTO {
    func toDomain() -> GetHomeInfoResponse {
        return .init(
            bannerPopUpStoreList: bannerPopUpStoreList.orEmpty.map { $0.toDomain() },
            nickname: nickname,
            customPopUpStoreList: customPopUpStoreList.orEmpty.map { $0.toDomain() },
            customPopUpStoreTotalPages: customPopUpStoreTotalPages,
            customPopUpStoreTotalElements: customPopUpStoreTotalElements,
            popularPopUpStoreList: popularPopUpStoreList.orEmpty.map { $0.toDomain() },
            popularPopUpStoreTotalPages: popularPopUpStoreTotalPages,
            popularPopUpStoreTotalElements: popularPopUpStoreTotalElements,
            newPopUpStoreList: newPopUpStoreList.orEmpty.map { $0.toDomain() },
            newPopUpStoreTotalPages: newPopUpStoreTotalPages,
            newPopUpStoreTotalElements: newPopUpStoreTotalElements,
            loginYn: loginYn
        )
    }
}

