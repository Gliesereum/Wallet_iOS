// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let referralCode = try ReferralCode(json)

import Foundation

// MARK: - ReferralCode
class ReferralCode: Codable {
    let id, userID, code, createDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case code, createDate
    }
    
    init(id: String?, userID: String?, code: String?, createDate: String?) {
        self.id = id
        self.userID = userID
        self.code = code
        self.createDate = createDate
    }
}

// MARK: ReferralCode convenience initializers and mutators

extension ReferralCode {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(ReferralCode.self, from: data)
        self.init(id: me.id, userID: me.userID, code: me.code, createDate: me.createDate)
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
        code: String?? = nil,
        createDate: String?? = nil
        ) -> ReferralCode {
        return ReferralCode(
            id: id ?? self.id,
            userID: userID ?? self.userID,
            code: code ?? self.code,
            createDate: createDate ?? self.createDate
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
