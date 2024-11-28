//
//  GetHomeInfoDataResponse.swift
//  Poppool
//
//  Created by Porori on 11/26/24.
//

import Foundation

struct GetHomeInfoDataResponse: Decodable {
    let id: Int64
    let category: String?
    let name: String?
    let address: String?
    let mainImageUrl: String?
    let startDate: String?
    let endDate: String?
}