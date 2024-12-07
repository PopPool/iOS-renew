//
//  MapViewController.swift
//  Poppool
//
//  Created by 김기현 on 12/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import ReactorKit
import GoogleMaps

final class MapViewController: BaseViewController, View {

    typealias Reactor = MapReactor

    // MARK: - Properties
    var disposeBag = DisposeBag()

    // MARK: - UI Components
    let mainView = MapView()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: - SetUp
private extension MapViewController {
    func setUp() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        // 테스트용 마커 추가
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 37.5666, longitude: 126.9784)

        let markerView = MapMarker()
        markerView.injection(with: .init(title: "서울", count: 3))
        marker.iconView = markerView
        marker.map = mainView.mapView

        // 테스트용 카드 데이터
        mainView.storeCard.injection(with: .init(
            image: nil,
            category: "음식/요리",
            title: "테스트 팝업스토어",
            location: "서울시 강남구",
            date: "2024.12.03 - 2024.12.31"
        ))
    }
}

// MARK: - Binding
extension MapViewController {
    func bind(reactor: Reactor) {
        // Action
        mainView.searchInput.rx.tapGesture()
            .when(.recognized)
            .map { _ in Reactor.Action.searchTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.locationButton.rx.tap
            .map { Reactor.Action.locationButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.listButton.rx.tap
            .map { Reactor.Action.listButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // State
        reactor.state.map { $0.selectedStore }
            .distinctUntilChanged()
            .bind { [weak self] store in
                self?.mainView.storeCard.isHidden = (store == nil)
            }
            .disposed(by: disposeBag)
    }
}
