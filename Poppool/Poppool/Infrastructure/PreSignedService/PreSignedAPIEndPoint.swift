//
//  PreSignedAPIEndPoint.swift
//  Poppool
//
//  Created by SeoJunYoung on 11/29/24.
//

import Foundation

struct PreSignedAPIEndPoint {
    
    static func presigned_upload(request: PresignedURLRequestDTO) -> Endpoint<PreSignedURLResponseDTO>{
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/files/upload-preSignedUrl",
            method: .post,
            bodyParameters: request
        )
    }
    
    static func presigned_download(request: PresignedURLRequestDTO) -> Endpoint<PreSignedURLResponseDTO>{
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/files/download-preSignedUrl",
            method: .post,
            bodyParameters: request
        )
    }
    
    static func presigned_delete(request: PresignedURLRequestDTO) -> RequestEndpoint{
        return RequestEndpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/files/delete",
            method: .post,
            bodyParameters: request
        )
    }
}
