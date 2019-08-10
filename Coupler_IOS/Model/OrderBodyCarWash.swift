// To parse the JSON, add this file to your project and do:
//
//   let orderBodyCarWash = try OrderBodyCarWash(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseOrderBodyCarWash { response in
//     if let orderBodyCarWash = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class OrderBodyCarWash: Codable {
    var begin: Int?
    var businessID, description, packageID, workerId: String?
    var servicesIDS: [String]?
    var targetID: String?
    let workingSpaceID: String?

    enum CodingKeys: String, CodingKey {
        case begin
        case workerId
        case businessID = "businessId"
        case description
        case packageID = "packageId"
        case servicesIDS = "servicesIds"
        case targetID = "targetId"
        case workingSpaceID = "workingSpaceId"
    }
    
    init(begin: Int?, businessID: String?, workerId: String?, description: String?, packageID: String?, servicesIDS: [String]?, targetID: String?, workingSpaceID: String?) {
        self.begin = begin
        self.businessID = businessID
        self.workerId = workerId
        self.description = description
        self.packageID = packageID
        self.servicesIDS = servicesIDS
        self.targetID = targetID
        self.workingSpaceID = workingSpaceID
    }
}

// MARK: Convenience initializers and mutators

extension OrderBodyCarWash {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(OrderBodyCarWash.self, from: data)
        self.init(begin: me.begin, businessID: me.businessID, workerId: me.workerId, description: me.description, packageID: me.packageID, servicesIDS: me.servicesIDS, targetID: me.targetID, workingSpaceID: me.workingSpaceID)
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
        begin: Int?,
        businessID: String?,
        workerId: String?,
        description: String?,
        packageID: String?,
        servicesIDS: [String]?,
        targetID: String?,
        workingSpaceID: String?
        ) -> OrderBodyCarWash {
        return OrderBodyCarWash(
            begin: begin ?? self.begin,
            businessID: businessID ?? self.businessID,
            workerId: workerId ?? self.workerId,
            description: description ?? self.description,
            packageID: packageID ?? self.packageID,
            servicesIDS: servicesIDS ?? self.servicesIDS,
            targetID: targetID ?? self.targetID,
            workingSpaceID: workingSpaceID ?? self.workingSpaceID
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Alamofire response handlers

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try newJSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseOrderBodyCarWash(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<OrderBodyCarWash>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
