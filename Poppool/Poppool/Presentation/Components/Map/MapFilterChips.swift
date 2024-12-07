//
//  MapFilterChips.swift
//  Poppool
//
//  Created by 김기현 on 12/3/24.
//
import UIKit
import SnapKit

final class MapFilterChips: UIView {

    // MARK: - Components
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()

    let locationChip: PPSegmentedControl = {
        let control = PPSegmentedControl(type: .base, segments: ["서울전체"], selectedSegmentIndex: 0)
        return control
    }()

    let categoryChip: PPSegmentedControl = {
        let control = PPSegmentedControl(type: .base, segments: ["요리/음식 외 2개"], selectedSegmentIndex: 0)
        return control
    }()

    // MARK: - init
    init() {
        super.init(frame: .zero)
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension MapFilterChips {
    func setUpConstraints() {
        addSubview(stackView)
        stackView.addArrangedSubview(locationChip)
        stackView.addArrangedSubview(categoryChip)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(32)
        }
    }
}

// MARK: - Inputable
extension MapFilterChips: Inputable {
    struct Input {
        let locationText: String
        let categoryText: String
    }

    func injection(with input: Input) {
        locationChip.setTitle(input.locationText, forSegmentAt: 0)
        categoryChip.setTitle(input.categoryText, forSegmentAt: 0)
    }
}
