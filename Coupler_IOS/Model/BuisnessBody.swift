// To parse the JSON, add this file to your project and do:
//
//   let buisnessBody = try BuisnessBody(json)

import Foundation

// MARK: - BuisnessBodyElement
struct BuisnessBodyElement: Codable {
    let active: Bool?
    let id, code: String?
    let descriptions: Descriptions?
    let imageURL: String?
    let orderIndex: Int?
    let businessType, buisnessBodyDescription, name: String?
    
    enum CodingKeys: String, CodingKey {
        case active, id, code, descriptions
        case imageURL = "imageUrl"
        case orderIndex, businessType
        case buisnessBodyDescription = "description"
        case name
    }
}

// MARK: - Descriptions
struct Descriptions: Codable {
    let en, ru, uk, he: En?
}

// MARK: - En
struct En: Codable {
    let id, objectID: String?
    let languageCode: LanguageCode?
    let name, enDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case objectID = "objectId"
        case languageCode, name
        case enDescription = "description"
    }
}

enum LanguageCode: String, Codable {
    case en = "en"
    case ru = "ru"
    case uk = "uk"
    case he = "he"
}

typealias BuisnessBody = [BuisnessBodyElement]
