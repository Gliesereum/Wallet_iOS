// To parse the JSON, add this file to your project and do:
//
//   let filterMarkerBody = try FilterMarkerBody(json)

import Foundation

typealias FilterMarkerBody = [FilterMarkerBodyElement]

class FilterMarkerBodyElement: Codable {
    let id, name, description, businessCategoryID: String?
    let objectState: ObjectStateFMBE?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description
        case businessCategoryID = "businessCategoryId"
        case objectState
    }
    
    init(id: String?, name: String?, description: String?, businessCategoryID: String?, objectState: ObjectStateFMBE?) {
        self.id = id
        self.name = name
        self.description = description
        self.businessCategoryID = businessCategoryID
        self.objectState = objectState
    }
}

enum ObjectStateFMBE: String, Codable {
    case active = "ACTIVE"
}

// MARK: Convenience initializers and mutators

extension FilterMarkerBodyElement {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(FilterMarkerBodyElement.self, from: data)
        self.init(id: me.id, name: me.name, description: me.description, businessCategoryID: me.businessCategoryID, objectState: me.objectState)
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
        businessCategoryID: String?? = nil,
        objectState: ObjectStateFMBE?? = nil
        ) -> FilterMarkerBodyElement {
        return FilterMarkerBodyElement(
            id: id ?? self.id,
            name: name ?? self.name,
            description: description ?? self.description,
            businessCategoryID: businessCategoryID ?? self.businessCategoryID,
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

extension Array where Element == FilterMarkerBody.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(FilterMarkerBody.self, from: data)
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
