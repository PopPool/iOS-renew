//
//  CommentAPIRepository.swift
//  Poppool
//
//  Created by SeoJunYoung on 12/15/24.
//

import Foundation

import RxSwift

final class CommentAPIRepository {
    
    private let provider: Provider
    private let tokenInterceptor = TokenInterceptor()
    
    init(provider: Provider) {
        self.provider = provider
    }
 
    func postCommentAdd(request: PostCommentRequestDTO) -> Completable {
        let endPoint = CommentAPIEndPoint.postCommentAdd(request: request)
        return provider.request(with: endPoint, interceptor: tokenInterceptor)
    }
}
