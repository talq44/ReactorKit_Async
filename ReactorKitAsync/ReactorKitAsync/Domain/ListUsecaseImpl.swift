import Foundation

final actor ListUsecaseImpl: ListUsecase {
    
    private let repository: ListRepository
    
    init(repository: ListRepository) {
        self.repository = repository
    }
    
    func excute(page: Int) async throws(ListUsecaseError) -> ListEntity {
        guard page > 1 else {
            return try await repository.fetch()
        }
        
        return try await repository.more(page: page)
    }
}
