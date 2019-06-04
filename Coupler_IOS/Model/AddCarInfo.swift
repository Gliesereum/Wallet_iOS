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

class AddCarInfo: Codable {
    let id, brandID, modelID, yearID: String?
    let brand, model, year: String?
    let userID, registrationNumber, description: String?
    let note: String?
    let interior, carBody, colour: String?
    let services: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case brandID = "brandId"
        case modelID = "modelId"
        case yearID = "yearId"
        case brand, model, year
        case userID = "userId"
        case registrationNumber, description, note, interior, carBody, colour, services
    }
    
    init(id: String?, brandID: String?, modelID: String?, yearID: String?, brand: String?, model: String?, year: String?, userID: String?, registrationNumber: String?, description: String?, note: String?, interior: String?, carBody: String?, colour: String?, services: [String]?) {
        self.id = id
        self.brandID = brandID
        self.modelID = modelID
        self.yearID = yearID
        self.brand = brand
        self.model = model
        self.year = year
        self.userID = userID
        self.registrationNumber = registrationNumber
        self.description = description
        self.note = note
        self.interior = interior
        self.carBody = carBody
        self.colour = colour
        self.services = services
    }
}

// MARK: Convenience initializers and mutators

extension AddCarInfo {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(AddCarInfo.self, from: data)
        self.init(id: me.id, brandID: me.brandID, modelID: me.modelID, yearID: me.yearID, brand: me.brand, model: me.model, year: me.year, userID: me.userID, registrationNumber: me.registrationNumber, description: me.description, note: me.note, interior: me.interior, carBody: me.carBody, colour: me.colour, services: me.services)
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
        brandID: String?,
        modelID: String?,
        yearID: String?,
        brand: String?,
        model: String?,
        year: String?,
        userID: String?,
        registrationNumber: String?,
        description: String?,
        note: String?,
        interior: String?,
        carBody: String?,
        colour: String?,
        services: [String]?
        ) -> AddCarInfo {
        return AddCarInfo(
            id: id ?? self.id,
            brandID: brandID ?? self.brandID,
            modelID: modelID ?? self.modelID,
            yearID: yearID ?? self.yearID,
            brand: brand ?? self.brand,
            model: model ?? self.model,
            year: year ?? self.year,
            userID: userID ?? self.userID,
            registrationNumber: registrationNumber ?? self.registrationNumber,
            description: description ?? self.description,
            note: note ?? self.note,
            interior: interior ?? self.interior,
            carBody: carBody ?? self.carBody,
            colour: colour ?? self.colour,
            services: services ?? self.services
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}



class JSONCodingKey: CodingKey {
    let key: String
    
    required init?(intValue: Int) {
        return nil
    }
    
    required init?(stringValue: String) {
        key = stringValue
    }
    
    var intValue: Int? {
        return nil
    }
    
    var stringValue: String {
        return key
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
    func responseAddCarInfo(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<AddCarInfo>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
