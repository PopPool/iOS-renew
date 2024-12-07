//
//  MapPopUpStoreDTO.swift
//  Poppool
//
//  Created by 김기현 on 12/3/24.
//

import Foundation

struct MapPopUpStoreDTO: Codable {
    let id: Int64
    let category: String
    let name: String
    let address: String
    let startDate: String
    let endDate: String
    let latitude: Double
    let longitude: Double
    let markerId: Int64
    let markerTitle: String
    let markerSnippet: String

    func toDomain() -> MapPopUpStore {
        return MapPopUpStore(
            id: id,
            category: category,
            name: name,
            address: address,
            startDate: startDate,
            endDate: endDate,
            latitude: latitude,
            longitude: longitude,
            markerId: markerId,
            markerTitle: markerTitle,
            markerSnippet: markerSnippet
        )
    }
}

struct GetViewBoundPopUpStoreListResponse: Decodable {
    var popUpStoreList: [MapPopUpStoreDTO]
}

struct MapSearchPopUpStore: Decodable {
    let popUpStoreList: [MapPopUpStoreDTO]
}
