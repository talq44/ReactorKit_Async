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
                title: "Title \(uniqueIndex)",
                subTitle: "Subtitle \(uniqueIndex)",
                imageURL: "https://picsum.photos/id/\(uniqueIndex % 100)/200/200",
                originPrice: Double.random(in: 0..<100_000_000),
                discountPrice: (uniqueIndex % 3 == 0) ? Double.random(in: 0..<100_000_000) : nil
            )
        }
    }
}
