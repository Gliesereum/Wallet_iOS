// To parse the JSON, add this file to your project and do:
//
//   let orderedBodyCarWash = try OrderedBodyCarWash(json)

import Foundation

typealias OrderedBodyCarWash = [OrderedBodyCarWashElement]

class OrderedBodyCarWashElement: Codable {
    let id, targetID: String?
    let packageID: String?
    let businessID: String?
    let price, begin, finish: Int?
    let description: String?
    let packageDto: PackageDtoOBCW?
    let business: BusinessOBCW?
    let statusPay, statusProcess, statusRecord: String?
    let serviceType: ServiceTypeOBCW?
    let services: [ServiceElementOBCW]?
    let servicesIDS: [JSONAny]?
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
    
    init(id: String?, targetID: String?, packageID: String?, businessID: String?, price: Int?, begin: Int?, finish: Int?, description: String?, packageDto: PackageDtoOBCW?, business: BusinessOBCW?, statusPay: String?, statusProcess: String?, statusRecord: String?, serviceType: ServiceTypeOBCW?, services: [ServiceElementOBCW]?, servicesIDS: [JSONAny]?, workingSpaceID: String?) {
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

class BusinessOBCW: Codable {
    let id, corporationID, name, description: String?
    let logoURL: JSONNull?
    let address, phone: String?
    let addPhone: JSONNull?
    let latitude, longitude: Double?
    let timeZone: Int?
    let serviceType: ServiceTypeOBCW?
    let objectState: ObjectStateOBCW?
    let workTimes: [WorkTimeOBCW]?
    let spaces: [SpaceOBCW]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case corporationID = "corporationId"
        case name, description
        case logoURL = "logoUrl"
        case address, phone, addPhone, latitude, longitude, timeZone, serviceType, objectState, workTimes, spaces
    }
    
    init(id: String?, corporationID: String?, name: String?, description: String?, logoURL: JSONNull?, address: String?, phone: String?, addPhone: JSONNull?, latitude: Double?, longitude: Double?, timeZone: Int?, serviceType: ServiceTypeOBCW?, objectState: ObjectStateOBCW?, workTimes: [WorkTimeOBCW]?, spaces: [SpaceOBCW]?) {
        self.id = id
        self.corporationID = corporationID
        self.name = name
        self.description = description
        self.logoURL = logoURL
        self.address = address
        self.phone = phone
        self.addPhone = addPhone
        self.latitude = latitude
        self.longitude = longitude
        self.timeZone = timeZone
        self.serviceType = serviceType
        self.objectState = objectState
        self.workTimes = workTimes
        self.spaces = spaces
    }
}

enum ObjectStateOBCW: String, Codable {
    case active = "ACTIVE"
}

enum ServiceTypeOBCW: String, Codable {
    case carWash = "CAR_WASH"
}

class SpaceOBCW: Codable {
    let id: String?
    let indexNumber: Int?
    let businessID: String?
    let statusSpace: JSONNull?
    let serviceType: ServiceTypeOBCW?
    let workers: [JSONAny]?
    
    enum CodingKeys: String, CodingKey {
        case id, indexNumber
        case businessID = "businessId"
        case statusSpace, serviceType, workers
    }
    
    init(id: String?, indexNumber: Int?, businessID: String?, statusSpace: JSONNull?, serviceType: ServiceTypeOBCW?, workers: [JSONAny]?) {
        self.id = id
        self.indexNumber = indexNumber
        self.businessID = businessID
        self.statusSpace = statusSpace
        self.serviceType = serviceType
        self.workers = workers
    }
}

class WorkTimeOBCW: Codable {
    let id: String?
    let from, to: Int?
    let objectID: String?
    let isWork: Bool?
    let serviceType: ServiceTypeOBCW?
    let dayOfWeek: String?
    
    enum CodingKeys: String, CodingKey {
        case id, from, to
        case objectID = "objectId"
        case isWork, serviceType, dayOfWeek
    }
    
    init(id: String?, from: Int?, to: Int?, objectID: String?, isWork: Bool?, serviceType: ServiceTypeOBCW?, dayOfWeek: String?) {
        self.id = id
        self.from = from
        self.to = to
        self.objectID = objectID
        self.isWork = isWork
        self.serviceType = serviceType
        self.dayOfWeek = dayOfWeek
    }
}

class PackageDtoOBCW: Codable {
    let id, name: String?
    let discount, duration: Int?
    let businessID: String?
    let objectState: ObjectStateOBCW?
    let servicesIDS: [JSONAny]?
    let services: [ServiceElementOBCW]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, discount, duration
        case businessID = "businessId"
        case objectState
        case servicesIDS = "servicesIds"
        case services
    }
    
