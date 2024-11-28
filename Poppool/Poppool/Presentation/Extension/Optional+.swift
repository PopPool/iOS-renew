//
//  Optional+.swift
//  Poppool
//
//  Created by SeoJunYoung on 11/28/24.
//

import Foundation

extension Optional where Wrapped: Collection {
    var orEmpty: Wrapped {
        return self ?? [] as! Wrapped
    }
}
