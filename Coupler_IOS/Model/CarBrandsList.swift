//
//  CarBrandsList.swift
//  Karma
//
//  Created by macbook on 26/12/2018.
//  Copyright © 2018 Gliesereum. All rights reserved.
//

import Foundation
import Alamofire

typealias CarBrandsList = [CarBrandsListElement]

class CarBrandsListElement: Codable {
    let id, name: String?
    
    init(id: String?, name: String?) {
        self.id = id
        self.name = name
    }
}

// MARK: Convenience initializers and mutators

extension CarBrandsListElement {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(CarBrandsListElement.self, from: data)
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
        id: String?,
        name: String?
        ) -> CarBrandsListElement {
        return CarBrandsListElement(
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

extension Array where Element == CarBrandsList.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CarBrandsList.self, from: data)
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
    func responseCarBrandsList(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<CarBrandsList>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
