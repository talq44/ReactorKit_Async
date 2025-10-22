import Foundation

public struct StubListRepository: ListRepository {
    public init() {}
    
    public func fetch() async throws(ListError) -> ListEntity {
        return ListEntity(
            items: Self.sampleItems(page: 1), totalPage: 3
        )
    }
    
    public func more(page: Int) async throws(ListError) -> ListEntity {
        guard page <= 3 else { throw .unknown }
        
        return ListEntity(
            items: Self.sampleItems(page: page), totalPage: 3
        )
    }
    
    private static func sampleItems(page: Int) -> [ListEntity.Item] {
        let start = (page - 1) * 10
        
        return Array(0..<10).map { index in
            return ListEntity.Item(
                id: "id_\(index)",
                title: "https://picsum.photos/id/\(index % 100)/200/200",
                subTitle: "Title \(index)",
                imageURL: "Subtitle \(index)",
                originPrice: Double(1000 + index * 10),
                discountPrice: (index % 3 == 0) ? Double(900 + index * 8) : nil
            )
        }
    }
}
