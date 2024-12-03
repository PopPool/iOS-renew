//
//  HomeListReactor.swift
//  Poppool
//
//  Created by SeoJunYoung on 12/2/24.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa

final class HomeListReactor: Reactor {
    
    // MARK: - Reactor
    enum Action {
        case viewWillAppear
        case backButtonTapped(controller: BaseViewController)
        case bookMarkButtonTapped(indexPath: IndexPath)
    }
    
    enum Mutation {
        case moveToRecentScene(controller: BaseViewController)
        case loadView
        case reloadView(indexPath: IndexPath)
    }
    
    struct State {
        var popUpType: HomePopUpType
        var sections: [any Sectionable] = []
    }
    
    // MARK: - properties
    
    var initialState: State
    var disposeBag = DisposeBag()
    var popUpType: HomePopUpType
    
    private let homeAPIUseCase = HomeUseCaseImpl()
    private let userDefaultService = UserDefaultService()
    private let userAPIUseCase = UserAPIUseCaseImpl(repository: UserAPIRepositoryImpl(provider: ProviderImpl()))
    
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
    
    private var cardSections = HomeCardGridSection(inputDataList: [])
    
    // MARK: - init
    init(popUpType: HomePopUpType) {
        self.initialState = State(popUpType: popUpType)
        self.popUpType = popUpType
    }
    
    // MARK: - Reactor Methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            guard let userID = userDefaultService.fetch(key: "userID") else { return Observable.just(.loadView) }
            return homeAPIUseCase.fetchHome(userId: userID, page: 0, size: 10, sort: "viewCount,desc")
                .withUnretained(self)
                .map { (owner, response) in
                    owner.setSection(response: response)
                    return .loadView
                }
        case .backButtonTapped(let controller):
            return Observable.just(.moveToRecentScene(controller: controller))
        case .bookMarkButtonTapped(let indexPath):
            guard let userID = userDefaultService.fetch(key: "userID") else { return Observable.just(.loadView) }
            var popUpData = cardSections.inputDataList[indexPath.row]
            if popUpData.isBookmark {
                return userAPIUseCase.deleteBookmarkPopUp(userID: userID, popUpID: popUpData.id)
                    .andThen(Observable.just(.reloadView(indexPath: indexPath)))
            } else {
                return userAPIUseCase.postBookmarkPopUp(userID: userID, popUpID: popUpData.id)
                    .andThen(Observable.just(.reloadView(indexPath: indexPath)))
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .moveToRecentScene(let controller):
            controller.navigationController?.popViewController(animated: true)
        case .loadView:
            newState.sections = getSection()
        case .reloadView(let indexPath):
            cardSections.inputDataList[indexPath.row].isBookmark.toggle()
            newState.sections = getSection()
        }
        return newState
    }
    
    func getSection() -> [any Sectionable] {
        return [cardSections]
    }
    
    func setSection(response: GetHomeInfoResponse) {
        switch popUpType {
        case .curation:
            cardSections.inputDataList = response.customPopUpStoreList.map({ response in
                return .init(
                    imagePath: response.mainImageUrl,
                    id: response.id,
                    category: response.category,
                    title: response.name,
                    address: response.address,
                    startDate: response.startDate,
                    endDate: response.endDate,
                    isBookmark: response.bookmarkYn
                )
            })
        case .new:
            cardSections.inputDataList = response.newPopUpStoreList.map({ response in
                return .init(
                    imagePath: response.mainImageUrl,
                    id: response.id,
                    category: response.category,
                    title: response.name,
                    address: response.address,
                    startDate: response.startDate,
                    endDate: response.endDate,
                    isBookmark: response.bookmarkYn
                )
            })
        case .popular:
            cardSections.inputDataList = response.popularPopUpStoreList.map({ response in
                return .init(
                    imagePath: response.mainImageUrl,
                    id: response.id,
                    category: response.category,
                    title: response.name,
                    address: response.address,
                    startDate: response.startDate,
                    endDate: response.endDate,
                    isBookmark: response.bookmarkYn
                )
            })
        }
    }
}
