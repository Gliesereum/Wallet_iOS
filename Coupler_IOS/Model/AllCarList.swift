// To parse the JSON, add this file to your project and do:
//
//   let allCarList = try AllCarList(json)

import Foundation

typealias AllCarList = [AllCarListElement]

class AllCarListElement: Codable {
    let id, brandID, modelID, yearID: String?
    let brand: Brand?
    let model: Model?
    let year: Year?
    let userID, registrationNumber, description: String?
    let note: JSONNull?
    let favorite: Bool?
    let services: [ServiceACL]?
    let attributes: [AttributeACL]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case brandID = "brandId"
        case modelID = "modelId"
        case yearID = "yearId"
        case brand, model, year
        case userID = "userId"
        case registrationNumber, description, note, favorite, services, attributes
    }
    
    init(id: String?, brandID: String?, modelID: String?, yearID: String?, brand: Brand?, model: Model?, year: Year?, userID: String?, registrationNumber: String?, description: String?, note: JSONNull?, favorite: Bool?, services: [ServiceACL]?, attributes: [AttributeACL]?) {
        self.id = id
        self.brandID = brandID
        self.modelID = modelID
        self.yearID = yearID
        self.brand = brand
        self.model = model
        self.year = year
        self.userID = userID
        self.registrationNumber = registrationNumber
        self.description = description
        self.note = note
        self.favorite = favorite
        self.services = services
        self.attributes = attributes
    }
}

class AttributeACL: Codable {
    let id, value, title, filterID: String?
    
    let descriptions: DescriptionsFB?
    
    enum CodingKeys: String, CodingKey {
        case id, value, title
        case filterID = "filterId"
        case descriptions
    }
    
    init(id: String?, value: String?, title: String?, filterID: String?, descriptions: DescriptionsFB?) {
        self.id = id
        self.value = value
        self.title = title
        self.filterID = filterID
        self.descriptions = descriptions
    }
}

class Brand: Codable {
    let id, name: String?
    
    init(id: String?, name: String?) {
        self.id = id
        self.name = name
    }
}

class Model: Codable {
    let id, brandID, name: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case brandID = "brandId"
        case name
    }
    
    init(id: String?, brandID: String?, name: String?) {
        self.id = id
        self.brandID = brandID
        self.name = name
    }
}

class ServiceACL: Codable {
    let id, name, description: String?
    let orderIndex: Int?
    let serviceType: String?
    
    init(id: String?, name: String?, description: String?, orderIndex: Int?, serviceType: String?) {
        self.id = id
        self.name = name
        self.description = description
        self.orderIndex = orderIndex
        self.serviceType = serviceType
    }
}

class Year: Codable {
    let id: String?
    let name: Int?
    
    init(id: String?, name: Int?) {
        self.id = id
        self.name = name
    }
}

// MARK: Convenience initializers and mutators

extension AllCarListElement {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(AllCarListElement.self, from: data)
        self.init(id: me.id, brandID: me.brandID, modelID: me.modelID, yearID: me.yearID, brand: me.brand, model: me.model, year: me.year, userID: me.userID, registrationNumber: me.registrationNumber, description: me.description, note: me.note, favorite: me.favorite, services: me.services, attributes: me.attributes)
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
        brandID: String?? = nil,
        modelID: String?? = nil,
        yearID: String?? = nil,
        brand: Brand?? = nil,
        model: Model?? = nil,
        year: Year?? = nil,
        userID: String?? = nil,
        registrationNumber: String?? = nil,
        description: String?? = nil,
        note: JSONNull?? = nil,
        favorite: Bool?? = nil,
        services: [ServiceACL]?? = nil,
        attributes: [AttributeACL]?? = nil
        ) -> AllCarListElement {
        return AllCarListElement(
            id: id ?? self.id,
            brandID: brandID ?? self.brandID,
            modelID: modelID ?? self.modelID,
            yearID: yearID ?? self.yearID,
            brand: brand ?? self.brand,
            model: model ?? self.model,
            year: year ?? self.year,
            userID: userID ?? self.userID,
            registrationNumber: registrationNumber ?? self.registrationNumber,
            description: description ?? self.description,
            note: note ?? self.note,
            favorite: favorite ?? self.favorite,
            services: services ?? self.services,
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

extension AttributeACL {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(AttributeACL.self, from: data)
        self.init(id: me.id, value: me.value, title: me.title, filterID: me.filterID, descriptions: me.descriptions)
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
        value: String?? = nil,
        title: String?? = nil,
        filterID: String?? = nil,
        descriptions: DescriptionsFB?
        ) -> AttributeACL {
        return AttributeACL(
            id: id ?? self.id,
            value: value ?? self.value,
            title: title ?? self.title,
            filterID: filterID ?? self.filterID,
            descriptions: descriptions ?? self.descriptions
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Brand {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Brand.self, from: data)
        self.init(id: me.id, name: me.name)
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
        name: String?? = nil
        ) -> Brand {
        return Brand(
            id: id ?? self.id,
            name: name ?? self.name
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Model {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Model.self, from: data)
        self.init(id: me.id, brandID: me.brandID, name: me.name)
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
        brandID: String?? = nil,
        name: String?? = nil
        ) -> Model {
        return Model(
            id: id ?? self.id,
            brandID: brandID ?? self.brandID,
            name: name ?? self.name
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension ServiceACL {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(ServiceACL.self, from: data)
        self.init(id: me.id, name: me.name, description: me.description, orderIndex: me.orderIndex, serviceType: me.serviceType)
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
        name: String?? = nil,
        description: String?? = nil,
        orderIndex: Int?? = nil,
        serviceType: String?? = nil
        ) -> ServiceACL {
        return ServiceACL(
            id: id ?? self.id,
            name: name ?? self.name,
            description: description ?? self.description,
            orderIndex: orderIndex ?? self.orderIndex,
            serviceType: serviceType ?? self.serviceType
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Year {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Year.self, from: data)
        self.init(id: me.id, name: me.name)
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
        name: Int?? = nil
        ) -> Year {
        return Year(
            id: id ?? self.id,
            name: name ?? self.name
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Array where Element == AllCarList.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AllCarList.self, from: data)
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

