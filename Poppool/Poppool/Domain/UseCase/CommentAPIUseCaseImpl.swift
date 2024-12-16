//
//  CommentAPIUseCaseImpl.swift
//  Poppool
//
//  Created by SeoJunYoung on 12/15/24.
//

import Foundation

import RxSwift

final class CommentAPIUseCaseImpl {
    
    var repository: CommentAPIRepository
    
    init(repository: CommentAPIRepository) {
        self.repository = repository
    }
    
    func postCommentAdd(popUpStoreId: Int64, content: String?, commentType: String?, imageUrlList: [String?]) -> Completable {
        return repository.postCommentAdd(request: .init(popUpStoreId: popUpStoreId, content: content, commentType: commentType, imageUrlList: imageUrlList))
    }
}
