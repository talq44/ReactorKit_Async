import Foundation

public protocol ListUseCase {
    func excute(page: Int) async throws(ListError) -> ListEntity
}
