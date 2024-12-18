import UIKit
import SnapKit

final class FilterBottomSheetView: UIView {
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()

    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let titleLabel: PPLabel = {
        let label = PPLabel(style: .bold, fontSize: 18, text: "보기 옵션을 선택해주세요")
        label.textColor = .black
        return label
    }()


    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icon_xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()

    let segmentedControl: PPSegmentedControl = {
        let control = PPSegmentedControl(type: .tab, segments: ["지역", "카테고리"], selectedSegmentIndex: 0)
        return control
    }()

    let locationScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    let locationContentView = UIView()
    let categoryCollectionView: UICollectionView = {
           let layout = UICollectionViewCompositionalLayout { section, env in
               let itemSize = NSCollectionLayoutSize(
                   widthDimension: .estimated(26),
                   heightDimension: .absolute(36)
               )
               let item = NSCollectionLayoutItem(layoutSize: itemSize)

               let groupSize = NSCollectionLayoutSize(
                   widthDimension: .fractionalWidth(1.0),
                   heightDimension: .estimated(1000)
               )
               let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
               group.interItemSpacing = .fixed(12)

               let section = NSCollectionLayoutSection(group: group)
               section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
               section.interGroupSpacing = 16

               return section
           }
           let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
           collectionView.backgroundColor = .clear
           collectionView.isScrollEnabled = false
           collectionView.register(TagSectionCell.self, forCellWithReuseIdentifier: TagSectionCell.identifiers)
           return collectionView
       }()
    let balloonBackgroundView = BalloonBackgroundView()
//    let categoryScrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.isHidden = true
//        return scrollView
//    }()
//    let categoryContentView = UIView()

    let resetButton: PPButton = {
        let button = PPButton(
            style: .secondary,
            text: "초기화",
            font: .KorFont(style: .medium, size: 16),
            cornerRadius: 8
        )
        return button
    }()

    let saveButton: PPButton = {
        let button = PPButton(
            style: .primary,
            text: "옵션저장",
            font: .KorFont(style: .medium, size: 16),
            cornerRadius: 8
        )
        return button
    }()

    private let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()

    let filterChipsView: FilterChipsView = {
        let view = FilterChipsView()
        return view
    }()

    private var balloonHeightConstraint: Constraint?

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupLayout() {
        backgroundColor = .clear
        addSubview(containerView)

        containerView.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(closeButton)

        containerView.addSubview(segmentedControl)
        containerView.addSubview(locationScrollView)
        locationScrollView.addSubview(locationContentView)

        containerView.addSubview(balloonBackgroundView)
        containerView.addSubview(categoryCollectionView)
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(195)
        }

//        containerView.addSubview(categoryScrollView)
//        categoryScrollView.addSubview(categoryContentView)
        containerView.addSubview(filterChipsView)
        buttonStack.addArrangedSubview(resetButton)
        buttonStack.addArrangedSubview(saveButton)
        containerView.addSubview(buttonStack)

        filterChipsView.snp.makeConstraints { make in
            make.top.equalTo(balloonBackgroundView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(80)
        }


        setupConstraints()
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.top)
        }

        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }

        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }

        locationScrollView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }

        locationContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }

        balloonBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(locationScrollView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
//            make.height.equalTo(100)
        }


