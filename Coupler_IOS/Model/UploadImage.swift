// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let uploadImage = try UploadImage(json)

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseUploadImage { response in
//     if let uploadImage = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - UploadImage
class UploadImage: Codable {
    let url: String?
    let mediaType, userID, id: String?
    let uploadImageOpen: Bool?
    let crypto: JSONNull?
    let size: Int?
    let keys: JSONNull?
    let filename: String?
    let readerIDS: JSONNull?
    let originalFilename: String?
    
    enum CodingKeys: String, CodingKey {
        case url, mediaType
        case userID = "userId"
        case id
        case uploadImageOpen = "open"
        case crypto, size, keys, filename
        case readerIDS = "readerIds"
        case originalFilename
    }
    
    init(url: String?, mediaType: String?, userID: String?, id: String?, uploadImageOpen: Bool?, crypto: JSONNull?, size: Int?, keys: JSONNull?, filename: String?, readerIDS: JSONNull?, originalFilename: String?) {
        self.url = url
        self.mediaType = mediaType
        self.userID = userID
        self.id = id
        self.uploadImageOpen = uploadImageOpen
        self.crypto = crypto
        self.size = size
        self.keys = keys
        self.filename = filename
        self.readerIDS = readerIDS
        self.originalFilename = originalFilename
    }
}

// MARK: UploadImage convenience initializers and mutators

extension UploadImage {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(UploadImage.self, from: data)
        self.init(url: me.url, mediaType: me.mediaType, userID: me.userID, id: me.id, uploadImageOpen: me.uploadImageOpen, crypto: me.crypto, size: me.size, keys: me.keys, filename: me.filename, readerIDS: me.readerIDS, originalFilename: me.originalFilename)
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
        url: String?? = nil,
        mediaType: String?? = nil,
        userID: String?? = nil,
        id: String?? = nil,
        uploadImageOpen: Bool?? = nil,
        crypto: JSONNull?? = nil,
        size: Int?? = nil,
        keys: JSONNull?? = nil,
        filename: String?? = nil,
        readerIDS: JSONNull?? = nil,
        originalFilename: String?? = nil
        ) -> UploadImage {
        return UploadImage(
            url: url ?? self.url,
            mediaType: mediaType ?? self.mediaType,
            userID: userID ?? self.userID,
            id: id ?? self.id,
            uploadImageOpen: uploadImageOpen ?? self.uploadImageOpen,
            crypto: crypto ?? self.crypto,
            size: size ?? self.size,
            keys: keys ?? self.keys,
            filename: filename ?? self.filename,
            readerIDS: readerIDS ?? self.readerIDS,
            originalFilename: originalFilename ?? self.originalFilename
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
    func responseUploadImage(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<UploadImage>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
