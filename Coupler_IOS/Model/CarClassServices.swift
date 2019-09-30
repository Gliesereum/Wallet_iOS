//
//  CarClassServices.swift
//  Karma
//
//  Created by macbook on 27/12/2018.
//  Copyright © 2018 Gliesereum. All rights reserved.
//


import Foundation
import Alamofire

// MARK: - CarClassService
struct CarClassService: Codable {
    let id: String?
    let orderIndex: Int?
    let name, carClassServiceDescription: String?
    let descriptions: Descriptions?
    
    enum CodingKeys: String, CodingKey {
        case id, orderIndex, name
        case carClassServiceDescription = "description"
        case descriptions
    }
}

// MARK: - Descriptions

typealias CarClassServices = [CarClassService]

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
