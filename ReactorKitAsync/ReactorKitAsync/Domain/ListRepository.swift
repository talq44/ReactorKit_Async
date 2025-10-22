import Foundation

public protocol ListRepository: Sendable {
    func fetch() async throws(ListError) -> ListEntity
    func more(page: Int) async throws(ListError) -> ListEntity
}
