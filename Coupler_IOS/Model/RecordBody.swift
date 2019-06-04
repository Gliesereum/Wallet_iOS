// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let recordsBody = try RecordsBody(json)

import Foundation

// MARK: - RecordsBodyElement
class RecordsBodyElement: Codable {
    let id, clientID, targetID: String?
    let packageID: String?
    let businessID: String?
    let price, begin, finish: Int?
    let recordsBodyDescription: String?
    let packageDto: PackageDto?
    let business: Business?
    let statusPay: String?
    let payType: String?
    let statusProcess: String?
    let statusRecord: String?
    let businessCategoryID: String?
    let notificationSend: Bool?
    let services: [ServiceElement]?
    let servicesIDS: [JSONAny]?
    let workingSpaceID: String?
    let workerID: String?
    let client: JSONNull?
    
    enum CodingKeys: String, CodingKey {
        case id
        case clientID = "clientId"
        case targetID = "targetId"
        case packageID = "packageId"
        case businessID = "businessId"
        case price, begin, finish
        case recordsBodyDescription = "description"
        case packageDto, business, statusPay, payType, statusProcess, statusRecord
        case businessCategoryID = "businessCategoryId"
        case notificationSend, services
        case servicesIDS = "servicesIds"
        case workingSpaceID = "workingSpaceId"
        case workerID = "workerId"
        case client
    }
    
    init(id: String?, clientID: String?, targetID: String?, packageID: String?, businessID: String?, price: Int?, begin: Int?, finish: Int?, recordsBodyDescription: String?, packageDto: PackageDto?, business: Business?, statusPay: String?, payType: String?, statusProcess: String?, statusRecord: String?, businessCategoryID: String?, notificationSend: Bool?, services: [ServiceElement]?, servicesIDS: [JSONAny]?, workingSpaceID: String?, workerID: String?, client: JSONNull?) {
        self.id = id
        self.clientID = clientID
        self.targetID = targetID
        self.packageID = packageID
        self.businessID = businessID
        self.price = price
        self.begin = begin
        self.finish = finish
        self.recordsBodyDescription = recordsBodyDescription
        self.packageDto = packageDto
        self.business = business
        self.statusPay = statusPay
        self.payType = payType
        self.statusProcess = statusProcess
        self.statusRecord = statusRecord
        self.businessCategoryID = businessCategoryID
        self.notificationSend = notificationSend
        self.services = services
        self.servicesIDS = servicesIDS
        self.workingSpaceID = workingSpaceID
        self.workerID = workerID
        self.client = client
    }
}

// MARK: RecordsBodyElement convenience initializers and mutators

