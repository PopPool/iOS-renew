//
//  SearchReactor.swift
//  Poppool
//
//  Created by SeoJunYoung on 12/4/24.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa

final class SearchReactor: Reactor {
    
    // MARK: - Reactor
    enum Action {
        case viewWillAppear
        case returnSearchKeyword(text: String?)
        case recentSearchListDeleteButtonTapped(indexPath: IndexPath)
        case recentSearchListAllDeleteButtonTapped
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
    
    private let recentKeywordTitleSection = SearchTitleSection(inputDataList: [.init(title: "최근 검색어", buttonTitle: "모두삭제")])
    private var recentKeywordSection = CancelableTagSection(inputDataList: [])
    
    private let searchTitleSection = SearchTitleSection(inputDataList: [.init(title: "팝업스토어 찾기")])
    private let searchCategorySection = CancelableTagSection(inputDataList: [
        .init(title: "팝업스토어명", isSelected: true),
        .init(title: "팝업스토어명", isSelected: true),
        .init(title: "팝업스토어명", isSelected: true),
        .init(title: "팝업스토어명", isSelected: true),
        .init(title: "팝업스토어명", isSelected: true)
    ])
    private let spacing24Section = SpacingSection(inputDataList: [.init(spacing: 24)])
    private let spacing16Section = SpacingSection(inputDataList: [.init(spacing: 16)])
    private let spacing48Section = SpacingSection(inputDataList: [.init(spacing: 48)])
    
    // MARK: - init
    init() {
        self.initialState = State()
    }
    
    // MARK: - Reactor Methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            setSearchList()
            return Observable.just(.loadView)
        case .returnSearchKeyword(let text):
            appendSearchList(text: text)
            return Observable.just(.loadView)
        case .recentSearchListDeleteButtonTapped(let indexPath):
            removeSearchList(indexPath: indexPath)
            return Observable.just(.loadView)
        case .recentSearchListAllDeleteButtonTapped:
            resetSearchList()
            return Observable.just(.loadView)
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
            spacing24Section,
            recentKeywordTitleSection,
            spacing16Section,
            recentKeywordSection,
            spacing48Section,
            searchTitleSection,
            spacing16Section,
            searchCategorySection
        ]
    }
    
    func setSearchList() {
        let searchList = userDefaultService.fetchArray(key: "searchList") ?? []
        recentKeywordSection.inputDataList = searchList.map { return .init(title: $0) }
    }
    
    func appendSearchList(text: String?) {
        if let text = text {
            if !text.isEmpty {
                var searchList = userDefaultService.fetchArray(key: "searchList") ?? []
                if searchList.contains(text) {
                    let targetIndex = searchList.firstIndex(of: text)!
                    searchList.remove(at: targetIndex)   
                }
                searchList = [text] + searchList
                userDefaultService.save(key: "searchList", value: searchList)
                recentKeywordSection.inputDataList = searchList.map { return .init(title: $0) }
            }
        }
    }
    
    func removeSearchList(indexPath: IndexPath) {
        var searchList = userDefaultService.fetchArray(key: "searchList") ?? []
        searchList.remove(at: indexPath.row)
        userDefaultService.save(key: "searchList", value: searchList)
        recentKeywordSection.inputDataList = searchList.map { return .init(title: $0) }
    }
    
    func resetSearchList() {
        userDefaultService.save(key: "searchList", value: [])
        recentKeywordSection.inputDataList = []
    }
}
