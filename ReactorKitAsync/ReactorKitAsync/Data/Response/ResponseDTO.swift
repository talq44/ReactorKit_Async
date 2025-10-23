import Foundation

public struct ResponseDTO: Codable {
    public let results: [ResultDTO]
}

public struct ResultDTO: Codable {
    public let gender: String
    public let name: Name
    public let email: String
    public let phone: String
    public let cell: String
    public let picture: Picture
    public let nat: String
}

public struct Name: Codable {
    public let title: String
    public let first: String
    public let last: String
}

public struct Picture: Codable {
    public let large: String
    public let medium: String
    public let thumbnail: String
}
