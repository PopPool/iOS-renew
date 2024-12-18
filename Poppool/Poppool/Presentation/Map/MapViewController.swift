import UIKit
import PanModal
import SnapKit
import RxSwift
import RxCocoa
import ReactorKit
import GoogleMaps

final class MapViewController: BaseViewController, View {
    typealias Reactor = MapReactor

    var disposeBag = DisposeBag()
    let mainView = MapView()

    private var currentFilterBottomSheet: FilterBottomSheetViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    private func setUp() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview() 
        }

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 37.5666, longitude: 126.9784)

        let markerView = MapMarker()
        markerView.injection(with: .init(title: "서울", count: 3))
        marker.iconView = markerView
        marker.map = mainView.mapView
        markerView.frame = CGRect(x: 0, y: 0, width: 80, height: 28)
    }


    func bind(reactor: Reactor) {
        // 지역 필터 버튼 탭 이벤트
        mainView.filterChips.locationChip.rx.tap
            .map { Reactor.Action.filterTapped(.location) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // 카테고리 필터 버튼 탭 이벤트
        mainView.filterChips.categoryChip.rx.tap
            .map { Reactor.Action.filterTapped(.category) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.filterChips.onRemoveLocation = { [weak self] in
                self?.reactor?.action.onNext(.filterUpdated(.location, []))            }

            mainView.filterChips.onRemoveCategory = { [weak self] in
                self?.reactor?.action.onNext(.filterUpdated(.category, []))
            }

        mainView.listButton.rx.tap
            .bind { [weak self] _ in
                let reactor = StoreListReactor()
                let viewController = StoreListViewController(reactor: reactor)
                self?.presentPanModal(viewController)
            }
            .disposed(by: disposeBag)


        // 필터 바텀시트 표시 및 해제
        reactor.state.map { $0.activeFilterType }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] filterType in
                guard let self = self else { return }
                if let filterType = filterType {
                    self.presentFilterBottomSheet(for: filterType)
                } else {
                    self.dismissFilterBottomSheet()
                }
            })
            .disposed(by: disposeBag)
 // REactor fix
        Observable.combineLatest(
            reactor.state.map { $0.selectedLocationFilters }.distinctUntilChanged(),
            reactor.state.map { $0.selectedCategoryFilters }.distinctUntilChanged()
        )
        .observe(on: MainScheduler.instance)
        .bind { [weak self] (locationFilters: [String], categoryFilters: [String]) in
            guard let self = self else { return }
            let locationText = locationFilters.isEmpty
                ? "지역선택"
                : (locationFilters.count > 1 ? "\(locationFilters[0]) 외 \(locationFilters.count - 1)개" : locationFilters[0])

            let categoryText = categoryFilters.isEmpty
                ? "카테고리"
                : (categoryFilters.count > 1 ? "\(categoryFilters[0]) 외 \(categoryFilters.count - 1)개" : categoryFilters[0])

            self.mainView.filterChips.update(locationText: locationText, categoryText: categoryText)
        }
        .disposed(by: disposeBag)
    }


    func presentFilterBottomSheet(for filterType: FilterType) {
        let reactor = FilterBottomSheetReactor()
        let viewController = FilterBottomSheetViewController(reactor: reactor)

        let initialIndex = filterType == .location ? 0 : 1
        viewController.containerView.segmentedControl.selectedSegmentIndex = initialIndex
        reactor.action.onNext(.segmentChanged(initialIndex))
        
        let locationText = reactor.currentState.selectedSubRegions.first
        let categoryText = reactor.currentState.selectedCategories.first
        viewController.containerView.update(locationText: nil, categoryText: nil)

        viewController.onSave = { [weak self] selectedOptions in
            self?.reactor?.action.onNext(.filterUpdated(filterType, selectedOptions))
            self?.reactor?.action.onNext(.filterTapped(nil))
        }

        viewController.onDismiss = { [weak self] in
            self?.reactor?.action.onNext(.filterTapped(nil))
        }

        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false) {
            viewController.showBottomSheet()
        }

        currentFilterBottomSheet = viewController
    }


    private func dismissFilterBottomSheet() {
        if let bottomSheet = currentFilterBottomSheet {
            bottomSheet.hideBottomSheet()
        }
        currentFilterBottomSheet = nil
    }
}
