import Foundation

extension Error {
    internal func apiError(statusCodeType: HTTPStatusCode?) -> APIError {
        do {
            throw self
        } catch let DecodingError.dataCorrupted(context) {
            let contexts = context.codingPath
                .map { $0.stringValue }
                .joined(separator: ",")
            
            printError("DataCorrupted", contexts)
            return APIError.serializationFailed
            
        } catch let DecodingError.keyNotFound(key, context) {
            let key = "KeyNotFound: " + key.stringValue
            let contexts = context.codingPath
                .map { $0.stringValue }
                .joined(separator: ",")
            
            printError(key, contexts)
            return APIError.serializationFailed
            
        } catch let DecodingError.valueNotFound(type, context) {
            let type = "ValueNotFound: " + String(describing: type)
            let contexts = context.codingPath
                .map { $0.stringValue }
                .joined(separator: ",")
            
            printError(type, contexts)
            return APIError.serializationFailed
            
        } catch let DecodingError.typeMismatch(type, context)  {
            let type = "TypeMismatch: " + String(describing: type)
            let contexts = context.codingPath
                .map { $0.stringValue }
                .joined(separator: ",")
            printError(type, contexts)
            return APIError.serializationFailed
            
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return APIError.networkNotConnect
            case .timedOut:
                return APIError.timeOut
            default:
                return APIError.unknown
            }
            
        } catch {
            guard let statusCodeType else {
                return APIError.unknown
            }
            
            return APIError.statusCode(statusCodeType.rawValue)
        }
    }
    
    private func printError(_ items: Any...) {
#if DEBUG
        print(items)
#endif
    }
}
