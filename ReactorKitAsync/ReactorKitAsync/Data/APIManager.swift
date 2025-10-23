import Foundation
import Alamofire
import Moya

class APIManager {
    private let provider: MoyaProvider<API>
    
    init() {
        var plugins: [PluginType] = []
        
#if DEBUG
        let config = NetworkLoggerPlugin.Configuration(logOptions: .default)
        plugins.append(NetworkLoggerPlugin(configuration: config))
#endif
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .useProtocolCachePolicy
        
        self.provider = MoyaProvider<API>(
            session: Session(configuration: configuration),
            plugins: plugins
        )
    }
    
    func requestAPI<T: Decodable>(_ target: API, type: T.Type) async throws -> T {
        guard NetworkReachabilityManager()?.isReachable == true else {
            throw APIError.networkNotConnect
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let model = try JSONDecoder().decode(
                            T.self,
                            from: response.data
                        )
                        
                        continuation.resume(returning: model)
                    } catch {
                        let convertError = response.convertError(error: error)
                        
                        continuation.resume(throwing: convertError)
                    }
                    
                case .failure(let error):
                    guard let converted = error.response?.convertError(error: error) else {
                        continuation.resume(throwing: APIError.unknown)
                        return
                    }
                    
                    continuation.resume(throwing: converted)
                }
            }
        }
    }
}