//        categoryScrollView.snp.makeConstraints { make in
//            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
//            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(200)
//        }
//
//        categoryContentView.snp.makeConstraints { make in
////            make.edges.equalToSuperview()
//            make.top.equalTo(segmentedControl.snp.bottom).offset(20)
//            make.leading.equalToSuperview().inset(20)
////            make.width.equalToSuperview()
//        }

        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(filterChipsView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
    }

    func setupLocationScrollView(locations: [Location], buttonAction: @escaping (Int) -> Void) {
        locationContentView.subviews.forEach { $0.removeFromSuperview() }

        var lastButton: UIButton?

        for (index, location) in locations.enumerated() {
            let button = createStyledButton(title: location.main)
            button.tag = index

            button.addAction(UIAction { _ in
                buttonAction(index)
                self.updateMainLocationSelection(index)
            }, for: .touchUpInside)

            locationContentView.addSubview(button)

            button.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()  // 상하 제약
                if let lastButton = lastButton {
                    make.leading.equalTo(lastButton.snp.trailing).offset(12) // 버튼 간 간격 12px
                } else {
                    make.leading.equalToSuperview().offset(16) // 첫 버튼 leading 패딩
                }
            }

            lastButton = button
        }

        if let lastButton = lastButton {
            lastButton.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(16) // 마지막 버튼 trailing 패딩
            }
        }
    }

    func setupCategoryButtons(items: [String], selectedItems: [String], buttonAction: @escaping (String) -> Void) {
        categoryCollectionView.subviews.forEach { $0.removeFromSuperview() }

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16

        let itemsPerRow = 4
        var rowStack: UIStackView?

        for (index, item) in items.enumerated() {
            if index % itemsPerRow == 0 {
                rowStack = UIStackView()
                rowStack?.axis = .horizontal
                rowStack?.spacing = 12
                rowStack?.distribution = .fill
                stackView.addArrangedSubview(rowStack!)
            }

            let button = createCategoryButton(title: item, isSelected: selectedItems.contains(item))
            rowStack?.addArrangedSubview(button)
        }

        categoryCollectionView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }



    private func createCategoryButton(title: String, isSelected: Bool) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true

        button.contentEdgeInsets = UIEdgeInsets(top: 9, left: 16, bottom: 9, right: 12)

        if isSelected {
            button.backgroundColor = .blu500
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = .white
            button.setTitleColor(.g500, for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.g200.cgColor
        }

        return button
    }




    func updateContentVisibility(isCategorySelected: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.locationScrollView.isHidden = isCategorySelected
            self.balloonBackgroundView.isHidden = isCategorySelected
            self.categoryCollectionView.isHidden = !isCategorySelected

            self.balloonBackgroundView.snp.remakeConstraints { make in
                make.top.equalTo(self.locationScrollView.snp.bottom).offset(16)
                make.leading.trailing.equalToSuperview().inset(16)
                make.height.equalTo(isCategorySelected ? 0 : 80)
            }
            self.layoutIfNeeded()
        }
    }


    private func createStyledButton(title: String, isSelected: Bool = false) -> PPButton {
        let button = PPButton(
            style: .secondary,
            text: title,
            font: .KorFont(style: .regular, size: 14),
            cornerRadius: 22
        )
        button.setBackgroundColor(.w100, for: .normal)
        button.setTitleColor(.g700, for: .normal)
        button.layer.borderColor = UIColor.g400.cgColor
        button.layer.borderWidth = 1

        if isSelected {
            button.setBackgroundColor(.blu500, for: .normal)
            button.setTitleColor(.w100, for: .normal)
            button.layer.borderWidth = 0
        }

        button.contentEdgeInsets = UIEdgeInsets(top: 9, left: 16, bottom: 9, right: 12)

        return button
    }

    func updateMainLocationSelection(_ index: Int) {
        locationContentView.subviews.enumerated().forEach { (idx, view) in
            guard let button = view as? PPButton else { return }
            if idx == index {
                button.setBackgroundColor(.blu500, for: .normal)
                button.setTitleColor(.w100, for: .normal)
                button.layer.borderWidth = 0
            } else {
                button.setBackgroundColor(.w100, for: .normal)
                button.setTitleColor(.g700, for: .normal)
                button.layer.borderColor = UIColor.g200.cgColor
                button.layer.borderWidth = 1
            }
        }

    }

    func updateBalloonHeight(isHidden: Bool, dynamicHeight: CGFloat = 80) {
        UIView.animate(withDuration: 0.3) {
            let targetHeight = isHidden ? 0 : dynamicHeight
            self.balloonHeightConstraint?.update(offset: targetHeight)
            self.balloonBackgroundView.isHidden = isHidden
            self.layoutIfNeeded()
        }
    }

    func updateBalloonPosition(for button: UIButton) {
        let buttonFrame = button.convert(button.bounds, to: self)
        let buttonCenterX = buttonFrame.midX
        let totalWidth = bounds.width
        balloonBackgroundView.arrowPosition = buttonCenterX / totalWidth
    }

}
extension FilterBottomSheetView {
    func update(locationText: String?, categoryText: String?) {
        var filters: [String] = []

        if let locationText = locationText, !locationText.isEmpty {
            filters.append(locationText)
        }
        if let categoryText = categoryText, !categoryText.isEmpty {
            filters.append(categoryText)
        }

        filterChipsView.updateChips(with: filters)
    }
}
