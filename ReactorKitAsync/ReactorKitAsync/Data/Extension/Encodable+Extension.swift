import Foundation

extension Encodable {
    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    var jsonString: String {
        guard let data = jsonData else { return "" }
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    var parameters: [String: Any] {
        guard let data = self.jsonData else { return [:] }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return [:] }
        guard let dic = json as? [String: Any] else { return [:] }
        
        return dic
    }
}
