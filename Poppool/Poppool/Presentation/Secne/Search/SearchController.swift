//
//  SearchController.swift
//  Poppool
//
//  Created by SeoJunYoung on 12/4/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift
import ReactorKit
import RxGesture

final class SearchController: BaseViewController, View {
    
    typealias Reactor = SearchReactor
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    private var mainView = SearchView()
    private var sections: [any Sectionable] = []
}

// MARK: - Life Cycle
extension SearchController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - SetUp
private extension SearchController {
    func setUp() {
        if let layout = reactor?.compositionalLayout {
            mainView.contentCollectionView.collectionViewLayout = layout
        }
        mainView.contentCollectionView.delegate = self
        mainView.contentCollectionView.dataSource = self
        mainView.contentCollectionView.register(
            SearchTitleSectionCell.self,
            forCellWithReuseIdentifier: SearchTitleSectionCell.identifiers
        )
        mainView.contentCollectionView.register(
            SpacingSectionCell.self,
            forCellWithReuseIdentifier: SpacingSectionCell.identifiers
        )
        mainView.contentCollectionView.register(
            CancelableTagSectionCell.self,
            forCellWithReuseIdentifier: CancelableTagSectionCell.identifiers
        )
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods
extension SearchController {
    func bind(reactor: Reactor) {
        
        mainView.rx.tapGesture()
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.mainView.endEditing(true)
            }
            .disposed(by: disposeBag)
            
        mainView.searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .withUnretained(self)
            .map({ (owner, _) in
                Reactor.Action.returnSearchKeyword(text: owner.mainView.searchTextField.text)
            })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .withUnretained(self)
            .subscribe { (owner, state) in
                owner.sections = state.sections
                owner.mainView.contentCollectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SearchController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].dataCount
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = sections[indexPath.section].getCell(collectionView: collectionView, indexPath: indexPath)
        guard let reactor = reactor else { return cell }
        if let cell = cell as? SearchTitleSectionCell {
            if indexPath.section == 1 {
                cell.titleButton.rx.tap
                    .map { Reactor.Action.recentSearchListAllDeleteButtonTapped }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
            }
        }
        if let cell = cell as? CancelableTagSectionCell {
            if indexPath.section == 3 {
                cell.cancelButton.rx.tap
                    .map { Reactor.Action.recentSearchListDeleteButtonTapped(indexPath: indexPath)}
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
            }
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        mainView.endEditing(true)
    }
}
