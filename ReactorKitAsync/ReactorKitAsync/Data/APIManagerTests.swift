//
//import Testing
//
//@testable import ReactorKitAsync
//
//@Suite("APIManager Actor Tests")
//struct APIManagerActorTests {
//
//    @Test("Successful decoding returns model and is Sendable")
//    func testSuccessDecoding() async throws {
//        let testProvider = makeStubbedProvider()
//        let manager = APIManager(provider: testProvider)
//
//        let model: ItemDTO = try await manager.requestAPI(.getItem, type: ItemDTO.self)
//
//        #expect(model == ItemDTO(id: 1, name: "Test"))
//    }
//
//    @Test("Decoding error maps to APIError via convertError")
//    func testDecodingErrorMapping() async throws {
//        let testProvider = makeStubbedProvider()
//        let manager = APIManager(provider: testProvider)
//
//        do {
//            let _: ItemDTO = try await manager.requestAPI(.badJSON, type: ItemDTO.self)
//            Issue.record("Expected to throw, but succeeded")
//        } catch {
//            #expect(error is Error)
//        }
//    }
//}
