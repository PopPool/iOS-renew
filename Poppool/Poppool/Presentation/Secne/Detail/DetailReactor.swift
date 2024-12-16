//
//  DetailReactor.swift
//  Poppool
//
//  Created by SeoJunYoung on 12/9/24.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa

final class DetailReactor: Reactor {
    
    // MARK: - Reactor
    enum Action {
        case viewWillAppear
        case commentButtonTapped(controller: BaseViewController)
    }
    
    enum Mutation {
        case loadView
        case moveToCommentTypeSelectedScene(controller: BaseViewController)
    }
    
    struct State {
        var sections: [any Sectionable] = []
    }
    
    // MARK: - properties
    
    var initialState: State
    var disposeBag = DisposeBag()
    private let popUpID: Int64
    private var popUpName: String?
    
    private let popUpAPIUseCase = PopUpAPIUseCaseImpl(repository: PopUpAPIRepositoryImpl(provider: ProviderImpl()))
    lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        UICollectionViewCompositionalLayout { [weak self] section, env in
            guard let self = self else {
                return NSCollectionLayoutSection(group: NSCollectionLayoutGroup(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    ))
                )
            }
            return getSection()[section].getSection(section: section, env: env)
        }
    }()
    
    private var imageBannerSection = ImageBannerSection(inputDataList: [])
    private var spacing36Section = SpacingSection(inputDataList: [.init(spacing: 36)])
    private var spacing20Section = SpacingSection(inputDataList: [.init(spacing: 20)])
    private var titleSection = DetailTitleSection(inputDataList: [.init(title: "hi", isBookMark: false)])
    private var contentSection = DetailContentSection(inputDataList: [])
    
    // MARK: - init
    init(popUpID: Int64) {
        self.popUpID = popUpID
        self.initialState = State()
    }
    
    // MARK: - Reactor Methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return setContent()
        case .commentButtonTapped(let controller):
            return Observable.just(.moveToCommentTypeSelectedScene(controller: controller))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .loadView:
            newState.sections = getSection()
        case .moveToCommentTypeSelectedScene(let controller):
            let nextController = CommentSelectedController()
            nextController.reactor = CommentSelectedReactor()
            controller.presentPanModal(nextController)
            nextController.reactor?.state
                .withUnretained(nextController)
                .subscribe(onNext: { (nextController, state) in
                    switch state.selectedType {
                    case .cancel:
                        nextController.dismiss(animated: true)
                    case .normal:
                        nextController.dismiss(animated: true) {
                            let commentController = NormalCommentAddController()
                            commentController.reactor = NormalCommentAddReactor(popUpID: self.popUpID, popUpName: self.popUpName ?? "")
                            controller.navigationController?.pushViewController(commentController, animated: true)
                        }
                    case .insta:
                        nextController.dismiss(animated: true) {
                            let commentController = InstaCommentAddController()
                            commentController.reactor = InstaCommentAddReactor()
                            controller.navigationController?.pushViewController(commentController, animated: true)
                        }
                    case .none:
                        break
                    }
                })
                .disposed(by: disposeBag)
        }
        return newState
    }
    
    func getSection() -> [any Sectionable] {
        return [
            imageBannerSection,
            spacing36Section,
            titleSection,
            spacing20Section,
            contentSection,
        ]
    }
    
    func setContent() -> Observable<Mutation> {
        return popUpAPIUseCase.getPopUpDetail(commentType: "NORMAL", popUpStoredId: popUpID)
            .withUnretained(self)
            .map { (owner, response) in

                // image Banner
                let imagePaths = response.imageList.compactMap { $0.imageUrl }
                let idList = response.imageList.map { $0.id }
                owner.imageBannerSection.inputDataList = [.init(imagePaths: imagePaths, idList: idList, isHiddenPauseButton: true)]
                
                // titleSection
                owner.titleSection.inputDataList = [.init(title: response.name, isBookMark: response.bookmarkYn)]
                owner.popUpName = response.name
                
                // contentSection
                owner.contentSection.inputDataList = [.init(content: response.desc)]
                print(response.commentList)
                return .loadView
            }
    }
}
