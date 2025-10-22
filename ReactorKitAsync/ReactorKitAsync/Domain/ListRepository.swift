import Foundation

public protocol ListRepository: Sendable {
    func fetch() async throws(ListUsecaseError) -> ListEntity
    func more(page: Int) async throws(ListUsecaseError) -> ListEntity
}
