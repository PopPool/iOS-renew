//
//  UserAPIEndPoint.swift
//  Poppool
//
//  Created by SeoJunYoung on 12/3/24.
//

import Foundation

import RxSwift

struct UserAPIEndPoint {
    
    static func postBookmarkPopUp(userID: String, request: PostBookmarkPopUpRequestDTO) -> RequestEndpoint {
        return RequestEndpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/users/\(userID)/bookmark-popupstores",
            method: .post,
            queryParameters: request
        )
    }
    
    static func deleteBookmarkPopUp(userID: String, request: PostBookmarkPopUpRequestDTO) -> RequestEndpoint {
        return RequestEndpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/users/\(userID)/bookmark-popupstores",
            method: .delete,
            queryParameters: request
        )
    }
}
