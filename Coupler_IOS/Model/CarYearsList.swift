//
//  CarYearsList.swift
//  Karma
//
//  Created by macbook on 26/12/2018.
//  Copyright © 2018 Gliesereum. All rights reserved.
//


import Foundation
import Alamofire

typealias CarYearsList = [CarYearsListElement]

class CarYearsListElement: Codable {
    let id: String?
    let name: Int?
    
    init(id: String?, name: Int?) {
        self.id = id
        self.name = name
    }
}

// MARK: Convenience initializers and mutators

extension CarYearsListElement {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(CarYearsListElement.self, from: data)
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
        name: Int?
        ) -> CarYearsListElement {
        return CarYearsListElement(
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

extension Array where Element == CarYearsList.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CarYearsList.self, from: data)
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
    func responseCarYearsList(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<CarYearsList>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}

