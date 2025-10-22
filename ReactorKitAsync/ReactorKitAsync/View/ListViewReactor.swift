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
    case setItems(page: Int, totalPage: Int?, items: [ListViewState.Item])
    case addItems(page: Int, totalPage: Int?, items: [ListViewState.Item])
    case setError(message: String)
}

struct ListViewState {
    struct Item: Equatable {
        let id: String
        let imageUrl: String
        let title: String
        let subTitle: String?
        let price: Double
        let discountPrice: Double?
    }
    
    var isShowLoading: Bool = false
    var isShowEmpty: Bool = false
    var items: [ListViewState.Item] = []
    var errorMessage: String?
    
    var currentPage: Int = 0
    var totalPage: Int = 1
}

final class ListViewReactor: Reactor {
    typealias Action = ListViewAction
    typealias Mutation = ListViewMutation
    typealias State = ListViewState
    
    let initialState: ListViewState
    
    private let useCase: ListUseCase
    
    init(useCase: ListUseCase) {
        initialState = .init()
        self.useCase = useCase
    }
}

// MARK: - mutate
extension ListViewReactor {
    func mutate(action: ListViewAction) -> Observable<ListViewMutation> {
        switch action {
        case .refresh:
            return .concat([
                .just(.startLoading),
                requestItems(useCase: useCase, isMore: false, page: currentState.currentPage)
            ])
        case .more:
            guard currentState.currentPage < currentState.totalPage else {
                return .empty()
            }
            
            return .concat([
                .just(.startLoading),
                requestItems(useCase: useCase, isMore: true, page: currentState.currentPage)
            ])
        case .selectItem(let id):
            guard let _ = currentState.items.first(where: { $0.id == id }) else {
                return .empty()
            }
            
            return .empty()
        }
    }
}

// MARK: - Side Effect
extension ListViewReactor {
    private func requestItems(
        useCase: ListUseCase,
        isMore: Bool,
        page: Int
    ) -> Observable<ListViewMutation> {
        return Observable.create { emitter in
            let requestPage = isMore ? page + 1 : 1
            
            let tast = Task { @MainActor in
                do {
                    let result = try await useCase.execute(page: requestPage)
                    
                    if isMore {
                        emitter.onNext(.addItems(
                            page: requestPage,
                            totalPage: result.totalPage,
                            items: result.convertItems
                        ))
                    } else {
                        emitter.onNext(.setItems(
                            page: requestPage,
                            totalPage: result.totalPage,
                            items: result.convertItems
                        ))
                    }
                }
                catch {
                    emitter.onNext(.setError(message: error.localizedDescription))
                }
                
                emitter.onCompleted()
            }
            
            return Disposables.create { tast.cancel() }
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
        case .setItems(let page, let totalPage, let items):
            state.currentPage = page
            state.isShowLoading = false
            state.items = items
            state.isShowEmpty = items.isEmpty
            
            if let totalPage {
                state.totalPage = totalPage
            }
        case .addItems(let page, let totalPage, let items):
            state.currentPage = page
            state.isShowLoading = false
            state.items += items
            
            if let totalPage {
                state.totalPage = totalPage
            }
        case .setError(let message):
            state.isShowLoading = false
            state.errorMessage = message
        }
        
        return state
    }
}

extension ListEntity {
    fileprivate var convertItems: [ListViewState.Item] {
        return items.map { item in
            return ListViewState.Item(
                id: item.id,
                imageUrl: item.imageURL,
                title: item.title,
                subTitle: item.subTitle,
                price: item.originPrice,
                discountPrice: item.discountPrice
            )
        }
    }
}
