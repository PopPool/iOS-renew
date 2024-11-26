//
//  HomePopUpDTO.swift
//  Poppool
//
//  Created by Porori on 11/26/24.
//

import Foundation

struct HomePopUpDTO: Decodable {
    let id: Int64
    let category: String
    let name: String
    let address: String
    let mainImageUrl: String
    let startDate: String
    let endDate: String
}

extension HomePopUpDTO {
    func toDomain() -> HomePopUp {
        return HomePopUp(
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
