//
//  GetItemsDTO.swift
//  ReactorKitAsync
//
//  Created by 박창규 on 10/23/25.
//

import Foundation

public struct GetItemsDTO: Encodable, Sendable {
    let page: Int
    let perPage: Int
    let gender: String = "male"
    
    public init(page: Int, perPage: Int) {
        self.page = page
        self.perPage = perPage
    }
}
