//
//  DetailController.swift
//  Poppool
//
//  Created by SeoJunYoung on 12/9/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

final class DetailController: BaseViewController, View {
    
    typealias Reactor = DetailReactor
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    private var mainView = DetailView()
    
    private var sections: [any Sectionable] = []
}

// MARK: - Life Cycle
extension DetailController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: - SetUp
private extension DetailController {
    func setUp() {
        if let layout = reactor?.compositionalLayout {
            mainView.contentCollectionView.collectionViewLayout = layout
        }
        mainView.contentCollectionView.delegate = self
        mainView.contentCollectionView.dataSource = self
        mainView.contentCollectionView.register(ImageBannerSectionCell.self, forCellWithReuseIdentifier: ImageBannerSectionCell.identifiers)
        mainView.contentCollectionView.register(SpacingSectionCell.self, forCellWithReuseIdentifier: SpacingSectionCell.identifiers)
        mainView.contentCollectionView.register(DetailTitleSectionCell.self, forCellWithReuseIdentifier: DetailTitleSectionCell.identifiers)
        mainView.contentCollectionView.register(DetailContentSectionCell.self, forCellWithReuseIdentifier: DetailContentSectionCell.identifiers)
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods
extension DetailController {
    func bind(reactor: Reactor) {
        rx.viewWillAppear
            .map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.commentPostButton.rx.tap
            .withUnretained(self)
            .map { (owner, _) in
                Reactor.Action.commentButtonTapped(controller: owner)
            }
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
extension DetailController: UICollectionViewDelegate, UICollectionViewDataSource {
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
        return cell
    }

}
