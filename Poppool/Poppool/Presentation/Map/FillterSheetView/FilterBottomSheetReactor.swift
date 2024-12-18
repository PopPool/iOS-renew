import ReactorKit
import RxSwift

struct Location: Equatable {
    let main: String
    let sub: [String]
}

final class FilterBottomSheetReactor: Reactor {
    enum Action {
        case segmentChanged(Int)
        case resetFilters
        case applyFilters([String])
        case selectLocation(Int)
        case toggleSubRegion(String)
        case toggleCategory(String)
        case toggleAllSubRegions

    }
    enum Mutation {
        case setActiveSegment(Int)
        case resetFilters
        case applyFilters([String])
        case updateSelectedLocation(Int)
        case updateSubRegions([String])
        case toggleSubRegionSelection(String)
        case toggleCategorySelection(String)
        case toggleAllSubRegions

    }
    struct State {
        var activeSegment: Int
        var selectedLocationIndex: Int?
        var selectedSubRegions: [String]
        var selectedCategories: [String]
        var locations: [Location]
        var categories: [String]
        var isSaveEnabled: Bool {
            return !selectedSubRegions.isEmpty || !selectedCategories.isEmpty
        }

    }
    
    let initialState: State
    
    init() {
        self.initialState = State(
            activeSegment: 0,
            selectedLocationIndex: nil,
            selectedSubRegions: [],
            selectedCategories: [],
            locations: [
                Location(main: "서울", sub: [
                    "강남/역삼/선릉", "건대/군자/구의", "강북/목동/신촌",
                    "명동/을지로/종로", "방이", "복촌/삼정",
                    "상수/대치", "상수/현정/광원"
                ]),
                Location(main: "경기", sub: ["수원시", "성남시", "용인시"]),
                Location(main: "인천", sub: ["부평", "송도"]),
                Location(main: "부산", sub: [
                    "해운대", "광안리", "사상구",
                    "사하구", "북구", "남구"
                ]),
                Location(main: "제주", sub: ["제주시", "서귀포시"]),
                Location(main: "광주", sub: ["동구", "서구", "남구", "북구", "광산구"])
            ],
            categories: [
                "게임", "라이프스타일", "반려동물", "뷰티",
                "스포츠", "애니메이션", "엔터테이먼트",
                "여행","예술","음식/요리","키즈",
                "패션"
            ]
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .segmentChanged(let index):
            return Observable.just(.setActiveSegment(index))

        case .resetFilters:
            return Observable.just(.resetFilters)

        case .applyFilters:
            let selectedOptions = currentState.selectedSubRegions + currentState.selectedCategories
            return Observable.just(.applyFilters(selectedOptions))

        case .selectLocation(let index):
            print("Select Location Index: \(index)")
            return Observable.just(.updateSelectedLocation(index))

        case .toggleCategory(let category):
            return Observable.just(.toggleCategorySelection(category)) // Mutation 반환

        case .toggleSubRegion(let subRegion):
            return Observable.just(.toggleSubRegionSelection(subRegion)) // Mutation 반환

        case .toggleAllSubRegions:
            return Observable.just(.toggleAllSubRegions)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setActiveSegment(let index):
            newState.activeSegment = index
            
        case .resetFilters:
            newState.selectedLocationIndex = nil
            newState.selectedSubRegions = []
            newState.selectedCategories = []
            
        case .applyFilters(let selectedOptions):
            print("필터 적용: \(newState.selectedSubRegions + newState.selectedCategories)")

        case .updateSelectedLocation(let index):
            newState.selectedLocationIndex = index

        case .updateSubRegions(let subRegions):
            print("서브지역 업: \(subRegions)")

        case .toggleSubRegionSelection(let subRegion):
            if newState.selectedSubRegions.contains(subRegion) {
                newState.selectedSubRegions.removeAll { $0 == subRegion }
            } else {
                newState.selectedSubRegions.append(subRegion)
            }
            
        case .toggleCategorySelection(let category):
            if newState.selectedCategories.contains(category) {
                newState.selectedCategories.removeAll { $0 == category }
            } else {
                newState.selectedCategories.append(category)
            }

        case .toggleAllSubRegions:
            if let index = newState.selectedLocationIndex {
                let allSubRegions = newState.locations[index].sub
                if Set(newState.selectedSubRegions) == Set(allSubRegions) {
                    newState.selectedSubRegions.removeAll()
                } else {
                    newState.selectedSubRegions = allSubRegions
                }
            }

        }
        
        return newState
    }
}
