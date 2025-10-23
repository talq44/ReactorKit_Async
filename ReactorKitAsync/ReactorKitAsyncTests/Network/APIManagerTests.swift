import Testing

@testable import ReactorKitAsync

struct APIManagerTests {
    @MainActor @Test("최초 요청 테스트") func apiRequestTest() async throws {
        let sut = APIManager()
        
        do {
            let response = try await sut.getItems(request: GetItemsDTO(page: 1, perPage: 20))
            #expect(response.results.count > 0)
            
        } catch {
            throw error
        }
    }
}
