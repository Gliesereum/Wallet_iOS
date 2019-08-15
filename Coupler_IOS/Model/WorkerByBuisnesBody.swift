//
//  WorkerByBuisnesBody.swift
//  Coupler_IOS
//
//  Created by macbook on 14/08/2019.
//  Copyright © 2019 Coupler. All rights reserved.
//

import Foundation

// MARK: - WorkerByBuisnesBody
class WorkerByBuisnesBody: Codable {
    let content: [Worker]?
    let pageable: Pageable?
    let totalPages, totalElements: Int?
    let last, first: Bool?
    let sort: Sort?
    let numberOfElements, size, number: Int?
    let empty: Bool?
    
    init(content: [Worker]?, pageable: Pageable?, totalPages: Int?, totalElements: Int?, last: Bool?, first: Bool?, sort: Sort?, numberOfElements: Int?, size: Int?, number: Int?, empty: Bool?) {
        self.content = content
        self.pageable = pageable
        self.totalPages = totalPages
        self.totalElements = totalElements
        self.last = last
        self.first = first
        self.sort = sort
        self.numberOfElements = numberOfElements
        self.size = size
        self.number = number
        self.empty = empty
    }
}

// MARK: WorkerByBuisnesBody convenience initializers and mutators

extension WorkerByBuisnesBody {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(WorkerByBuisnesBody.self, from: data)
        self.init(content: me.content, pageable: me.pageable, totalPages: me.totalPages, totalElements: me.totalElements, last: me.last, first: me.first, sort: me.sort, numberOfElements: me.numberOfElements, size: me.size, number: me.number, empty: me.empty)
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
        content: [Worker]?? = nil,
        pageable: Pageable?? = nil,
        totalPages: Int?? = nil,
        totalElements: Int?? = nil,
        last: Bool?? = nil,
        first: Bool?? = nil,
        sort: Sort?? = nil,
        numberOfElements: Int?? = nil,
        size: Int?? = nil,
        number: Int?? = nil,
        empty: Bool?? = nil
        ) -> WorkerByBuisnesBody {
        return WorkerByBuisnesBody(
            content: content ?? self.content,
            pageable: pageable ?? self.pageable,
            totalPages: totalPages ?? self.totalPages,
            totalElements: totalElements ?? self.totalElements,
            last: last ?? self.last,
            first: first ?? self.first,
            sort: sort ?? self.sort,
            numberOfElements: numberOfElements ?? self.numberOfElements,
            size: size ?? self.size,
            number: number ?? self.number,
            empty: empty ?? self.empty
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Content
class Worker: NSObject, Codable {
    let id, userID, position, workingSpaceID: String?
    let businessID, corporationID: String?
    let user: User?
    let rating: Rating?
    let comments: [Comment]?
    let workTimes: [WorkTime]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case position
        case workingSpaceID = "workingSpaceId"
        case businessID = "businessId"
        case corporationID = "corporationId"
        case user, rating, comments, workTimes
    }
    
    init(id: String?, userID: String?, position: String?, workingSpaceID: String?, businessID: String?, corporationID: String?, user: User?, rating: Rating?, comments: [Comment]?, workTimes: [WorkTime]?) {
        self.id = id
        self.userID = userID
        self.position = position
        self.workingSpaceID = workingSpaceID
        self.businessID = businessID
        self.corporationID = corporationID
        self.user = user
        self.rating = rating
        self.comments = comments
        self.workTimes = workTimes
    }
}

// MARK: Content convenience initializers and mutators

extension Worker {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Worker.self, from: data)
        self.init(id: me.id, userID: me.userID, position: me.position, workingSpaceID: me.workingSpaceID, businessID: me.businessID, corporationID: me.corporationID, user: me.user, rating: me.rating, comments: me.comments, workTimes: me.workTimes)
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
        userID: String?? = nil,
        position: String?? = nil,
        workingSpaceID: String?? = nil,
        businessID: String?? = nil,
        corporationID: String?? = nil,
        user: User?? = nil,
        rating: Rating?? = nil,
        comments: [Comment]?? = nil,
        workTimes: [WorkTime]?? = nil
        ) -> Worker {
        return Worker(
            id: id ?? self.id,
            userID: userID ?? self.userID,
            position: position ?? self.position,
            workingSpaceID: workingSpaceID ?? self.workingSpaceID,
            businessID: businessID ?? self.businessID,
            corporationID: corporationID ?? self.corporationID,
            user: user ?? self.user,
            rating: rating ?? self.rating,
            comments: comments ?? self.comments,
            workTimes: workTimes ?? self.workTimes
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
