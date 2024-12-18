import UIKit
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit
import PanModal

final class StoreListViewController: UIViewController, View {
    typealias Reactor = StoreListReactor

    // MARK: - Properties
    var disposeBag = DisposeBag()
    let mainView = StoreListView()

    // MARK: - Init
    init(reactor: StoreListReactor) {  // 리액터를 파라미터로 받도록 수정
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
    }

    private func setupLayout() {
        view.backgroundColor = .clear
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func bind(reactor: Reactor) {
        // 기존 바인딩 코드 유지
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.stores }
            .bind(to: mainView.collectionView.rx.items(
                cellIdentifier: StoreListCell.identifier,
                cellType: StoreListCell.self
            )) { _, item, cell in
                cell.injection(with: .init(
                    thumbnailImage: nil,
                    category: item.category,
                    title: item.title,
                    location: item.location,
                    date: item.dateRange,
                    isBookmarked: item.isBookmarked
                ))

                cell.bookmarkButton.rx.tap
                    .map { Reactor.Action.toggleBookmark(item.id) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)

        mainView.collectionView.rx.itemSelected
            .map { Reactor.Action.didSelectItem($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - PanModalPresentable
extension StoreListViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return mainView.collectionView
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(UIScreen.main.bounds.height * 0.6)
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(90)  // 검색창 + 필터 영역 height
    }

    var cornerRadius: CGFloat {
        return 20
    }

    var showDragIndicator: Bool {
        return false
    }

    var backgroundAlpha: CGFloat {
        return 0.0
    }
    var isHapticFeedbackEnabled: Bool {
          return false
      }

      var isDimEnabled: Bool {
          return false
      }


    func willTransition(to state: PanModalPresentationController.PresentationState) {
            switch state {
            case .longForm:
                mainView.backgroundColor = .white
                mainView.collectionView.backgroundColor = .white
            case .shortForm:
                mainView.backgroundColor = .clear
                mainView.collectionView.backgroundColor = .white
            }
        }
}
