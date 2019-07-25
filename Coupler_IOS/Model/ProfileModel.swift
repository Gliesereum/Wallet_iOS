// To parse the JSON, add this file to your project and do:
//
//   let profileModel = try ProfileModel(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseProfileModel { response in
//     if let profileModel = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

class ProfileModel: Codable {
    var id, firstName, lastName, middleName: String?
    var position, country, city, address: String?
    var addAddress, avatarURL, coverURL, gender, phone: String?
    let banStatus, verifiedStatus, userType: String?
    
    enum CodingKeys: String, CodingKey {
        case id, phone, firstName, lastName, middleName, position, country, city, address, addAddress
        case avatarURL = "avatarUrl"
        case coverURL = "coverUrl"
        case gender, banStatus, verifiedStatus, userType
    }
    init(id: String?, phone: String?, firstName: String?, lastName: String?, middleName: String?, position: String?, country: String?, city: String?, address: String?, addAddress: String?, avatarURL: String?, coverURL: String?, gender: String?, banStatus: String?, verifiedStatus: String?, userType: String?) {
        self.id = id
        self.phone = phone
        self.firstName = firstName
        self.lastName = lastName
        self.middleName = middleName
        self.position = position
        self.country = country
        self.city = city
        self.address = address
        self.addAddress = addAddress
        self.avatarURL = avatarURL
        self.coverURL = coverURL
        self.gender = gender
        self.banStatus = banStatus
        self.verifiedStatus = verifiedStatus
        self.userType = userType
    }
}

// MARK: Convenience initializers and mutators

extension ProfileModel {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(ProfileModel.self, from: data)
        self.init(id: me.id, phone: me.phone, firstName: me.firstName, lastName: me.lastName, middleName: me.middleName, position: me.position, country: me.country, city: me.city, address: me.address, addAddress: me.addAddress, avatarURL: me.avatarURL, coverURL: me.coverURL, gender: me.gender, banStatus: me.banStatus, verifiedStatus: me.verifiedStatus, userType: me.userType)
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
        id: String? = nil,
        phone: String?? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        middleName: String? = nil,
        position: String? = nil,
        country: String? = nil,
        city: String? = nil,
        address: String? = nil,
        addAddress: String? = nil,
        avatarURL: String? = nil,
        coverURL: String? = nil,
        gender: String? = nil,
        banStatus: String? = nil,
        verifiedStatus: String? = nil,
        userType: String? = nil
        ) -> ProfileModel {
        return ProfileModel(
            id: id ?? self.id,
            phone: phone ?? self.phone,
            firstName: firstName ?? self.firstName,
            lastName: lastName ?? self.lastName,
            middleName: middleName ?? self.middleName,
            position: position ?? self.position,
            country: country ?? self.country,
            city: city ?? self.city,
            address: address ?? self.address,
            addAddress: addAddress ?? self.addAddress,
            avatarURL: avatarURL ?? self.avatarURL,
            coverURL: coverURL ?? self.coverURL,
            gender: gender ?? self.gender,
            banStatus: banStatus ?? self.banStatus,
            verifiedStatus: verifiedStatus ?? self.verifiedStatus,
            userType: userType ?? self.userType
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
    func responseProfileModel(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<ProfileModel>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
