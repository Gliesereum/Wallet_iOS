// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let carWashMarker = try CarWashMarker(json)

import Foundation

// MARK: - CarWashMarkerElement
class CarWashMarkerElement: NSObject, Codable{
    let id, corporationID, name: String?
    let countBox: Int?
    let carWashMarkerDescription, address: String?
    let logoURL: String?
    let phone: String?
    let addPhone: String?
    let latitude, longitude: Double?
    let timeZone: Int?
    let geoPoint: GeoPoint?
    let businessCategoryID: String?
    let objectState: String?
    let services: [ServiceCME]?
    let workTimes: [WorkTimeCME?]?
    let score: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case corporationID = "corporationId"
        case name, countBox
        case carWashMarkerDescription = "description"
        case address
        case logoURL = "logoUrl"
        case phone, addPhone, latitude, longitude, timeZone, geoPoint
        case businessCategoryID = "businessCategoryId"
        case objectState, services, workTimes, score
    }
    
    init(id: String?, corporationID: String?, name: String?, countBox: Int?, carWashMarkerDescription: String?, address: String?, logoURL: String?, phone: String?, addPhone: String?, latitude: Double?, longitude: Double?, timeZone: Int?, geoPoint: GeoPoint?, businessCategoryID: String?, objectState: String?, services: [ServiceCME]?, workTimes: [WorkTimeCME?]?, score: Double?) {
        self.id = id
        self.corporationID = corporationID
        self.name = name
        self.countBox = countBox
        self.carWashMarkerDescription = carWashMarkerDescription
        self.address = address
        self.logoURL = logoURL
        self.phone = phone
        self.addPhone = addPhone
        self.latitude = latitude
        self.longitude = longitude
        self.timeZone = timeZone
        self.geoPoint = geoPoint
        self.businessCategoryID = businessCategoryID
        self.objectState = objectState
        self.services = services
        self.workTimes = workTimes
        self.score = score
    }
}

// MARK: CarWashMarkerElement convenience initializers and mutators

