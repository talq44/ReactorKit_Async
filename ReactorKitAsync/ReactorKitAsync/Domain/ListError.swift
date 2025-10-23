import Foundation

public enum ListError: Error {
    case apiError(message: String)
    case unknown
}
