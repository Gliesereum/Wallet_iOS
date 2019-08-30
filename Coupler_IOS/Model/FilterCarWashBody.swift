// To parse the JSON, add this file to your project and do:
//
//   let filterCarWashBody = try FilterCarWashBody(json)

import Foundation

class FilterCarWashBody: Codable {
    let serviceIDS: [String]?
    let targetID, businessCategoryID, fullTextQuery: String?
    
    enum CodingKeys: String, CodingKey {
        case serviceIDS = "serviceIds"
        case targetID = "targetId"
        case businessCategoryID = "businessCategoryId"
        case fullTextQuery
    }
    
    init(serviceIDS: [String]?, targetID: String?, businessCategoryID: String?, fullTextQuery: String?) {
        self.serviceIDS = serviceIDS
        self.targetID = targetID
        self.businessCategoryID = businessCategoryID
        self.fullTextQuery = fullTextQuery
    }
}

// MARK: Convenience initializers and mutators

extension FilterCarWashBody {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(FilterCarWashBody.self, from: data)
        self.init(serviceIDS: me.serviceIDS, targetID: me.targetID, businessCategoryID: me.businessCategoryID, fullTextQuery: me.fullTextQuery)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        serviceIDS: [String]?? = nil,
        targetID: String?? = nil,
        businessCategoryID: String?? = nil,
        fullTextQuery: String?? = nil
        ) -> FilterCarWashBody {
        return FilterCarWashBody(
            serviceIDS: serviceIDS ?? self.serviceIDS,
            targetID: targetID ?? self.targetID,
            businessCategoryID: businessCategoryID ?? self.businessCategoryID,
            fullTextQuery: fullTextQuery ?? self.fullTextQuery
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