extension RecordsBodyElement {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(RecordsBodyElement.self, from: data)
        self.init(id: me.id, clientID: me.clientID, targetID: me.targetID, packageID: me.packageID, businessID: me.businessID, price: me.price, begin: me.begin, finish: me.finish, recordsBodyDescription: me.recordsBodyDescription, packageDto: me.packageDto, business: me.business, statusPay: me.statusPay, payType: me.payType, statusProcess: me.statusProcess, statusRecord: me.statusRecord, businessCategoryID: me.businessCategoryID, notificationSend: me.notificationSend, services: me.services, servicesIDS: me.servicesIDS, workingSpaceID: me.workingSpaceID, workerID: me.workerID, client: me.client)
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
        id: String?? = nil,
        clientID: String?? = nil,
        targetID: String?? = nil,
        packageID: String?? = nil,
        businessID: String?? = nil,
        price: Int?? = nil,
        begin: Int?? = nil,
        finish: Int?? = nil,
        recordsBodyDescription: String?? = nil,
        packageDto: PackageDto?? = nil,
        business: Business?? = nil,
        statusPay: String?? = nil,
        payType: String?? = nil,
        statusProcess: String?? = nil,
        statusRecord: String?? = nil,
        businessCategoryID: String?? = nil,
        notificationSend: Bool?? = nil,
        services: [ServiceElement]?? = nil,
        servicesIDS: [JSONAny]?? = nil,
        workingSpaceID: String?? = nil,
        workerID: String?? = nil,
        client: JSONNull?? = nil
        ) -> RecordsBodyElement {
        return RecordsBodyElement(
            id: id ?? self.id,
            clientID: clientID ?? self.clientID,
            targetID: targetID ?? self.targetID,
            packageID: packageID ?? self.packageID,
            businessID: businessID ?? self.businessID,
            price: price ?? self.price,
            begin: begin ?? self.begin,
            finish: finish ?? self.finish,
            recordsBodyDescription: recordsBodyDescription ?? self.recordsBodyDescription,
            packageDto: packageDto ?? self.packageDto,
            business: business ?? self.business,
            statusPay: statusPay ?? self.statusPay,
            payType: payType ?? self.payType,
            statusProcess: statusProcess ?? self.statusProcess,
            statusRecord: statusRecord ?? self.statusRecord,
            businessCategoryID: businessCategoryID ?? self.businessCategoryID,
            notificationSend: notificationSend ?? self.notificationSend,
            services: services ?? self.services,
            servicesIDS: servicesIDS ?? self.servicesIDS,
            workingSpaceID: workingSpaceID ?? self.workingSpaceID,
            workerID: workerID ?? self.workerID,
            client: client ?? self.client
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


typealias RecordsBody = [RecordsBodyElement]

extension Array where Element == RecordsBody.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RecordsBody.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Business
class Business: Codable {
    let id, corporationID: String?
    let name: String?
    let businessDescription: String?
    let logoURL: String?
    let address, phone: String?
    let addPhone: JSONNull?
    let latitude, longitude: Double?
    let timeZone: Int?
    let businessCategoryID: String?
    let businessCategory: BusinessCategory?
    let objectState: ObjectState?
    let workTimes: [WorkTime]?
    let spaces: [Space]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case corporationID = "corporationId"
        case name
        case businessDescription = "description"
        case logoURL = "logoUrl"
        case address, phone, addPhone, latitude, longitude, timeZone
        case businessCategoryID = "businessCategoryId"
        case businessCategory, objectState, workTimes, spaces
    }
    
    init(id: String?, corporationID: String?, name: String?, businessDescription: String?, logoURL: String?, address: String?, phone: String?, addPhone: JSONNull?, latitude: Double?, longitude: Double?, timeZone: Int?, businessCategoryID: String?, businessCategory: BusinessCategory?, objectState: ObjectState?, workTimes: [WorkTime]?, spaces: [Space]?) {
        self.id = id
        self.corporationID = corporationID
        self.name = name
        self.businessDescription = businessDescription
        self.logoURL = logoURL
        self.address = address
        self.phone = phone
        self.addPhone = addPhone
        self.latitude = latitude
        self.longitude = longitude
        self.timeZone = timeZone
        self.businessCategoryID = businessCategoryID
        self.businessCategory = businessCategory
        self.objectState = objectState
        self.workTimes = workTimes
        self.spaces = spaces
    }
}

// MARK: Business convenience initializers and mutators

extension Business {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Business.self, from: data)
        self.init(id: me.id, corporationID: me.corporationID, name: me.name, businessDescription: me.businessDescription, logoURL: me.logoURL, address: me.address, phone: me.phone, addPhone: me.addPhone, latitude: me.latitude, longitude: me.longitude, timeZone: me.timeZone, businessCategoryID: me.businessCategoryID, businessCategory: me.businessCategory, objectState: me.objectState, workTimes: me.workTimes, spaces: me.spaces)
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
        id: String?? = nil,
        corporationID: String?? = nil,
        name: String?? = nil,
        businessDescription: String?? = nil,
        logoURL: String?? = nil,
        address: String?? = nil,
        phone: String?? = nil,
        addPhone: JSONNull?? = nil,
        latitude: Double?? = nil,
        longitude: Double?? = nil,
        timeZone: Int?? = nil,
        businessCategoryID: String?? = nil,
        businessCategory: BusinessCategory?? = nil,
        objectState: ObjectState?? = nil,
        workTimes: [WorkTime]?? = nil,
        spaces: [Space]?? = nil
        ) -> Business {
        return Business(
            id: id ?? self.id,
            corporationID: corporationID ?? self.corporationID,
            name: name ?? self.name,
            businessDescription: businessDescription ?? self.businessDescription,
            logoURL: logoURL ?? self.logoURL,
            address: address ?? self.address,
            phone: phone ?? self.phone,
            addPhone: addPhone ?? self.addPhone,
            latitude: latitude ?? self.latitude,
            longitude: longitude ?? self.longitude,
            timeZone: timeZone ?? self.timeZone,
            businessCategoryID: businessCategoryID ?? self.businessCategoryID,
            businessCategory: businessCategory ?? self.businessCategory,
            objectState: objectState ?? self.objectState,
            workTimes: workTimes ?? self.workTimes,
            spaces: spaces ?? self.spaces
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