    init(id: String?, name: String?, discount: Int?, duration: Int?, businessID: String?, objectState: ObjectStateOBCW?, servicesIDS: [JSONAny]?, services: [ServiceElementOBCW]?) {
        self.id = id
        self.name = name
        self.discount = discount
        self.duration = duration
        self.businessID = businessID
        self.objectState = objectState
        self.servicesIDS = servicesIDS
        self.services = services
    }
}

class ServiceElementOBCW: Codable {
    let id, name: String?
    let description: JSONNull?
    let price: Int?
    let serviceID, businessID: String?
    let service: ServiceServiceOBCW?
    let objectState: ObjectStateOBCW?
    let duration: Int?
    let serviceClass: [JSONAny]?
    let attributes: [AttributeOBCW]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, price
        case serviceID = "serviceId"
        case businessID = "businessId"
        case service, objectState, duration, serviceClass, attributes
    }
    
    init(id: String?, name: String?, description: JSONNull?, price: Int?, serviceID: String?, businessID: String?, service: ServiceServiceOBCW?, objectState: ObjectStateOBCW?, duration: Int?, serviceClass: [JSONAny]?, attributes: [AttributeOBCW]?) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.serviceID = serviceID
        self.businessID = businessID
        self.service = service
        self.objectState = objectState
        self.duration = duration
        self.serviceClass = serviceClass
        self.attributes = attributes
    }
}

class AttributeOBCW: Codable {
    let id, value, title, filterID: String?
    
    enum CodingKeys: String, CodingKey {
        case id, value, title
        case filterID = "filterId"
    }
    
    init(id: String?, value: String?, title: String?, filterID: String?) {
        self.id = id
        self.value = value
        self.title = title
        self.filterID = filterID
    }
}

class ServiceServiceOBCW: Codable {
    let id, name, description: String?
    let serviceType: ServiceTypeOBCW?
    let objectState: ObjectStateOBCW?
    
    init(id: String?, name: String?, description: String?, serviceType: ServiceTypeOBCW?, objectState: ObjectStateOBCW?) {
        self.id = id
        self.name = name
        self.description = description
        self.serviceType = serviceType
        self.objectState = objectState
    }
}

// MARK: Convenience initializers and mutators

