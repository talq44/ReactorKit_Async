import Foundation

final class ListRepositoryImpl: ListRepository {
    
    private let api: APIManager
    
    init(api: APIManager = APIManagerImpl()) {
        self.api = api
    }
    
    func fetch() async throws(ListError) -> ListEntity {
        do {
            let response = try await api.getItems(request: GetItemsDTO(page: 1, perPage: 10))
            
            return response.convertEntity
        } catch {
            guard let error = error as? APIError else {
                throw .unknown
            }
            
            throw .apiError(message: error.errorMessage)
        }
    }
    
    func more(page: Int) async throws(ListError) -> ListEntity {
        do {
            let response = try await api.getItems(request: GetItemsDTO(page: page, perPage: 10))
            
            return response.convertEntity
        } catch {
            guard let error = error as? APIError else {
                throw .unknown
            }
            
            throw .apiError(message: error.errorMessage)
        }
    }
}

extension ResponseDTO {
    fileprivate var convertEntity: ListEntity {
        return ListEntity(
            items: results.map({ dto in
                return ListEntity.Item(
                    id: "",
                    title: dto.name.title,
                    subTitle: nil,
                    imageURL: dto.picture.thumbnail,
                    originPrice: 0,
                    discountPrice: nil
                )
            }),
            totalPage: nil
        )
    }
}
