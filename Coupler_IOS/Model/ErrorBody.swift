//
//  ErrorBody.swift
//  Karma
//
//  Created by macbook on 31/01/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//

import Foundation
import Alamofire

class ErrorBody: Codable {
    let code: Int?
    let message, path: String?
    let additional: String?
    let timestamp: Int?
    
    init(code: Int?, message: String?, path: String?, additional: String?, timestamp: Int?) {
        self.code = code
        self.message = message
        self.path = path
        self.additional = additional
        self.timestamp = timestamp
    }
}

// MARK: Convenience initializers and mutators

extension ErrorBody {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(ErrorBody.self, from: data)
        self.init(code: me.code, message: me.message, path: me.path, additional: me.additional, timestamp: me.timestamp)
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
        code: Int?,
        message: String?,
        path: String?,
        additional: String?,
        timestamp: Int?
        ) -> ErrorBody {
        return ErrorBody(
            code: code ?? self.code,
            message: message ?? self.message,
            path: path ?? self.path,
            additional: additional ?? self.additional,
            timestamp: timestamp ?? self.timestamp
        )
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
    func responseErrorBody(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<ErrorBody>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
