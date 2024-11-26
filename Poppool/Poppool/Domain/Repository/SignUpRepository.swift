//
//  SignUpRepository.swift
//  Poppool
//
//  Created by Porori on 11/25/24.
//

import Foundation
import RxSwift

protocol SignUpRepository {
    
    var provider: Provider { get set }
    
    /// 닉네임 중복 여부를 확인하는 메서드
    /// - Parameters:
    ///   - nickName: 확인할 닉네임
    ///   - credential: 인증 정보
    /// - Returns: 닉네임이 중복되었는지 여부를 나타내는 Observable<Bool>
    func checkNickName(nickName: String) -> Observable<Bool>
    
    /// 관심사 리스트를 가져오는 메서드
    /// - Parameter credential: 인증 정보
    /// - Returns: 관심사 리스트를 나타내는 Observable<[Interest]>
    func fetchCategoryList() -> Observable<[Category]>
    
    /// 회원가입을 시도하는 메서드
    /// - Parameters:
    ///   - userId: 유저 아이디
    ///   - nickName: 유저 닉네임
    ///   - gender: 유저 성별
    ///   - age: 유저 나이
    ///   - socialEmail: 유저 소셜로그인 이메일
    ///   - socialType: 유저 소셜로그인 타입
    ///   - interests: 유저 관심사 목록
    /// - Returns: 회원가입 성공여부를 리턴하는 observer
    func trySignUp(
        userId: String,
        nickName: String,
        gender: String,
        age: Int32,
        socialEmail: String,
        socialType: String,
        interests: [Int64]
    ) -> Completable
}
