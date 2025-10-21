import Foundation

public protocol ListUsecase {
    func excute(page: Int) async throws(ListError) -> [ListItem]
}

public struct ListItem {
    public let id: String
    public let name: String
    public let type: ListType?
    public let imageUrl: String
    public let price: Double
    public let discountPrice: Double?
}

public enum ListType {
    case product
}

public enum ListError: Error {
    case unknown
}
