//
//  GetMyRecentViewPopUpStoreListRequestDTO.swift
//  Poppool
//
//  Created by Porori on 11/26/24.
//

import Foundation

struct PaginationRequestDTO: Encodable {
    var page: Int
    var size: Int
    var sort: [String]
}
