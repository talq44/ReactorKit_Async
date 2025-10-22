import Foundation
import ReactorKit
import RxSwift

enum ListViewAction {
    case refresh
    case more
    case selectItem(id: String)
}

enum ListViewMutation {
    case startLoading
    case setItems(page: Int, items: [ListViewState.Item])
    case addItems(page: Int, items: [ListViewState.Item])
    case setError(message: String)
}

struct ListViewState {
    struct Item: Equatable {
        let id: String
        let imageUrl: String
        let title: String
        let subTitle: String
        let price: Double
        let discountPrice: Double?
    }
    
    var isShowLoading: Bool = false
    var isShowEmpty: Bool = false
    var items: [ListViewState.Item] = []
    var errorMessage: String?
}

final class ListViewReactor: Reactor {
    typealias Action = ListViewAction
    typealias Mutation = ListViewMutation
    typealias State = ListViewState
    
    let initialState: ListViewState
    private var currentPage: Int = 0
    
    init() {
        initialState = .init()
    }
}

// MARK: - mutate
extension ListViewReactor {
    func mutate(action: ListViewAction) -> Observable<ListViewMutation> {
        switch action {
        case .refresh:
            return .concat([
                .just(.startLoading),
                requestItems(isMore: false, page: currentPage)
            ])
        case .more:
            return .concat([
                .just(.startLoading),
                requestItems(isMore: true, page: currentPage)
            ])
        case .selectItem(let id):
            guard let item = currentState.items.first(where: { $0.id == id }) else {
                return .empty()
            }
            
            return .empty()
        }
    }
}

// MARK: - Side Effect
extension ListViewReactor {
    private func requestItems(isMore: Bool, page: Int) -> Observable<ListViewMutation> {
        return Observable.create { emitter in
            let requestPage = isMore ? page + 1 : 1
            
            if isMore {
                emitter.onNext(.addItems(page: requestPage, items: []))
            } else {
                emitter.onNext(.setItems(page: requestPage, items: []))
            }
            
            emitter.onCompleted()
            
            return Disposables.create()
        }
    }
}

// MARK: - reduce
extension ListViewReactor {
    func reduce(state: ListViewState, mutation: ListViewMutation) -> ListViewState {
        var state = state
        
        switch mutation {
        case .startLoading:
            state.errorMessage = nil
            state.isShowLoading = true
            state.isShowEmpty = false
        case .setItems(let page, let items):
            currentPage = page
            state.isShowLoading = false
            state.items = items
            state.isShowEmpty = items.isEmpty
        case .addItems(let page, let items):
            currentPage = page
            state.isShowLoading = false
            state.items += items
        case .setError(let message):
            state.isShowLoading = false
            state.errorMessage = message
        }
        
        return state
    }
}
