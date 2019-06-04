// To parse the JSON, add this file to your project and do:
//
//   let buisnessBody = try BuisnessBody(json)

import Foundation

typealias BuisnessBody = [BuisnessBodyElement]

class BuisnessBodyElement: Codable {
    let id, code, name, description: String?
    let imageURL: String?
    let businessType: String?
    let active: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, code, name, description
        case imageURL = "imageUrl"
        case businessType
        case active
    }
    
    init(id: String?, code: String?, name: String?, description: String?, imageURL: String?, businessType: String?, active: Bool?) {
        self.id = id
        self.code = code
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.businessType = businessType
        self.active = active
    }
}

// MARK: Convenience initializers and mutators

extension BuisnessBodyElement {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(BuisnessBodyElement.self, from: data)
        self.init(id: me.id, code: me.code, name: me.name, description: me.description, imageURL: me.imageURL, businessType: me.businessType, active: me.active)
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
        code: String?? = nil,
        name: String?? = nil,
        description: String?? = nil,
        imageURL: String?? = nil,
        businessType: String?? = nil,
        active: Bool?
        ) -> BuisnessBodyElement {
        return BuisnessBodyElement(
            id: id ?? self.id,
            code: code ?? self.code,
            name: name ?? self.name,
            description: description ?? self.description,
            imageURL: imageURL ?? self.imageURL,
            businessType: businessType ?? self.businessType,
            active:active ?? self.active
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Array where Element == BuisnessBody.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(BuisnessBody.self, from: data)
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
