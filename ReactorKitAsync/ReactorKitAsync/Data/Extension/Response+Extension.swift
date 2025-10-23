import Foundation
import Moya

extension Response {
    private var statusCodeType: HTTPStatusCode? {
        return HTTPStatusCode(rawValue: self.statusCode)
    }
    
    internal func convertError(error: Error) -> APIError {
        guard let statusCode = statusCodeType else {
            return error.apiError(statusCodeType: nil)
        }
        
        guard statusCode.responseType != .success else {
            return error.apiError(statusCodeType: statusCode)
        }
        
        return APIError.statusCode(statusCode.rawValue)
    }
}
