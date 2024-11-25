//
//  TryLoginUseCase.swift
//  Poppool
//
//  Created by Porori on 11/25/24.
//

import Foundation
import RxSwift

/// 인증 관련 UseCase 프로토콜
protocol TryLoginUseCase {
    
    /// 인증 관련 저장소
    var repository: AuthRepository { get set }
    
    /// 로그인 시도 메서드
    /// - Parameters:
    ///   - userCredential: 사용자 자격 증명 정보 (Encodable)
    ///   - socialType: 소셜 로그인 타입 (예: "google", "facebook")
    /// - Returns: 로그인 응답을 나타내는 Observable 객체
    func execute(userCredential: Encodable, socialType: String) -> Observable<LoginResponse>
}
