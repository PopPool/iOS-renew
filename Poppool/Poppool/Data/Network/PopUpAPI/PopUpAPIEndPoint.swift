//
//  PopUpAPIEndPoint.swift
//  Poppool
//
//  Created by SeoJunYoung on 12/6/24.
//

import Foundation

import RxSwift

struct PopUpAPIEndPoint {
    
    static func getClosePopUpList(request: GetSearchPopUpListRequestDTO) -> Endpoint<GetClosePopUpListResponseDTO> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/popup/closed",
            method: .get,
            queryParameters: request
        )
    }
    
    static func getOpenPopUpList(request: GetSearchPopUpListRequestDTO) -> Endpoint<GetOpenPopUpListResponseDTO> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/popup/open",
            method: .get,
            queryParameters: request
        )
    }
    
    static func getSearchPopUpList(request: GetSearchPopUpListRequestDTO) -> Endpoint<GetSearchPopUpListResponseDTO> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/search/popup-stores",
            method: .get,
            queryParameters: request
        )
    }
    
    static func getPopUpDetail(request: GetPopUpDetailRequestDTO) -> Endpoint<GetPopUpDetailResponseDTO> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/popup/\(request.popUpStoreId)/detail",
            method: .get,
            queryParameters: request
        )
    }
}
