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
    }
    
    enum Mutation {
        case loadView
    }
    
    struct State {
        var sections: [any Sectionable] = []
    }
    
    // MARK: - properties
    
    var initialState: State
    var disposeBag = DisposeBag()
    private let popUpID: Int64
    
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
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .loadView:
            newState.sections = getSection()
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
                
                // contentSection
                owner.contentSection.inputDataList = [.init(content: response.desc)]
                return .loadView
            }
    }
}
