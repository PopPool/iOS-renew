//
//  HomeAPIRequestDTO.swift
//  Poppool
//
//  Created by SeoJunYoung on 11/28/24.
//

import Foundation

struct HomeAPIRequestDTO: Encodable {
    var userId: String?
    var page: Int32?
    var size: Int32?
    var sort: [String]?
}
