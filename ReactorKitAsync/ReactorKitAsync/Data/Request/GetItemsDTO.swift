//
//  GetItemsDTO.swift
//  ReactorKitAsync
//
//  Created by 박창규 on 10/23/25.
//

import Foundation

struct GetItemsDTO: Encodable, Sendable {
    let page: Int
    let perPage: Int
    let gender: String = "male"
}
