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
    let statusPay: String?
    let packageID: String?
    let business: String?
    let notificationSend: Bool?
    let workerID: String?
    let targetID, payType: String?
    let specifiedWorkingSpace: Bool?
    let client: String?
    let businessID: String?
    let statusProcess, packageDto, statusRecord, id: String?
    let begin: Int?
    let services: [JSONAny]?
    let finish: Int?
    let workingSpaceID: String?
    let businessCategoryID, clientID, canceledDescription: String?
    let price: Int?
    let recordNumber: String?
    let servicesIDS: [String]?
    let currentFreeTimeDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case statusPay
        case packageID = "packageId"
        case business, notificationSend
        case workerID = "workerId"
        case targetID = "targetId"
        case payType, specifiedWorkingSpace, client
        case businessID = "businessId"
        case statusProcess, packageDto, statusRecord, id, begin, services, finish
        case workingSpaceID = "workingSpaceId"
        case businessCategoryID = "businessCategoryId"
        case clientID = "clientId"
        case canceledDescription, price, recordNumber
        case servicesIDS = "servicesIds"
        case currentFreeTimeDescription = "description"
    }
    
    init(statusPay: String?, packageID: String?, business: String?, notificationSend: Bool?, workerID: String?, targetID: String?, payType: String?, specifiedWorkingSpace: Bool?, client: String?, businessID: String?, statusProcess: String?, packageDto: String?, statusRecord: String?, id: String?, begin: Int?, services: [JSONAny]?, finish: Int?, workingSpaceID: String?, businessCategoryID: String?, clientID: String?, canceledDescription: String?, price: Int?, recordNumber: String?, servicesIDS: [String]?, currentFreeTimeDescription: String?) {
        self.statusPay = statusPay
        self.packageID = packageID
        self.business = business
        self.notificationSend = notificationSend
        self.workerID = workerID
        self.targetID = targetID
        self.payType = payType
        self.specifiedWorkingSpace = specifiedWorkingSpace
        self.client = client
        self.businessID = businessID
        self.statusProcess = statusProcess
        self.packageDto = packageDto
        self.statusRecord = statusRecord
        self.id = id
        self.begin = begin
        self.services = services
        self.finish = finish
        self.workingSpaceID = workingSpaceID
        self.businessCategoryID = businessCategoryID
        self.clientID = clientID
        self.canceledDescription = canceledDescription
        self.price = price
        self.recordNumber = recordNumber
        self.servicesIDS = servicesIDS
        self.currentFreeTimeDescription = currentFreeTimeDescription
    }
}

// MARK: CurrentFreeTime convenience initializers and mutators

extension CurrentFreeTime {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(CurrentFreeTime.self, from: data)
        self.init(statusPay: me.statusPay, packageID: me.packageID, business: me.business, notificationSend: me.notificationSend, workerID: me.workerID, targetID: me.targetID, payType: me.payType, specifiedWorkingSpace: me.specifiedWorkingSpace, client: me.client, businessID: me.businessID, statusProcess: me.statusProcess, packageDto: me.packageDto, statusRecord: me.statusRecord, id: me.id, begin: me.begin, services: me.services, finish: me.finish, workingSpaceID: me.workingSpaceID, businessCategoryID: me.businessCategoryID, clientID: me.clientID, canceledDescription: me.canceledDescription, price: me.price, recordNumber: me.recordNumber, servicesIDS: me.servicesIDS, currentFreeTimeDescription: me.currentFreeTimeDescription)
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
        statusPay: String?? = nil,
        packageID: String?? = nil,
        business: String?? = nil,
        notificationSend: Bool?? = nil,
        workerID: String?? = nil,
        targetID: String?? = nil,
        payType: String?? = nil,
        specifiedWorkingSpace: Bool?? = nil,
        client: String?? = nil,
        businessID: String?? = nil,
        statusProcess: String?? = nil,
        packageDto: String?? = nil,
        statusRecord: String?? = nil,
        id: String?? = nil,
        begin: Int?? = nil,
        services: [JSONAny]?? = nil,
        finish: Int?? = nil,
        workingSpaceID: String?? = nil,
        businessCategoryID: String?? = nil,
        clientID: String?? = nil,
        canceledDescription: String?? = nil,
        price: Int?? = nil,
        recordNumber: String?? = nil,
        servicesIDS: [String]?? = nil,
        currentFreeTimeDescription: String?? = nil
        ) -> CurrentFreeTime {
        return CurrentFreeTime(
            statusPay: statusPay ?? self.statusPay,
            packageID: packageID ?? self.packageID,
            business: business ?? self.business,
            notificationSend: notificationSend ?? self.notificationSend,
            workerID: workerID ?? self.workerID,
            targetID: targetID ?? self.targetID,
            payType: payType ?? self.payType,
            specifiedWorkingSpace: specifiedWorkingSpace ?? self.specifiedWorkingSpace,
            client: client ?? self.client,
            businessID: businessID ?? self.businessID,
            statusProcess: statusProcess ?? self.statusProcess,
            packageDto: packageDto ?? self.packageDto,
            statusRecord: statusRecord ?? self.statusRecord,
            id: id ?? self.id,
            begin: begin ?? self.begin,
            services: services ?? self.services,
            finish: finish ?? self.finish,
            workingSpaceID: workingSpaceID ?? self.workingSpaceID,
            businessCategoryID: businessCategoryID ?? self.businessCategoryID,
            clientID: clientID ?? self.clientID,
            canceledDescription: canceledDescription ?? self.canceledDescription,
            price: price ?? self.price,
            recordNumber: recordNumber ?? self.recordNumber,
            servicesIDS: servicesIDS ?? self.servicesIDS,
            currentFreeTimeDescription: currentFreeTimeDescription ?? self.currentFreeTimeDescription
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
