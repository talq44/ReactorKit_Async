//
//  APIError.swift
//  ReactorKitAsync
//
//  Created by 박창규 on 10/23/25.
//

import Foundation

enum APIError: Error, Sendable {
    case statusCode(Int)
    case serializationFailed
    case networkNotConnect
    case timeOut
    case unknown
    
    var errorMessage: String {
        switch self {
        case .statusCode(let int):
            return "\(int)가 발생했습니다."
        case .serializationFailed:
            return localizedDescription
        case .networkNotConnect:
            return localizedDescription
        case .timeOut:
            return localizedDescription
        case .unknown:
            return "알수없는 에러가 발생했습니다."
        }
    }
}
