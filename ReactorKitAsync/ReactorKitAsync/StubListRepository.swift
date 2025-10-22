import Foundation

public struct StubListRepository: ListRepository {
    public init() {}
    
    public func fetch() async throws(ListError) -> ListEntity {
        do {
            try await Task.sleep(nanoseconds: 2_000_000_000)
            return ListEntity(
                items: Self.sampleItems(page: 1),
                totalPage: 3
            )
        } catch {
            throw .unknown
        }
    }
    
    public func more(page: Int) async throws(ListError) -> ListEntity {
        guard page <= 3 else { throw .unknown }
        
        return ListEntity(
            items: Self.sampleItems(page: page),
            totalPage: 3
        )
    }
    
    private static func sampleItems(page: Int) -> [ListEntity.Item] {
        let start = (page - 1) * 10
        
        return Array(0..<10).map { index in
            let uniqueIndex = start + index
            return ListEntity.Item(
                id: "id_\(uniqueIndex)",
                title: "https://picsum.photos/id/\(uniqueIndex % 100)/200/200",
                subTitle: "Title \(uniqueIndex)",
                imageURL: "Subtitle \(uniqueIndex)",
                originPrice: Double(1000 + uniqueIndex * 10),
                discountPrice: (uniqueIndex % 3 == 0) ? Double(900 + uniqueIndex * 8) : nil
            )
        }
    }
}
