import Foundation

extension Error {
    internal func apiError(
        statusCodeType: HTTPStatusCode?,
        message: String?
    ) -> APIError {
        do {
            throw self
        } catch let DecodingError.dataCorrupted(context) {
            let contexts = context.codingPath
                .map { $0.stringValue }
                .joined(separator: ",")
            
            print("DataCorrupted", contexts)
            return APIError.serializationFailed
            
        } catch let DecodingError.keyNotFound(key, context) {
            let key = "KeyNotFound: " + key.stringValue
            let contexts = context.codingPath
                .map { $0.stringValue }
                .joined(separator: ",")
            
            print(key, contexts)
            return APIError.serializationFailed
            
        } catch let DecodingError.valueNotFound(type, context) {
            let type = "ValueNotFound: " + String(describing: type)
            let contexts = context.codingPath
                .map { $0.stringValue }
                .joined(separator: ",")
            
            print(type, contexts)
            return APIError.serializationFailed
            
        } catch let DecodingError.typeMismatch(type, context)  {
            let type = "TypeMismatch: " + String(describing: type)
            let contexts = context.codingPath
                .map { $0.stringValue }
                .joined(separator: ",")
            print(type, contexts)
            return APIError.serializationFailed
        } catch {
            guard let statusCodeType else {
                return APIError.unknown
            }
            
            return APIError.statusCode(statusCodeType.rawValue)
        }
    }
}
