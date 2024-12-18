import ReactorKit
import RxSwift
import CoreLocation

final class MapReactor: Reactor {
    enum Action {
        case viewDidLoad
        case searchTapped
        case locationButtonTapped
        case listButtonTapped
        case filterTapped(FilterType?) 
        case filterUpdated(FilterType, [String])
    }

    enum Mutation {
        case setActiveFilter(FilterType?)
        case setLocationFilters([String])
        case setCategoryFilters([String])
    }

    struct State {
        var activeFilterType: FilterType?
        var selectedLocationFilters: [String] = []
        var selectedCategoryFilters: [String] = []
    }

    let initialState: State
    private let useCase: MapUseCase

    init(useCase: MapUseCase) {
        self.useCase = useCase
        self.initialState = State()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .filterTapped(filterType):
            return .just(.setActiveFilter(filterType))
        case let .filterUpdated(type, values):
            switch type {
            case .location:
                return .just(.setLocationFilters(values))
            case .category:
                return .just(.setCategoryFilters(values))
            }
        default:
            return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setActiveFilter(filterType):
            newState.activeFilterType = filterType
        case let .setLocationFilters(filters):
            newState.selectedLocationFilters = filters
        case let .setCategoryFilters(filters):
            newState.selectedCategoryFilters = filters
        }
        return newState
    }
}

enum FilterType {
    case location
    case category
}
