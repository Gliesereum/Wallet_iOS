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

struct FiltersBodyElement: Codable {
    let id, value, title, businessCategoryID: String?
    let attributes: [AttributeFB]?
    let descriptions: DescriptionsFB?
    
    enum CodingKeys: String, CodingKey {
        case id, value, title
        case businessCategoryID = "businessCategoryId"
        case attributes, descriptions
    }
}

// MARK: - Attribute
struct AttributeFB: Codable {
    let id, value, title, filterID: String?
    let descriptions: DescriptionsFB?
    
    enum CodingKeys: String, CodingKey {
        case id, value, title
        case filterID = "filterId"
        case descriptions
    }
}
struct DescriptionsFB: Codable {
    let ru, en, uk: EnFB?
}
struct EnFB: Codable {
    let id, objectID, title: String?
    let languageCode: LanguageCode?
    
    enum CodingKeys: String, CodingKey {
        case id
        case objectID = "objectId"
        case title, languageCode
    }
}