extension OrderedBodyCarWashElement {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(OrderedBodyCarWashElement.self, from: data)
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
        id: String?,
        targetID: String?,
        packageID: String?,
        businessID: String?,
        price: Int?,
        begin: Int?,
        finish: Int?,
        description: String?,
        packageDto: PackageDtoOBCW?,
        business: BusinessOBCW?,
        statusPay: String?,
        statusProcess: String?,
        statusRecord: String?,
        serviceType: ServiceTypeOBCW?,
        services: [ServiceElementOBCW]?,
        servicesIDS: [JSONAny]?? = nil,
        workingSpaceID: String?? = nil
        ) -> OrderedBodyCarWashElement {
        return OrderedBodyCarWashElement(
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

extension BusinessOBCW {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(BusinessOBCW.self, from: data)
        self.init(id: me.id, corporationID: me.corporationID, name: me.name, description: me.description, logoURL: me.logoURL, address: me.address, phone: me.phone, addPhone: me.addPhone, latitude: me.latitude, longitude: me.longitude, timeZone: me.timeZone, serviceType: me.serviceType, objectState: me.objectState, workTimes: me.workTimes, spaces: me.spaces)
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
        id: String?,
        corporationID: String?,
        name: String?,
        description: String?,
        logoURL: JSONNull?,
        address: String?,
        phone: String?,
        addPhone: JSONNull?,
        latitude: Double?,
        longitude: Double?,
        timeZone: Int?,
        serviceType: ServiceTypeOBCW?,
        objectState: ObjectStateOBCW?,
        workTimes: [WorkTimeOBCW]?,
        spaces: [SpaceOBCW]?
        ) -> BusinessOBCW {
        return BusinessOBCW(
            id: id ?? self.id,
            corporationID: corporationID ?? self.corporationID,
            name: name ?? self.name,
            description: description ?? self.description,
            logoURL: logoURL ?? self.logoURL,
            address: address ?? self.address,
            phone: phone ?? self.phone,
            addPhone: addPhone ?? self.addPhone,
            latitude: latitude ?? self.latitude,
            longitude: longitude ?? self.longitude,
            timeZone: timeZone ?? self.timeZone,
            serviceType: serviceType ?? self.serviceType,
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

extension SpaceOBCW {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(SpaceOBCW.self, from: data)
        self.init(id: me.id, indexNumber: me.indexNumber, businessID: me.businessID, statusSpace: me.statusSpace, serviceType: me.serviceType, workers: me.workers)
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
        id: String?,
        indexNumber: Int?,
        businessID: String?,
        statusSpace: JSONNull?,
        serviceType: ServiceTypeOBCW?,
        workers: [JSONAny]?
        ) -> SpaceOBCW {
        return SpaceOBCW(
            id: id ?? self.id,
            indexNumber: indexNumber ?? self.indexNumber,
            businessID: businessID ?? self.businessID,
            statusSpace: statusSpace ?? self.statusSpace,
            serviceType: serviceType ?? self.serviceType,
            workers: workers ?? self.workers
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension WorkTimeOBCW {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(WorkTimeOBCW.self, from: data)
        self.init(id: me.id, from: me.from, to: me.to, objectID: me.objectID, isWork: me.isWork, serviceType: me.serviceType, dayOfWeek: me.dayOfWeek)
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
        id: String?,
        from: Int?,
        to: Int?,
        objectID: String?,
        isWork: Bool?,
        serviceType: ServiceTypeOBCW?,
        dayOfWeek: String?
        ) -> WorkTimeOBCW {
        return WorkTimeOBCW(
            id: id ?? self.id,
            from: from ?? self.from,
            to: to ?? self.to,
            objectID: objectID ?? self.objectID,
            isWork: isWork ?? self.isWork,
            serviceType: serviceType ?? self.serviceType,
            dayOfWeek: dayOfWeek ?? self.dayOfWeek
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension PackageDtoOBCW {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(PackageDtoOBCW.self, from: data)
        self.init(id: me.id, name: me.name, discount: me.discount, duration: me.duration, businessID: me.businessID, objectState: me.objectState, servicesIDS: me.servicesIDS, services: me.services)
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
        id: String?,
        name: String?,
        discount: Int?,
        duration: Int?,
        businessID: String?,
        objectState: ObjectStateOBCW?,
        servicesIDS: [JSONAny]?,
        services: [ServiceElementOBCW]?
        ) -> PackageDtoOBCW {
        return PackageDtoOBCW(
            id: id ?? self.id,
            name: name ?? self.name,
            discount: discount ?? self.discount,
            duration: duration ?? self.duration,
            businessID: businessID ?? self.businessID,
            objectState: objectState ?? self.objectState,
            servicesIDS: servicesIDS ?? self.servicesIDS,
            services: services ?? self.services
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension ServiceElementOBCW {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(ServiceElementOBCW.self, from: data)
        self.init(id: me.id, name: me.name, description: me.description, price: me.price, serviceID: me.serviceID, businessID: me.businessID, service: me.service, objectState: me.objectState, duration: me.duration, serviceClass: me.serviceClass, attributes: me.attributes)
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
        id: String?,
        name: String?,
        description: JSONNull?,
        price: Int?,
        serviceID: String?,
        businessID: String?,
        service: ServiceServiceOBCW?,
        objectState: ObjectStateOBCW?,
        duration: Int?,
        serviceClass: [JSONAny]?,
        attributes: [AttributeOBCW]?
        ) -> ServiceElementOBCW {
        return ServiceElementOBCW(
            id: id ?? self.id,
            name: name ?? self.name,
            description: description ?? self.description,
            price: price ?? self.price,
            serviceID: serviceID ?? self.serviceID,
            businessID: businessID ?? self.businessID,
            service: service ?? self.service,
            objectState: objectState ?? self.objectState,
            duration: duration ?? self.duration,
            serviceClass: serviceClass ?? self.serviceClass,
            attributes: attributes ?? self.attributes
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension AttributeOBCW {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(AttributeOBCW.self, from: data)
        self.init(id: me.id, value: me.value, title: me.title, filterID: me.filterID)
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
        id: String?,
        value: String?,
        title: String?,
        filterID: String?
        ) -> AttributeOBCW {
        return AttributeOBCW(
            id: id ?? self.id,
            value: value ?? self.value,
            title: title ?? self.title,
            filterID: filterID ?? self.filterID
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension ServiceServiceOBCW {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(ServiceServiceOBCW.self, from: data)
        self.init(id: me.id, name: me.name, description: me.description, serviceType: me.serviceType, objectState: me.objectState)
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
        id: String?,
        name: String?,
        description: String?,
        serviceType: ServiceTypeOBCW?,
        objectState: ObjectStateOBCW?
        ) -> ServiceServiceOBCW {
        return ServiceServiceOBCW(
            id: id ?? self.id,
            name: name ?? self.name,
            description: description ?? self.description,
            serviceType: serviceType ?? self.serviceType,
            objectState: objectState ?? self.objectState
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Array where Element == OrderedBodyCarWash.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(OrderedBodyCarWash.self, from: data)
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

