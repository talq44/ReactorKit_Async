import Foundation

internal final actor ListUsecaseImpl: ListUsecase {
    func excute(page: Int) async throws(ListError) -> [ListItem] {
        return []
    }
}
