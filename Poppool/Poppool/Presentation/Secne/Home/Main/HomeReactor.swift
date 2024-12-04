//
//  HomeReactor.swift
//  Poppool
//
//  Created by SeoJunYoung on 11/28/24.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa

final class HomeReactor: Reactor {
    
    // MARK: - Reactor
    enum Action {
        case viewWillAppear
        case changeHeaderState(isDarkMode: Bool)
        case detailButtonTapped(controller: BaseViewController, indexPath: IndexPath)
        case bookMarkButtonTapped(indexPath: IndexPath)
    }
    
    enum Mutation {
        case loadView
        case setHedaerState(isDarkMode: Bool)
        case moveToDetailScene(controller: BaseViewController, indexPath: IndexPath)
        case reloadView(indexPath: IndexPath)
    }
    
    struct State {
        var sections: [any Sectionable] = []
        var headerIsDarkMode: Bool = true
        var isReloadView: Bool = false
    }
    
    // MARK: - properties
    
    var initialState: State
    
    var disposeBag = DisposeBag()
    
    private let homeApiUseCase = HomeUseCaseImpl()
    private let userAPIUseCase = UserAPIUseCaseImpl(repository: UserAPIRepositoryImpl(provider: ProviderImpl()))
    private let userDefaultService = UserDefaultService()
    
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
    private var isLoign: Bool = false
    private var loginImageBannerSection = ImageBannerSection(inputDataList: [])
    private var curationTitleSection = HomeTitleSection(inputDataList: [])
    private var curationSection = HomeCardSection(inputDataList: [])
    private var popularTitleSection = HomeTitleSection(inputDataList: [
        .init(blueText: "팝풀이", topSubText: "들은 지금 이런", bottomText: "팝업에 가장 관심있어요", backgroundColor: .g700, textColor: .w100)
    ])
    private var popularSection = HomePopularCardSection(inputDataList: [], decorationItems: [SectionDecorationItem(elementKind: "BackgroundView", reusableView: SectionBackGroundDecorationView(), viewInput: .init(backgroundColor: .g700))])
    private var newTitleSection = HomeTitleSection(inputDataList: [.init(blueText: "제일 먼저", topSubText: "피드 올리는", bottomText: "신규 오픈 팝업")])
    private var newSection = HomeCardSection(inputDataList: [])
    private var spaceClear48Section = SpacingSection(inputDataList: [.init(spacing: 48)])
    private var spaceClear40Section = SpacingSection(inputDataList: [.init(spacing: 40)])
    private var spaceClear28Section = SpacingSection(inputDataList: [.init(spacing: 28)])
    private var spaceClear24Section = SpacingSection(inputDataList: [.init(spacing: 24)])
    private var spaceGray40Section = SpacingSection(inputDataList: [.init(spacing: 40, backgroundColor: .g700)])
    private var spaceGray28Section = SpacingSection(inputDataList: [.init(spacing: 28, backgroundColor: .g700)])
    private var spaceGray24Section = SpacingSection(inputDataList: [.init(spacing: 24, backgroundColor: .g700)])
    
    // MARK: - init
    init() {
        self.initialState = State()
    }
    
    // MARK: - Reactor Methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return homeApiUseCase.fetchHome(page: 0, size: 6, sort: "viewCount,desc")
                .withUnretained(self)
                .map { (owner, response) in
                    owner.setBannerSection(response: response)
                    owner.setCurationTitleSection(response: response)
                    owner.setCurationSection(response: response)
                    owner.setPopularSection(response: response)
                    owner.setNewSection(response: response)
                    owner.isLoign = response.loginYn
                    return .loadView
                }
        case .changeHeaderState(let isDarkMode):
            return Observable.just(.setHedaerState(isDarkMode: isDarkMode))
        case .detailButtonTapped(let controller, let indexPath):
            return Observable.just(.moveToDetailScene(controller: controller, indexPath: indexPath))
        case .bookMarkButtonTapped(let indexPath):
            var popUpData = getPopUpData(indexPath: indexPath)
            if popUpData.isBookmark {
                return userAPIUseCase.deleteBookmarkPopUp(popUpID: popUpData.id)
                    .andThen(Observable.just(.reloadView(indexPath: indexPath)))
            } else {
                return userAPIUseCase.postBookmarkPopUp(popUpID: popUpData.id)
                    .andThen(Observable.just(.reloadView(indexPath: indexPath)))
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.isReloadView = false
        switch mutation {
        case .loadView:
            newState.isReloadView = true
            newState.sections = getSection()
        case .setHedaerState(let isDarkMode):
            newState.headerIsDarkMode = isDarkMode
        case .moveToDetailScene(let controller, let indexPath):
            let nextController = getDetailController(indexPath: indexPath)
            controller.navigationController?.pushViewController(nextController, animated: true)
        case .reloadView(let indexPath):
            if isLoign {
                switch indexPath.section {
                case 4:
                    curationSection.inputDataList[indexPath.row].isBookmark.toggle()
                default:
                    newSection.inputDataList[indexPath.row].isBookmark.toggle()
                }
            } else {
                switch indexPath.section {
                default:
                    newSection.inputDataList[indexPath.row].isBookmark.toggle()
                }
            }
            newState.isReloadView = true
            newState.sections = getSection()
        }
        return newState
    }
    
