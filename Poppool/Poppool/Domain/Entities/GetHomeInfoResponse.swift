//
//  GetHomeInfoResponse.swift
//  Poppool
//
//  Created by Porori on 11/26/24.
//

import Foundation

struct GetHomeInfoResponse: Decodable {
    var bannerPopUpStoreList: [BannerPopUpStore]
    var nickname: String?
    var customPopUpStoreList: [GetHomeInfoDataResponse]
    var customPopUpStoreTotalPages: Int32
    var customPopUpStoreTotalElements: Int64
    var popularPopUpStoreList: [GetHomeInfoDataResponse]
    var popularPopUpStoreTotalPages: Int32
    var popularPopUpStoreTotalElements: Int64
    var newPopUpStoreList: [GetHomeInfoDataResponse]
    var newPopUpStoreTotalPages: Int32
    var newPopUpStoreTotalElements: Int64
    var loginYn: Bool
}
