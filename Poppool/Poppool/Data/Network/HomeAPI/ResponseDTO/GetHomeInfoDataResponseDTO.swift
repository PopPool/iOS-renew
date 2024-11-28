//
//  GetHomeInfoDataResponseDTO.swift
//  Poppool
//
//  Created by Porori on 11/26/24.
//

import Foundation

struct GetHomeInfoDataResponseDTO: Decodable {
    let id: Int64
    let category: String?
    let name: String?
    let address: String
    let mainImageUrl: String?
    let startDate: String?
    let endDate: String?
}

extension GetHomeInfoDataResponseDTO {
    func toDomain() -> GetHomeInfoDataResponse {
        return GetHomeInfoDataResponse(
            id: id,
            category: category,
            name: name,
            address: address,
            mainImageUrl: mainImageUrl,
            startDate: startDate,
            endDate: endDate
        )
    }
}
