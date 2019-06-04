

import Foundation
import Alamofire

class SigInModel: Codable {
    let user: User?
    let tokenInfo: TokenInfo?
    
    init(user: User?, tokenInfo: TokenInfo?) {
        self.user = user
        self.tokenInfo = tokenInfo
    }
}

class TokenInfo: Codable {
    let accessToken, refreshToken: String?
    let accessExpirationDate, refreshExpirationDate: Int?
    let userID: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken, refreshToken, accessExpirationDate, refreshExpirationDate
        case userID = "userId"
    }
    
    init(accessToken: String?, refreshToken: String?, accessExpirationDate: Int?, refreshExpirationDate: Int?, userID: String?) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.accessExpirationDate = accessExpirationDate
        self.refreshExpirationDate = refreshExpirationDate
        self.userID = userID
    }
}

class User: Codable {
    let id, firstName, lastName, middleName: String?
    let position, country, city, address: String?
    let addAddress, avatarURL, coverURL, gender: String?
    let banStatus, verifiedStatus, userType: String?
    
    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, middleName, position, country, city, address, addAddress
        case avatarURL = "avatarUrl"
        case coverURL = "coverUrl"
        case gender, banStatus, verifiedStatus, userType
    }
    
    init(id: String?, firstName: String?, lastName: String?, middleName: String?, position: String?, country: String?, city: String?, address: String?, addAddress: String?, avatarURL: String?, coverURL: String?, gender: String?, banStatus: String?, verifiedStatus: String?, userType: String?) {
        self.id = id
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

extension SigInModel {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(SigInModel.self, from: data)
        self.init(user: me.user, tokenInfo: me.tokenInfo)
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
        user: User?,
        tokenInfo: TokenInfo?
        ) -> SigInModel {
        return SigInModel(
            user: user ?? self.user,
            tokenInfo: tokenInfo ?? self.tokenInfo
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension TokenInfo {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(TokenInfo.self, from: data)
        self.init(accessToken: me.accessToken, refreshToken: me.refreshToken, accessExpirationDate: me.accessExpirationDate, refreshExpirationDate: me.refreshExpirationDate, userID: me.userID)
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
        accessToken: String?,
        refreshToken: String?,
        accessExpirationDate: Int?,
        refreshExpirationDate: Int?,
        userID: String?
        ) -> TokenInfo {
        return TokenInfo(
            accessToken: accessToken ?? self.accessToken,
            refreshToken: refreshToken ?? self.refreshToken,
            accessExpirationDate: accessExpirationDate ?? self.accessExpirationDate,
            refreshExpirationDate: refreshExpirationDate ?? self.refreshExpirationDate,
            userID: userID ?? self.userID
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension User {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(User.self, from: data)
        self.init(id: me.id, firstName: me.firstName, lastName: me.lastName, middleName: me.middleName, position: me.position, country: me.country, city: me.city, address: me.address, addAddress: me.addAddress, avatarURL: me.avatarURL, coverURL: me.coverURL, gender: me.gender, banStatus: me.banStatus, verifiedStatus: me.verifiedStatus, userType: me.userType)
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
        firstName: String?,
        lastName: String?,
        middleName: String?,
        position: String?,
        country: String?,
        city: String?,
        address: String?,
        addAddress: String?,
        avatarURL: String?,
        coverURL: String?,
        gender: String?,
        banStatus: String?,
        verifiedStatus: String?,
        userType: String?
        ) -> User {
        return User(
            id: id ?? self.id,
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
    func responseSigInModel(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<SigInModel>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
