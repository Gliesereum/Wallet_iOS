// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let carWashMarker = try CarWashMarker(json)

import Foundation

// MARK: - CarWashMarkerElement
class CarWashMarkerElement: NSObject, Codable {
    let id, corporationID, name: String?
    let businessVerify: Bool?
    let countBox: Int?
    let carWashMarkerDescription, address: String?
    let logoURL: String?
    let phone: String?
    let addPhone: JSONNull?
    let latitude, longitude, rating: Double?
    let timeZone, ratingCount: Int?
    let geoPoint: GeoPoint?
    let businessCategoryID, objectState: String?
    let services: [Service]?
    let serviceNames: [String]?
    let score: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case corporationID = "corporationId"
        case name, countBox, businessVerify
        case carWashMarkerDescription = "description"
        case address
        case logoURL = "logoUrl"
        case phone, addPhone, latitude, longitude, timeZone, rating, ratingCount, geoPoint
        case businessCategoryID = "businessCategoryId"
        case objectState, services, serviceNames, score
    }
    
    init(id: String?, corporationID: String?, name: String?, businessVerify: Bool?, countBox: Int?, carWashMarkerDescription: String?, address: String?, logoURL: String?, phone: String?, addPhone: JSONNull?, latitude: Double?, longitude: Double?, timeZone: Int?, rating: Double?, ratingCount: Int?, geoPoint: GeoPoint?, businessCategoryID: String?, objectState: String?, services: [Service]?, serviceNames: [String]?, score: Double?) {
        self.id = id
        self.corporationID = corporationID
        self.name = name
        self.businessVerify = businessVerify
        self.countBox = countBox
        self.carWashMarkerDescription = carWashMarkerDescription
        self.address = address
        self.logoURL = logoURL
        self.phone = phone
        self.addPhone = addPhone
        self.latitude = latitude
        self.longitude = longitude
        self.timeZone = timeZone
        self.rating = rating
        self.ratingCount = ratingCount
        self.geoPoint = geoPoint
        self.businessCategoryID = businessCategoryID
        self.objectState = objectState
        self.services = services
        self.serviceNames = serviceNames
        self.score = score
    }
}

// MARK: CarWashMarkerElement convenience initializers and mutators

extension CarWashMarkerElement {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(CarWashMarkerElement.self, from: data)
        self.init(id: me.id, corporationID: me.corporationID, name: me.name, businessVerify: me.businessVerify, countBox: me.countBox, carWashMarkerDescription: me.carWashMarkerDescription, address: me.address, logoURL: me.logoURL, phone: me.phone, addPhone: me.addPhone, latitude: me.latitude, longitude: me.longitude, timeZone: me.timeZone, rating: me.rating, ratingCount: me.ratingCount, geoPoint: me.geoPoint, businessCategoryID: me.businessCategoryID, objectState: me.objectState, services: me.services, serviceNames: me.serviceNames, score: me.score)
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
        businessVerify: Bool?? = nil,
        countBox: Int?? = nil,
        carWashMarkerDescription: String?? = nil,
        address: String?? = nil,
        logoURL: String?? = nil,
        phone: String?? = nil,
        addPhone: JSONNull?? = nil,
        latitude: Double?? = nil,
        longitude: Double?? = nil,
        timeZone: Int?? = nil,
        rating: Double?? = nil,
        ratingCount: Int?? = nil,
        geoPoint: GeoPoint?? = nil,
        businessCategoryID: String?? = nil,
        objectState: String?? = nil,
        services: [Service]?? = nil,
        workTimes: [WorkTime]?? = nil,
        serviceNames: [String]?? = nil,
        score: Double?? = nil
        ) -> CarWashMarkerElement {
        return CarWashMarkerElement(
            id: id ?? self.id,
            corporationID: corporationID ?? self.corporationID,
            name: name ?? self.name,
            businessVerify: businessVerify ?? self.businessVerify,
            countBox: countBox ?? self.countBox,
            carWashMarkerDescription: carWashMarkerDescription ?? self.carWashMarkerDescription,
            address: address ?? self.address,
            logoURL: logoURL ?? self.logoURL,
            phone: phone ?? self.phone,
            addPhone: addPhone ?? self.addPhone,
            latitude: latitude ?? self.latitude,
            longitude: longitude ?? self.longitude,
            timeZone: timeZone ?? self.timeZone,
            rating: rating ?? self.rating,
            ratingCount: ratingCount ?? self.ratingCount,
            geoPoint: geoPoint ?? self.geoPoint,
            businessCategoryID: businessCategoryID ?? self.businessCategoryID,
            objectState: objectState ?? self.objectState,
            services: services ?? self.services,
            serviceNames: serviceNames ?? self.serviceNames,
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
class GeoPoint: Codable {
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




enum From: String, Codable {
    case the0600 = "06:00"
}

enum To: String, Codable {
    case the2300 = "23:00"
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

