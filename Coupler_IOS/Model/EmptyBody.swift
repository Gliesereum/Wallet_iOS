//
//  EmptyBody.swift
//  Coupler_IOS
//
//  Created by macbook on 16/08/2019.
//  Copyright © 2019 Coupler. All rights reserved.
//

import Foundation


typealias EmptyBody = [JSONAny]

extension Array where Element == EmptyBody.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(EmptyBody.self, from: data)
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
