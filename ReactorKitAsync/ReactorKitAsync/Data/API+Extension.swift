import Foundation
import Moya
import Alamofire

extension API: Moya.TargetType {
    var baseURL: URL {
        return URL(string: Constants.baseURL)!
    }
    
    var task: Moya.Task {
        switch self {
        case .getItems(let request):
            return .requestParameters(
                parameters: request.parameters,
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getItems:
            return [:]
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getItems:
            return .get
        }
    }
    
    var header: [String: String]? {
        switch self {
        case .getItems:
            return [:]
        }
    }
    
    var path: String {
        switch self {
        case .getItems:
            return ""
        }
    }
}