    func getSection() -> [any Sectionable] {
        
        if isLoign {
            return [
                loginImageBannerSection,
                spaceClear40Section,
                curationTitleSection,
                spaceClear24Section,
                curationSection,
                spaceClear40Section,
                spaceGray28Section,
                popularTitleSection,
                spaceGray24Section,
                popularSection,
                spaceGray28Section,
                spaceClear48Section,
                newTitleSection,
                spaceClear24Section,
                newSection,
                spaceClear48Section
            ]
        } else {
            return [
                loginImageBannerSection,
                spaceGray40Section,
                popularTitleSection,
                spaceGray24Section,
                popularSection,
                spaceGray28Section,
                spaceClear48Section,
                newTitleSection,
                spaceClear24Section,
                newSection,
                spaceClear48Section
            ]
        }

    }
    
    func setBannerSection(response: GetHomeInfoResponse) {
        let imagePaths = response.bannerPopUpStoreList.map { $0.mainImageUrl }
        let idList = response.bannerPopUpStoreList.map { $0.id }
        loginImageBannerSection.inputDataList = [.init(imagePaths: imagePaths, idList: idList)]
    }
    
    func setCurationTitleSection(response: GetHomeInfoResponse) {
        curationTitleSection.inputDataList = [.init(blueText: response.nickname, topSubText: "님을 위한", bottomText: "맞춤 팝업 큐레이션")]
    }
    
    func setCurationSection(response: GetHomeInfoResponse) {
        curationSection.inputDataList = response.customPopUpStoreList.map({ response in
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
    
    func setPopularSection(response: GetHomeInfoResponse) {
        popularSection.inputDataList = response.popularPopUpStoreList.map({ response in
            return .init(
                imagePath: response.mainImageUrl,
                endDate: response.endDate,
                category: response.category,
                title: response.name,
                id: response.id
            )
        })
    }
    
    func setNewSection(response: GetHomeInfoResponse) {
        newSection.inputDataList = response.newPopUpStoreList.map({ response in
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
    
    func getDetailController(indexPath: IndexPath) -> BaseViewController {
        if isLoign {
            switch indexPath.section {
            case 2:
                let controller = HomeListController()
                controller.reactor = HomeListReactor(popUpType: .curation)
                return controller
            case 7:
                let controller = HomeListController()
                controller.reactor = HomeListReactor(popUpType: .popular)
                return controller
            default:
                let controller = HomeListController()
                controller.reactor = HomeListReactor(popUpType: .new)
                return controller
            }
        } else {
            switch indexPath.section {
            case 2:
                let controller = HomeListController()
                controller.reactor = HomeListReactor(popUpType: .popular)
                return controller
            default:
                let controller = HomeListController()
                controller.reactor = HomeListReactor(popUpType: .new)
                return controller
            }
        }
    }
    
    func getPopUpData(indexPath: IndexPath) -> HomeCardSectionCell.Input {
        if isLoign {
            switch indexPath.section {
            case 4:
                return curationSection.inputDataList[indexPath.row]
            default:
                return newSection.inputDataList[indexPath.row]
            }
        } else {
            switch indexPath.section {
            default:
                return newSection.inputDataList[indexPath.row]
            }
        }
    }
}
