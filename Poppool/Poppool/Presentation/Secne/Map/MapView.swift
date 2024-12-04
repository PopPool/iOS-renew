//
//  MapView.swift
//  Poppool
//
//  Created by 김기현 on 12/3/24.
//

import UIKit
import SnapKit
import GoogleMaps

final class MapView: UIView {

    // MARK: - Components
    let mapView: GMSMapView = {
        let camera = GMSCameraPosition(latitude: 37.5666, longitude: 126.9784, zoom: 15)
        let view = GMSMapView(frame: .zero, camera: camera)
        view.settings.myLocationButton = false
        return view
    }()

    let searchInput = MapSearchInput()
    let filterChips = MapFilterChips()
    let locationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_current_location"), for: .normal)
        button.backgroundColor = .w100
        button.layer.cornerRadius = 22
        button.layer.applyMapButtonShadow()
        return button
    }()

    let listButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_list"), for: .normal)
        button.backgroundColor = .w100
        button.layer.cornerRadius = 22
        button.layer.applyMapButtonShadow()
        return button
    }()

    let storeCard = MapStoreCard()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setUpConstraints()
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension MapView {
    func setUpConstraints() {
        // Map View
        addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // Search Input
        addSubview(searchInput)
        searchInput.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        // Filter Chips
        addSubview(filterChips)
        filterChips.snp.makeConstraints { make in
            make.top.equalTo(searchInput.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        // Buttons
        addSubview(locationButton)
        locationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(listButton.snp.top).offset(-12)
            make.size.equalTo(44)
        }

        addSubview(listButton)
        listButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(storeCard.snp.top).offset(-16)
            make.size.equalTo(44)
        }

        // Store Card
        addSubview(storeCard)
        storeCard.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

    func configureUI() {
        backgroundColor = .white
        filterChips.injection(with: .init(locationText: "서울전체", categoryText: "요리/음식 외 2개"))

        // 초기에는 카드 숨김
        storeCard.isHidden = true
    }
}

// Shadow Extension
private extension CALayer {
    func applyMapButtonShadow() {
        shadowColor = UIColor.black.cgColor
        shadowOffset = CGSize(width: 0, height: 2)
        shadowRadius = 4
        shadowOpacity = 0.1
    }
}
