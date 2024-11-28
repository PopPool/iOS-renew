//
//  HomePopUpViewController.swift
//  Poppool
//
//  Created by Porori on 11/27/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

final class HomePopUpViewController: BaseViewController, View {
    
    typealias Reactor = HomePopUpReactor
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    let reactor = HomePopUpReactor()
    
    private var mainView = HomePopUpView()
}

// MARK: - Life Cycle
extension HomePopUpViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        configureData()
        bind(reactor: reactor)
    }
}

// MARK: - SetUp
private extension HomePopUpViewController {
    func setUp() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureData() {
        mainView.collectionView.register(
            HomePopUpCollectionViewCell.self,
            forCellWithReuseIdentifier: HomePopUpCollectionViewCell.identifiers)
        
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.header.configure(with: "새로운 값")
    }
}

// MARK: - Methods
extension HomePopUpViewController {
    func bind(reactor: Reactor) {
        
        Observable.just(Reactor.Action.viewWillAppear)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.header.backButton.rx.tap
            .debug("header backButton이 눌렸습니다.")
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.toggledBookmark }
            .withUnretained(self)
            .subscribe(onNext: { (owner, bookmarks) in
                owner.mainView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.dismissed }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension HomePopUpViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reactor.currentState.toggledBookmark.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePopUpCollectionViewCell.identifiers, for: indexPath) as? HomePopUpCollectionViewCell else { return UICollectionViewCell() }
        
        let item = reactor.currentState.toggledBookmark[indexPath.item]
        let itemId = item.id
        
        cell.configure(with: item)
        cell.injection(with: HomePopUpCollectionViewCell.Input(
            image: UIImage(systemName: "photo"),
            category: "카테고리 더미",
            title: "팝업 이름팝업 이름팝업 이름팝업 이름팝업 이름팝업 이름팝업 이름팝업 이름",
            location: "팝업 지역 정보",
            date: "날짜 날짜"))
        
        cell.bookmarkButton.rx.tap
            .map { Reactor.Action.bookmarkButtonTapped(indexPath: indexPath) }
            .bind(to: reactor.action)
            .disposed(by: cell.disposeBag)
        
        return cell
    }
}
