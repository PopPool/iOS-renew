//
//  MapReactor.swift
//  Poppool
//
//  Created by 김기현 on 12/3/24.
//
import Foundation
import ReactorKit
import RxSwift
import RxCocoa
import CoreLocation

final class MapReactor: Reactor {

    // MARK: - Reactor
    enum Action {
        case viewDidLoad
        case searchTapped
        case locationButtonTapped
        case listButtonTapped
        case filterLocationTapped
        case filterCategoryTapped
        case markerSelected(MapPopUpStore)
        case mapBoundsChanged(
            northEastLat: Double,
            northEastLon: Double,
            southWestLat: Double,
            southWestLon: Double
        )
    }

    enum Mutation {
        case setStores([MapPopUpStore])
        case setSelectedStore(MapPopUpStore?)
        case setCurrentLocation(CLLocationCoordinate2D)
        case showSearchView
        case showFilterLocation
        case showFilterCategory
        case showListView
        case setError(Error)
    }

    struct State {
        var stores: [MapPopUpStore] = []
        var selectedStore: MapPopUpStore?
        var currentLocation: CLLocationCoordinate2D?
        var isSearchViewPresented: Bool = false
        var isFilterLocationPresented: Bool = false
        var isFilterCategoryPresented: Bool = false
        var isListViewPresented: Bool = false
        var error: Error?
    }

    // MARK: - Properties
    let initialState: State
    private let useCase: MapUseCase
    private let selectedCategories: BehaviorRelay<[String]> = .init(value: [])

    // MARK: - Init
    init(useCase: MapUseCase) {
        self.useCase = useCase
        self.initialState = State()
    }

    // MARK: - Methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .empty()

        case let .mapBoundsChanged(northEastLat, northEastLon, southWestLat, southWestLon):
            return useCase.fetchStoresInBounds(
                northEastLat: northEastLat,
                northEastLon: northEastLon,
                southWestLat: southWestLat,
                southWestLon: southWestLon,
                categories: selectedCategories.value
            )
            .map { .setStores($0) }
            .catch { .just(.setError($0)) }

        case .searchTapped:
            return .just(.showSearchView)

        case .locationButtonTapped:
            let defaultLocation = CLLocationCoordinate2D(latitude: 37.5666, longitude: 126.9784)
            return .just(.setCurrentLocation(defaultLocation))

        case .listButtonTapped:
            return .just(.showListView)

        case .filterLocationTapped:
            return .just(.showFilterLocation)

        case .filterCategoryTapped:
            return .just(.showFilterCategory)

        case let .markerSelected(store):
            return .just(.setSelectedStore(store))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setStores(stores):
            newState.stores = stores

        case let .setSelectedStore(store):
            newState.selectedStore = store

        case let .setCurrentLocation(location):
            newState.currentLocation = location

        case .showSearchView:
            newState.isSearchViewPresented = true

        case .showFilterLocation:
            newState.isFilterLocationPresented = true

        case .showFilterCategory:
            newState.isFilterCategoryPresented = true

        case .showListView:
            newState.isListViewPresented = true

        case let .setError(error):
            newState.error = error
        }

        return newState
    }
}
