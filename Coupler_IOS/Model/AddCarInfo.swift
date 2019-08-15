// To parse the JSON, add this file to your project and do:
//
//   let addCarInfo = try AddCarInfo(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseAddCarInfo { response in
//     if let addCarInfo = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - AddCarInfo
class AddCarInfo: Codable {
    let id, yearID, addCarInfoDescription: String?
    let favorite: Bool?
    let note: JSONNull?
    let registrationNumber: String?
    let brand: Brand?
    let userID, brandID: String?
    let attributes: [JSONAny]?
    let year: Year?
    let services: [JSONAny]?
    let modelID: String?
    let model: Model?
    
    enum CodingKeys: String, CodingKey {
        case id
        case yearID = "yearId"
        case addCarInfoDescription = "description"
        case favorite, note, registrationNumber, brand
        case userID = "userId"
        case brandID = "brandId"
        case attributes, year, services
        case modelID = "modelId"
        case model
    }
    
    init(id: String?, yearID: String?, addCarInfoDescription: String?, favorite: Bool?, note: JSONNull?, registrationNumber: String?, brand: Brand?, userID: String?, brandID: String?, attributes: [JSONAny]?, year: Year?, services: [JSONAny]?, modelID: String?, model: Model?) {
        self.id = id
        self.yearID = yearID
        self.addCarInfoDescription = addCarInfoDescription
        self.favorite = favorite
        self.note = note
        self.registrationNumber = registrationNumber
        self.brand = brand
        self.userID = userID
        self.brandID = brandID
        self.attributes = attributes
        self.year = year
        self.services = services
        self.modelID = modelID
        self.model = model
    }
}

// MARK: AddCarInfo convenience initializers and mutators

extension AddCarInfo {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(AddCarInfo.self, from: data)
        self.init(id: me.id, yearID: me.yearID, addCarInfoDescription: me.addCarInfoDescription, favorite: me.favorite, note: me.note, registrationNumber: me.registrationNumber, brand: me.brand, userID: me.userID, brandID: me.brandID, attributes: me.attributes, year: me.year, services: me.services, modelID: me.modelID, model: me.model)
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
        yearID: String?? = nil,
        addCarInfoDescription: String?? = nil,
        favorite: Bool?? = nil,
        note: JSONNull?? = nil,
        registrationNumber: String?? = nil,
        brand: Brand?? = nil,
        userID: String?? = nil,
        brandID: String?? = nil,
        attributes: [JSONAny]?? = nil,
        year: Year?? = nil,
        services: [JSONAny]?? = nil,
        modelID: String?? = nil,
        model: Model?? = nil
        ) -> AddCarInfo {
        return AddCarInfo(
            id: id ?? self.id,
            yearID: yearID ?? self.yearID,
            addCarInfoDescription: addCarInfoDescription ?? self.addCarInfoDescription,
            favorite: favorite ?? self.favorite,
            note: note ?? self.note,
            registrationNumber: registrationNumber ?? self.registrationNumber,
            brand: brand ?? self.brand,
            userID: userID ?? self.userID,
            brandID: brandID ?? self.brandID,
            attributes: attributes ?? self.attributes,
            year: year ?? self.year,
            services: services ?? self.services,
            modelID: modelID ?? self.modelID,
            model: model ?? self.model
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
