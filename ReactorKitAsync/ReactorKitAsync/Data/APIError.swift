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
}
