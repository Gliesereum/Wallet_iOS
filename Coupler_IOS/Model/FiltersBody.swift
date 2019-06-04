//
//  FiltersBody.swift
//  Karma
//
//  Created by macbook on 12/03/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//

import Foundation
import Alamofire

typealias FiltersBody = [FiltersBodyElement]

class FiltersBodyElement: Codable {
    let id, value, title, serviceType: String?
    let attributes: [AttributeFB]?
    
    init(id: String?, value: String?, title: String?, serviceType: String?, attributes: [AttributeFB]?) {
        self.id = id
        self.value = value
        self.title = title
        self.serviceType = serviceType
        self.attributes = attributes
    }
}

class AttributeFB: Codable {
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

// MARK: Convenience initializers and mutators

extension FiltersBodyElement {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(FiltersBodyElement.self, from: data)
        self.init(id: me.id, value: me.value, title: me.title, serviceType: me.serviceType, attributes: me.attributes)
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
        serviceType: String?,
        attributes: [AttributeFB]?
        ) -> FiltersBodyElement {
        return FiltersBodyElement(
            id: id ?? self.id,
            value: value ?? self.value,
            title: title ?? self.title,
            serviceType: serviceType ?? self.serviceType,
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

extension AttributeFB {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Attribute.self, from: data)
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
        ) -> Attribute {
        return Attribute(
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

extension Array where Element == FiltersBody.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(FiltersBody.self, from: data)
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
    func responseFiltersBody(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<FiltersBody>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
