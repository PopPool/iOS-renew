//
//  SignUpStep3Reactor.swift
//  Poppool
//
//  Created by SeoJunYoung on 11/25/24.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa

final class SignUpStep3Reactor: Reactor {
    
    // MARK: - Reactor
    enum Action {
        case viewWillAppear
        case selectedTag(indexPath: IndexPath)
    }
    
    enum Mutation {
        case loadView
    }
    
    struct State {
        var sections: [any Sectionable] = []
        var selectedCategory: [String] = []
    }
    
    // MARK: - properties
    
    var initialState: State
    var disposeBag = DisposeBag()
    
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
    
    var categorySection: TagSection = TagSection(inputDataList: [
        .init(title: "게임", isSelected: false),
        .init(title: "라이프스타일", isSelected: false),
        .init(title: "반려동물", isSelected: false),
        .init(title: "뷰티", isSelected: false),
        .init(title: "스포츠", isSelected: false),
        .init(title: "애니메이션", isSelected: false),
        .init(title: "엔터테인먼트", isSelected: false),
        .init(title: "여행", isSelected: false),
        .init(title: "예술", isSelected: false),
        .init(title: "음식/요리", isSelected: false),
        .init(title: "키즈", isSelected: false),
        .init(title: "패션", isSelected: false)
    ])
    
    // MARK: - init
    init() {
        self.initialState = State()
    }
    
    // MARK: - Reactor Methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return Observable.just(.loadView)
        case .selectedTag(let indexPath):
            let selectedCount = categorySection.inputDataList.map { $0.isSelected }.filter { $0 == true }.count
            if selectedCount >= 5 {
                if categorySection.inputDataList[indexPath.row].isSelected {
                    categorySection.inputDataList[indexPath.row].isSelected.toggle()
                } else {
                    ToastMaker.createToast(message: "최대 5개까지 선택할 수 있어요")
                }
                
            } else {
                categorySection.inputDataList[indexPath.row].isSelected.toggle()
            }
            return Observable.just(.loadView)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .loadView:
            newState.sections = getSection()
            newState.selectedCategory = categorySection.inputDataList.filter { $0.isSelected == true }.compactMap { $0.title }
        }
        return newState
    }
    
    func getSection() -> [any Sectionable] {
        return [
            categorySection
        ]
    }
}
