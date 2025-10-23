//
//  APIManagerImpl+Extension.swift
//  ReactorKitAsync
//
//  Created by 박창규 on 10/23/25.
//

import Foundation

extension APIManagerImpl: APIManager {
    func getItems(
        request: GetItemsDTO
    ) async throws -> ResponseDTO {
        return try await requestAPI(
            .getItems(request: request),
            type: ResponseDTO.self
        )
    }
}

