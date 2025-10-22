import Foundation

public protocol ListUsecase {
    func excute(page: Int) async throws(ListUsecaseError) -> ListEntity
}
