import Foundation

public struct ListEntity {
    public struct Item {
        public let id: String
        public let title: String
        public let subTitle: String?
        public let imageURL: String
        public let originPrice: Double
        public let discountPrice: Double?
    }
    
    public let items: [Item]
    public let totalPage: Int?
}
