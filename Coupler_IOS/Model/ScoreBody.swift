// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let scoreBody = try ScoreBody(json)

import Foundation

// MARK: - ScoreBody
class ScoreBody: Codable {
    let id, userID: String?
    let score, createDate, updateDate: String?
    let history: [JSONAny]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case score, createDate, updateDate, history
    }
    
    init(id: String?, userID: String?, score: String?, createDate: String?, updateDate: String?, history: [JSONAny]?) {
        self.id = id
        self.userID = userID
        self.score = score
        self.createDate = createDate
        self.updateDate = updateDate
        self.history = history
    }
}

// MARK: ScoreBody convenience initializers and mutators

extension ScoreBody {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(ScoreBody.self, from: data)
        self.init(id: me.id, userID: me.userID, score: me.score, createDate: me.createDate, updateDate: me.updateDate, history: me.history)
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
        score: String?? = nil,
        createDate: String?? = nil,
        updateDate: String?? = nil,
        history: [JSONAny]?? = nil
        ) -> ScoreBody {
        return ScoreBody(
            id: id ?? self.id,
            userID: userID ?? self.userID,
            score: score ?? self.score,
            createDate: createDate ?? self.createDate,
            updateDate: updateDate ?? self.updateDate,
            history: history ?? self.history
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
