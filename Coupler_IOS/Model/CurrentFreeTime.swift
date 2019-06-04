// To parse the JSON, add this file to your project and do:
//
//   let currentFreeTime = try CurrentFreeTime(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseCurrentFreeTime { response in
//     if let currentFreeTime = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class CurrentFreeTime: Codable {
    let id: JSONNull?
    let targetID, packageID, businessID: String?
    let price, begin, finish: Int?
    let description: String?
    let packageDto, business, statusPay, statusProcess: JSONNull?
    let statusRecord, serviceType: JSONNull?
    let services, servicesIDS: [JSONAny]?
    let workingSpaceID: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case targetID = "targetId"
        case packageID = "packageId"
        case businessID = "businessId"
        case price, begin, finish, description, packageDto, business, statusPay, statusProcess, statusRecord, serviceType, services
        case servicesIDS = "servicesIds"
        case workingSpaceID = "workingSpaceId"
    }
    
    init(id: JSONNull?, targetID: String?, packageID: String?, businessID: String?, price: Int?, begin: Int?, finish: Int?, description: String?, packageDto: JSONNull?, business: JSONNull?, statusPay: JSONNull?, statusProcess: JSONNull?, statusRecord: JSONNull?, serviceType: JSONNull?, services: [JSONAny]?, servicesIDS: [JSONAny]?, workingSpaceID: String?) {
        self.id = id
        self.targetID = targetID
        self.packageID = packageID
        self.businessID = businessID
        self.price = price
        self.begin = begin
        self.finish = finish
        self.description = description
        self.packageDto = packageDto
        self.business = business
        self.statusPay = statusPay
        self.statusProcess = statusProcess
        self.statusRecord = statusRecord
        self.serviceType = serviceType
        self.services = services
        self.servicesIDS = servicesIDS
        self.workingSpaceID = workingSpaceID
    }
}

// MARK: Convenience initializers and mutators

extension CurrentFreeTime {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(CurrentFreeTime.self, from: data)
        self.init(id: me.id, targetID: me.targetID, packageID: me.packageID, businessID: me.businessID, price: me.price, begin: me.begin, finish: me.finish, description: me.description, packageDto: me.packageDto, business: me.business, statusPay: me.statusPay, statusProcess: me.statusProcess, statusRecord: me.statusRecord, serviceType: me.serviceType, services: me.services, servicesIDS: me.servicesIDS, workingSpaceID: me.workingSpaceID)
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
        id: JSONNull?,
        targetID: String?,
        packageID: String?,
        businessID: String?,
        price: Int?,
        begin: Int?,
        finish: Int?,
        description: String?,
        packageDto: JSONNull?,
        business: JSONNull?,
        statusPay: JSONNull?,
        statusProcess: JSONNull?,
        statusRecord: JSONNull?,
        serviceType: JSONNull?,
        services: [JSONAny]?,
        servicesIDS: [JSONAny]?,
        workingSpaceID: String?
        ) -> CurrentFreeTime {
        return CurrentFreeTime(
            id: id ?? self.id,
            targetID: targetID ?? self.targetID,
            packageID: packageID ?? self.packageID,
            businessID: businessID ?? self.businessID,
            price: price ?? self.price,
            begin: begin ?? self.begin,
            finish: finish ?? self.finish,
            description: description ?? self.description,
            packageDto: packageDto ?? self.packageDto,
            business: business ?? self.business,
            statusPay: statusPay ?? self.statusPay,
            statusProcess: statusProcess ?? self.statusProcess,
            statusRecord: statusRecord ?? self.statusRecord,
            serviceType: serviceType ?? self.serviceType,
            services: services ?? self.services,
            servicesIDS: servicesIDS ?? self.servicesIDS,
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
    func responseCurrentFreeTime(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<CurrentFreeTime>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
