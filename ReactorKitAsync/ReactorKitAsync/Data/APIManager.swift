import Foundation

public protocol APIManager {
    func getItems(
        request: GetItemsDTO
    ) async throws -> ResponseDTO
}
