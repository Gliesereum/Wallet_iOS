//
//  CarClassServices.swift
//  Karma
//
//  Created by macbook on 27/12/2018.
//  Copyright © 2018 Gliesereum. All rights reserved.
//


import Foundation
import Alamofire

typealias CarClassServices = [CarClassService]

class CarClassService: Codable {
    let id, name, description: String?
    let orderIndex: Int?
    
    init(id: String?, name: String?, description: String?, orderIndex: Int?) {
        self.id = id
        self.name = name
        self.description = description
        self.orderIndex = orderIndex
    }
}

// MARK: Convenience initializers and mutators

extension CarClassService {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(CarClassService.self, from: data)
        self.init(id: me.id, name: me.name, description: me.description, orderIndex: me.orderIndex)
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
        orderIndex: Int?
        ) -> CarClassService {
        return CarClassService(
            id: id ?? self.id,
            name: name ?? self.name,
            description: description ?? self.description,
            orderIndex: orderIndex ?? self.orderIndex
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Array where Element == CarClassServices.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CarClassServices.self, from: data)
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
    func responseCarClassServices(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<CarClassServices>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
