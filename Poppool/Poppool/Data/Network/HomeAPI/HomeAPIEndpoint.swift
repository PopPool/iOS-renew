//
//  HomeRepositoryImpl.swift
//  Poppool
//
//  Created by Porori on 11/26/24.
//

import Foundation

struct HomeAPIEndpoint {
    
    static func fetchHome(
        userId: String,
        request: PaginationRequestDTO
    ) -> Endpoint<GetHomeInfoResponseDTO> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/home",
            method: .get,
            queryParameters: request
        )
    }
    
    static func fetchPopularPopUp(
        request: PaginationRequestDTO
    ) -> Endpoint<GetHomeInfoResponseDTO> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/home/popular/popup-stores",
            method: .get,
            queryParameters: request
        )
    }
    
    static func fetchNewPopUp(
        request: PaginationRequestDTO
    ) -> Endpoint<GetHomeInfoResponseDTO> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/home/new/popup-stores",
            method: .get,
            queryParameters: request
        )
    }
    
    static func fetchCustomPopUp(
        userId: String,
        request: PaginationRequestDTO
    ) -> Endpoint<GetHomeInfoResponseDTO> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/home/custom/popup-stores",
            method: .get,
            queryParameters: request
        )
    }
}
