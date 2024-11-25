//
//  Constant.swift
//  PopPool
//
//  Created by Porori on 6/20/24.
//

import Foundation

// MARK: - Space Guide

/// 추후 SpaceGuide 변경점 추가
class Constants {
    static let spaceGuide = SpaceGuide()
    static let socialType = SocialTYPE()
    static let lottie = Lottie()
    static var userId: String = ""
}

/// Padding 값
struct SpaceGuide {
    let micro100 = 4
    let micro200 = 8
    let micro300 = 12
    let small100 = 16
    let small200 = 20
    let small300 = 24
    let small400 = 28
    let medium100 = 32
    let medium200 = 36
    let medium300 = 40
    let medium400 = 48
    let large100 = 64
    let large200 = 80
    let large300 = 120
    let large400 = 156
}

struct SocialTYPE {
    let apple = "apple"
    let kakao = "kakao"
}

struct Lottie {
    let loading = "PP_loading"
    let splashAnimation = "PP_splash"
}