extension CarWashMarkerElement {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(CarWashMarkerElement.self, from: data)
        self.init(id: me.id, corporationID: me.corporationID, name: me.name, countBox: me.countBox, carWashMarkerDescription: me.carWashMarkerDescription, address: me.address, logoURL: me.logoURL, phone: me.phone, addPhone: me.addPhone, latitude: me.latitude, longitude: me.longitude, timeZone: me.timeZone, geoPoint: me.geoPoint, businessCategoryID: me.businessCategoryID, objectState: me.objectState, services: me.services, workTimes: me.workTimes, score: me.score)
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
        countBox: Int?? = nil,
        carWashMarkerDescription: String?? = nil,
        address: String?? = nil,
        logoURL: String?? = nil,
        phone: String?? = nil,
        addPhone: String?? = nil,
        latitude: Double?? = nil,
        longitude: Double?? = nil,
        timeZone: Int?? = nil,
        geoPoint: GeoPoint?? = nil,
        businessCategoryID: String?? = nil,
        objectState: String?? = nil,
        services: [ServiceCME]?? = nil,
        workTimes: [WorkTimeCME]?? = nil,
        score: Double?? = nil
        ) -> CarWashMarkerElement {
        return CarWashMarkerElement(
            id: id ?? self.id,
            corporationID: corporationID ?? self.corporationID,
            name: name ?? self.name,
            countBox: countBox ?? self.countBox,
            carWashMarkerDescription: carWashMarkerDescription ?? self.carWashMarkerDescription,
            address: address ?? self.address,
            logoURL: logoURL ?? self.logoURL,
            phone: phone ?? self.phone,
            addPhone: addPhone ?? self.addPhone,
            latitude: latitude ?? self.latitude,
            longitude: longitude ?? self.longitude,
            timeZone: timeZone ?? self.timeZone,
            geoPoint: geoPoint ?? self.geoPoint,
            businessCategoryID: businessCategoryID ?? self.businessCategoryID,
            objectState: objectState ?? self.objectState,
            services: services ?? self.services,
            workTimes: workTimes ?? self.workTimes,
            score: score ?? self.score
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - GeoPoint
class GeoPoint:NSObject, Codable {
    let lat, lon: Double?
    
    init(lat: Double?, lon: Double?) {
        self.lat = lat
        self.lon = lon
    }
}

// MARK: GeoPoint convenience initializers and mutators

extension GeoPoint {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(GeoPoint.self, from: data)
        self.init(lat: me.lat, lon: me.lon)
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
        lat: Double?? = nil,
        lon: Double?? = nil
        ) -> GeoPoint {
        return GeoPoint(
            lat: lat ?? self.lat,
            lon: lon ?? self.lon
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}



// MARK: - Service
class ServiceCME:NSObject, Codable {
    let name: String?
    let price: Int?
    let serviceID, businessID: String?
    let duration: Int?
    let serviceClassIDS: [String]?
    let filterIDS, filterAttributeIDS: [String]?
    
    enum CodingKeys: String, CodingKey {
        case name, price
        case serviceID = "serviceId"
        case businessID = "businessId"
        case duration
        case serviceClassIDS = "serviceClassIds"
        case filterIDS = "filterIds"
        case filterAttributeIDS = "filterAttributeIds"
    }
    
    init(name: String?, price: Int?, serviceID: String?, businessID: String?, duration: Int?, serviceClassIDS: [String]?, filterIDS: [String]?, filterAttributeIDS: [String]?) {
        self.name = name
        self.price = price
        self.serviceID = serviceID
        self.businessID = businessID
        self.duration = duration
        self.serviceClassIDS = serviceClassIDS
        self.filterIDS = filterIDS
        self.filterAttributeIDS = filterAttributeIDS
    }
}

// MARK: Service convenience initializers and mutators

extension ServiceCME {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(ServiceCME.self, from: data)
        self.init(name: me.name, price: me.price, serviceID: me.serviceID, businessID: me.businessID, duration: me.duration, serviceClassIDS: me.serviceClassIDS, filterIDS: me.filterIDS, filterAttributeIDS: me.filterAttributeIDS)
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
        name: String?? = nil,
        price: Int?? = nil,
        serviceID: String?? = nil,
        businessID: String?? = nil,
        duration: Int?? = nil,
        serviceClassIDS: [String]?? = nil,
        filterIDS: [String]?? = nil,
        filterAttributeIDS: [String]?? = nil
        ) -> ServiceCME {
        return ServiceCME(
            name: name ?? self.name,
            price: price ?? self.price,
            serviceID: serviceID ?? self.serviceID,
            businessID: businessID ?? self.businessID,
            duration: duration ?? self.duration,
            serviceClassIDS: serviceClassIDS ?? self.serviceClassIDS,
            filterIDS: filterIDS ?? self.filterIDS,
            filterAttributeIDS: filterAttributeIDS ?? self.filterAttributeIDS
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - WorkTime
class WorkTimeCME:NSObject, Codable {
    let from: String?
    let to: String?
    let objectID: String?
    let isWork: Bool?
    let businessCategoryID: String?
    let dayOfWeek: String?
    
    enum CodingKeys: String, CodingKey {
        case from, to
        case objectID = "objectId"
        case isWork
        case businessCategoryID = "businessCategoryId"
        case dayOfWeek
    }
    
    init(from: String?, to: String?, objectID: String?, isWork: Bool?, businessCategoryID: String?, dayOfWeek: String?) {
        self.from = from
        self.to = to
        self.objectID = objectID
        self.isWork = isWork
        self.businessCategoryID = businessCategoryID
        self.dayOfWeek = dayOfWeek
    }
}

// MARK: WorkTime convenience initializers and mutators

extension WorkTimeCME {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(WorkTimeCME.self, from: data)
        self.init(from: me.from, to: me.to, objectID: me.objectID, isWork: me.isWork, businessCategoryID: me.businessCategoryID, dayOfWeek: me.dayOfWeek)
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
        from: String?? = nil,
        to: String?? = nil,
        objectID: String?? = nil,
        isWork: Bool?? = nil,
        businessCategoryID: String?? = nil,
        dayOfWeek: String?? = nil
        ) -> WorkTimeCME {
        return WorkTimeCME(
            from: from ?? self.from,
            to: to ?? self.to,
            objectID: objectID ?? self.objectID,
            isWork: isWork ?? self.isWork,
            businessCategoryID: businessCategoryID ?? self.businessCategoryID,
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



typealias CarWashMarker = [CarWashMarkerElement]

extension Array where Element == CarWashMarker.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CarWashMarker.self, from: data)
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

