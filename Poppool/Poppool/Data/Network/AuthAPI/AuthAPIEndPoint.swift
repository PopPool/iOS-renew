//
//  PopPoolAPIEndPoint.swift
//  Poppool
//
//  Created by Porori on 11/25/24.
//

import Foundation

struct PopPoolAPIEndPoint {
    
    // MARK: - Auth API
    
    /// 로그인을 시도합니다.
    /// - Parameters:
    ///   - userCredential: 사용자 자격 증명
    ///   - path: 경로
    /// - Returns: Endpoint<LoginResponseDTO>
    static func auth_tryLogin(with userCredential: Encodable, path: String) -> Endpoint<LoginResponseDTO> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/auth/\(path)",
            method: .post,
            bodyParameters: userCredential
        )
    }
}
