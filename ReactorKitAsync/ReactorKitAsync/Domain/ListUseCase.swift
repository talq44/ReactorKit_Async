import Foundation

public protocol ListUseCase {
    func execute(page: Int) async throws(ListError) -> ListEntity
}
