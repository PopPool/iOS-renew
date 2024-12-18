import UIKit
import SnapKit
import RxSwift
import RxCocoa
import ReactorKit

final class FilterBottomSheetViewController: UIViewController, View {
    typealias Reactor = FilterBottomSheetReactor

    // MARK: - Properties
    var disposeBag = DisposeBag()
    var onSave: (([String]) -> Void)?
    var onDismiss: (() -> Void)?
    private var bottomConstraint: Constraint?
    let containerView = FilterBottomSheetView()
    private var containerViewBottomConstraint: NSLayoutConstraint?
    private var savedLocation: String?
    private var savedCategory: String?
    private var tagSection: TagSection?

    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.alpha = 0
        return view
    }()

    // MARK: - Initialization
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupGestures()
        setupCollectionView()

    }

    // MARK: - Setup
    private func setupLayout() {
        view.backgroundColor = .clear
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true


        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height * 0.75)
            bottomConstraint = make.bottom.equalToSuperview().offset(UIScreen.main.bounds.height).constraint
        }
    }

    private func setupCollectionView() {
        containerView.categoryCollectionView.dataSource = self
        containerView.categoryCollectionView.delegate = self
    }
    // MARK: - Binding
    func bind(reactor: Reactor) {
        // 1. 세그먼트 컨트롤 바인딩
        containerView.segmentedControl.rx.selectedSegmentIndex
            .map { Reactor.Action.segmentChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // 2. 리셋 버튼 바인딩
        containerView.resetButton.rx.tap
            .map { Reactor.Action.resetFilters }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // 3. 저장 버튼 바인딩
        containerView.saveButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let selectedOptions = owner.reactor?.currentState.selectedSubRegions ?? []
                let selectedCategories = owner.reactor?.currentState.selectedCategories ?? []
                owner.savedLocation = selectedOptions.first
                owner.savedCategory = selectedCategories.first
                owner.onSave?(selectedOptions + selectedCategories)
                owner.hideBottomSheet()
            }
            .disposed(by: disposeBag)

        // 4. 닫기 버튼 바인딩
        containerView.closeButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.hideBottomSheet()
            }
            .disposed(by: disposeBag)

        // 5. 탭 변경
        reactor.state.map { $0.activeSegment }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind { [weak self] activeSegment in
                guard let self = self else { return }

                let isCategoryTab = activeSegment == 1  // Int와 Int 비교는 가능합니다

                UIView.animate(withDuration: 0.3) {
                    self.containerView.locationScrollView.isHidden = isCategoryTab
                    self.containerView.categoryCollectionView.isHidden = !isCategoryTab

                    if isCategoryTab {
                        self.containerView.updateBalloonHeight(isHidden: true)
                    } else {
                        let subRegionCount = self.reactor?.currentState.selectedSubRegions.count ?? 0
                        let dynamicHeight = CGFloat(80 + (subRegionCount / 3) * 40)
                        self.containerView.updateBalloonHeight(isHidden: false, dynamicHeight: dynamicHeight)
                    }
                    self.view.layoutIfNeeded()
                }
            }
            .disposed(by: disposeBag)

        // 6. 위치 데이터 바인딩
        // 강제업데이트 취소  수정
        let locations = reactor.state
            .map { $0.locations }
            .distinctUntilChanged()
            .share(replay: 1)
        locations
            .observe(on: MainScheduler.instance)
            .bind { [weak self] locations in
                // 컴플리션 핸들러 참고ㅜ
                self?.containerView.setupLocationScrollView(locations: locations) { index in
                    // 전체 버튼(index == 0) 클릭 시 처리
                    if index == 0 {
                        if let selectedSubRegions = self?.reactor?.currentState.selectedSubRegions,
                           !selectedSubRegions.isEmpty {
                            selectedSubRegions.forEach { region in
                                self?.reactor?.action.onNext(.toggleSubRegion(region))
                            }
                        }
                    }
                    self?.reactor?.action.onNext(.selectLocation(index))
                }
            }
            .disposed(by: disposeBag)

        let locationAndSubRegions = reactor.state
            .map { ($0.selectedLocationIndex, $0.selectedSubRegions) }
            .distinctUntilChanged { prev, curr in
                let isIndexSame = prev.0 == curr.0
                let isSubRegionsSame = prev.1 == curr.1
                return isIndexSame && isSubRegionsSame
            }
            .share(replay: 1)

        locationAndSubRegions
            .observe(on: MainScheduler.instance)
            .bind { [weak self] data in
                guard let self = self, let reactor = self.reactor else { return }
                let (selectedIndexOptional, selectedSubRegions) = data

                guard let selectedIndex = selectedIndexOptional,
                      selectedIndex >= 0,
                      selectedIndex < reactor.currentState.locations.count else { return }

                let location = reactor.currentState.locations[selectedIndex]

                self.containerView.balloonBackgroundView.configure(
                    with: location.sub,
                    selectedRegions: selectedSubRegions,
                    mainRegionTitle: location.main,
                    selectionHandler: { [weak self] subRegion in
                        self?.reactor?.action.onNext(.toggleSubRegion(subRegion))
                    },
                    allSelectionHandler: { [weak self] in
                        self?.reactor?.action.onNext(.toggleAllSubRegions)
                    }
                )

                if let button = self.containerView.locationContentView.subviews[selectedIndex] as? UIButton {
                    self.containerView.updateBalloonPosition(for: button)
                }

                self.containerView.balloonBackgroundView.isHidden = false
            }
            .disposed(by: disposeBag)

        Observable.combineLatest(
                  reactor.state.map { $0.categories }.distinctUntilChanged(),
                  reactor.state.map { $0.selectedCategories }.distinctUntilChanged()
              )
              .observe(on: MainScheduler.instance)
              .bind { [weak self] (categories, selectedCategories) in
                  self?.tagSection = TagSection(inputDataList: categories.map {
                      TagSectionCell.Input(
                          title: $0,
                          isSelected: selectedCategories.contains($0),
                          id: nil
                      )
                  })
                  self?.containerView.categoryCollectionView.reloadData()
              }
              .disposed(by: disposeBag)

        reactor.state.map { $0.selectedSubRegions + $0.selectedCategories }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind { [weak self] selectedOptions in
                self?.containerView.filterChipsView.updateChips(with: selectedOptions)
            }
            .disposed(by: disposeBag)

        reactor.state.map { $0.isSaveEnabled }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind { [weak self] isEnabled in
                guard let self = self else { return }
                if isEnabled {
                    self.containerView.saveButton.isEnabled = true
                    self.containerView.saveButton.backgroundColor = .blu500
                    self.containerView.saveButton.setTitleColor(.white, for: .normal)
                } else {
                    self.containerView.saveButton.isEnabled = false
                    self.containerView.saveButton.backgroundColor = .g100
                    self.containerView.saveButton.setTitleColor(.g400, for: .disabled)
                }
            }
            .disposed(by: disposeBag)
        print("Save Button isEnabled: \(self.containerView.saveButton.isEnabled)")
        print("Save Button Title Color (Normal): \(self.containerView.saveButton.titleColor(for: .normal)?.description ?? "nil")")
        print("Save Button Title Color (Disabled): \(self.containerView.saveButton.titleColor(for: .disabled)?.description ?? "nil")")

    }

    private func updateContentVisibility(_ isCategoryTab: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.containerView.locationScrollView.isHidden = isCategoryTab
            self.containerView.categoryCollectionView.isHidden = !isCategoryTab
            self.containerView.balloonBackgroundView.snp.remakeConstraints { make in
                make.top.equalTo(self.containerView.locationScrollView.snp.bottom).offset(16)
                make.leading.trailing.equalToSuperview().inset(16)
                make.height.equalTo(isCategoryTab ? 0 : 80) // 동적 높이 설정
            }

            self.view.layoutIfNeeded()
        }
    }

    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapDimmedView))
        dimmedView.addGestureRecognizer(tapGesture)
        dimmedView.isUserInteractionEnabled = true

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        containerView.addGestureRecognizer(panGesture)
    }

    func showBottomSheet() {
        containerView.update(locationText: savedLocation, categoryText: savedCategory)
        // (저장상태 기반 반영)
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            self.dimmedView.alpha = 1
            self.bottomConstraint?.update(offset: 0)
            self.view.layoutIfNeeded()
        }
    }

    func hideBottomSheet() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.dimmedView.alpha = 0
            self.bottomConstraint?.update(offset: UIScreen.main.bounds.height)
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: false)
            self.onDismiss?()
        }
    }

    @objc private func handleTapDimmedView() {
        hideBottomSheet()
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)

        switch gesture.state {
        case .changed:
            guard translation.y >= 0 else { return }
            bottomConstraint?.update(offset: translation.y)
            view.layoutIfNeeded()

        case .ended:
            let velocity = gesture.velocity(in: view)
            if translation.y > 150 || velocity.y > 1000 {
                hideBottomSheet()
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.bottomConstraint?.update(offset: 0)
                    self.view.layoutIfNeeded()
                }
            }

        default:
            break
        }
    }

}
extension FilterBottomSheetViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagSection?.inputDataList.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TagSectionCell.identifiers,
            for: indexPath
        ) as? TagSectionCell else {
            return UICollectionViewCell()
        }

        if let input = tagSection?.inputDataList[indexPath.item] {
            cell.injection(with: input)
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FilterBottomSheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let category = tagSection?.inputDataList[indexPath.item].title else { return }
        reactor?.action.onNext(.toggleCategory(category))
    }
}
