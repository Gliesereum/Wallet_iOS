// To parse the JSON, add this file to your project and do:
//
//   let filterMarkerBody = try FilterMarkerBody(json)

import Foundation

// MARK: - FilterMarkerBodyElement
struct FilterMarkerBodyElement: Codable {
    let id, businessCategoryID, objectState, name: String?
    let filterMarkerBodyDescription: String?
    let descriptions: Descriptions?
    
    enum CodingKeys: String, CodingKey {
        case id
        case businessCategoryID = "businessCategoryId"
        case objectState, name
        case filterMarkerBodyDescription = "description"
        case descriptions
    }
}


typealias FilterMarkerBody = [FilterMarkerBodyElement]
