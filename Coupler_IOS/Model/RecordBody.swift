
import Foundation

// MARK: - RecordsBodyElement
class RecordsBody: Codable {
    let content: [ContentRB]?
    let pageable: Pageable?
    let totalPages, totalElements: Int?
    let last, first: Bool?
    let sort: Sort?
    let numberOfElements, size, number: Int?
    let empty: Bool?
    
    init(content: [ContentRB]?, pageable: Pageable?, totalPages: Int?, totalElements: Int?, last: Bool?, first: Bool?, sort: Sort?, numberOfElements: Int?, size: Int?, number: Int?, empty: Bool?) {
        self.content = content
        self.pageable = pageable
        self.totalPages = totalPages
        self.totalElements = totalElements
        self.last = last
        self.first = first
        self.sort = sort
        self.numberOfElements = numberOfElements
        self.size = size
        self.number = number
        self.empty = empty
    }
}

// MARK: - Pageable
class Pageable: Codable {
    let sort: Sort?
    let pageSize, pageNumber, offset: Int?
    let paged, unpaged: Bool?
    
    init(sort: Sort?, pageSize: Int?, pageNumber: Int?, offset: Int?, paged: Bool?, unpaged: Bool?) {
        self.sort = sort
        self.pageSize = pageSize
        self.pageNumber = pageNumber
        self.offset = offset
        self.paged = paged
        self.unpaged = unpaged
    }
}

// MARK: Pageable convenience initializers and mutators

extension Pageable {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Pageable.self, from: data)
        self.init(sort: me.sort, pageSize: me.pageSize, pageNumber: me.pageNumber, offset: me.offset, paged: me.paged, unpaged: me.unpaged)
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
        sort: Sort?? = nil,
        pageSize: Int?? = nil,
        pageNumber: Int?? = nil,
        offset: Int?? = nil,
        paged: Bool?? = nil,
        unpaged: Bool?? = nil
        ) -> Pageable {
        return Pageable(
            sort: sort ?? self.sort,
            pageSize: pageSize ?? self.pageSize,
            pageNumber: pageNumber ?? self.pageNumber,
            offset: offset ?? self.offset,
            paged: paged ?? self.paged,
            unpaged: unpaged ?? self.unpaged
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Sort
class Sort: Codable {
    let unsorted, sorted, empty: Bool?
    
    init(unsorted: Bool?, sorted: Bool?, empty: Bool?) {
        self.unsorted = unsorted
        self.sorted = sorted
        self.empty = empty
    }
}

// MARK: Sort convenience initializers and mutators

extension Sort {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Sort.self, from: data)
        self.init(unsorted: me.unsorted, sorted: me.sorted, empty: me.empty)
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
        unsorted: Bool?? = nil,
        sorted: Bool?? = nil,
        empty: Bool?? = nil
        ) -> Sort {
        return Sort(
            unsorted: unsorted ?? self.unsorted,
            sorted: sorted ?? self.sorted,
            empty: empty ?? self.empty
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: RecordsBody convenience initializers and mutators

extension RecordsBody {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(RecordsBody.self, from: data)
        self.init(content: me.content, pageable: me.pageable, totalPages: me.totalPages, totalElements: me.totalElements, last: me.last, first: me.first, sort: me.sort, numberOfElements: me.numberOfElements, size: me.size, number: me.number, empty: me.empty)
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
        content: [ContentRB]?? = nil,
        pageable: Pageable?? = nil,
        totalPages: Int?? = nil,
        totalElements: Int?? = nil,
        last: Bool?? = nil,
        first: Bool?? = nil,
        sort: Sort?? = nil,
        numberOfElements: Int?? = nil,
        size: Int?? = nil,
        number: Int?? = nil,
        empty: Bool?? = nil
        ) -> RecordsBody {
        return RecordsBody(
            content: content ?? self.content,
            pageable: pageable ?? self.pageable,
            totalPages: totalPages ?? self.totalPages,
            totalElements: totalElements ?? self.totalElements,
            last: last ?? self.last,
            first: first ?? self.first,
            sort: sort ?? self.sort,
            numberOfElements: numberOfElements ?? self.numberOfElements,
            size: size ?? self.size,
            number: number ?? self.number,
            empty: empty ?? self.empty
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
class ContentRB: Codable {
    let id, clientID, targetID: String?
    let packageID: String?
    let businessID: String?
    let price, begin, finish: Int?
    let recordsBodyDescription: String?
    let packageDto: PackageDto?
    let business: Business?
    let statusPay: String?
    let payType: String?
    let statusProcess: String?
    let statusRecord: String?
    let businessCategoryID: String?
    let notificationSend: Bool?
    let services: [ServiceElementRBE?]?
    let servicesIDS: [JSONAny]?
    let workingSpaceID: String?
    let workerID: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case clientID = "clientId"
        case targetID = "targetId"
        case packageID = "packageId"
        case businessID = "businessId"
        case price, begin, finish
        case recordsBodyDescription = "description"
        case packageDto, business, statusPay, payType, statusProcess, statusRecord
        case businessCategoryID = "businessCategoryId"
        case notificationSend, services
        case servicesIDS = "servicesIds"
        case workingSpaceID = "workingSpaceId"
        case workerID = "workerId"
    }
    
    init(id: String?, clientID: String?, targetID: String?, packageID: String?, businessID: String?, price: Int?, begin: Int?, finish: Int?, recordsBodyDescription: String?, packageDto: PackageDto?, business: Business?, statusPay: String?, payType: String?, statusProcess: String?, statusRecord: String?, businessCategoryID: String?, notificationSend: Bool?, services: [ServiceElementRBE?]?, servicesIDS: [JSONAny]?, workingSpaceID: String?, workerID: String?) {
        self.id = id
        self.clientID = clientID
        self.targetID = targetID
        self.packageID = packageID
        self.businessID = businessID
        self.price = price
        self.begin = begin
        self.finish = finish
        self.recordsBodyDescription = recordsBodyDescription
        self.packageDto = packageDto
        self.business = business
        self.statusPay = statusPay
        self.payType = payType
        self.statusProcess = statusProcess
        self.statusRecord = statusRecord
        self.businessCategoryID = businessCategoryID
        self.notificationSend = notificationSend
        self.services = services
        self.servicesIDS = servicesIDS
        self.workingSpaceID = workingSpaceID
        self.workerID = workerID
    }
}

// MARK: RecordsBodyElement convenience initializers and mutators

extension ContentRB {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(ContentRB.self, from: data)
        self.init(id: me.id, clientID: me.clientID, targetID: me.targetID, packageID: me.packageID, businessID: me.businessID, price: me.price, begin: me.begin, finish: me.finish, recordsBodyDescription: me.recordsBodyDescription, packageDto: me.packageDto, business: me.business, statusPay: me.statusPay, payType: me.payType, statusProcess: me.statusProcess, statusRecord: me.statusRecord, businessCategoryID: me.businessCategoryID, notificationSend: me.notificationSend, services: me.services, servicesIDS: me.servicesIDS, workingSpaceID: me.workingSpaceID, workerID: me.workerID)
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
        clientID: String?? = nil,
        targetID: String?? = nil,
        packageID: String?? = nil,
        businessID: String?? = nil,
        price: Int?? = nil,
        begin: Int?? = nil,
        finish: Int?? = nil,
        recordsBodyDescription: String?? = nil,
        packageDto: PackageDto?? = nil,
        business: Business?? = nil,
        statusPay: String?? = nil,
        payType: String?? = nil,
        statusProcess: String?? = nil,
        statusRecord: String?? = nil,
        businessCategoryID: String?? = nil,
        notificationSend: Bool?? = nil,
        services: [ServiceElementRBE?]?,
        servicesIDS: [JSONAny]?? = nil,
        workingSpaceID: String?? = nil,
        workerID: String?? = nil,
        client: String?? = nil
        ) -> ContentRB {
        return ContentRB(
            id: id ?? self.id,
            clientID: clientID ?? self.clientID,
            targetID: targetID ?? self.targetID,
            packageID: packageID ?? self.packageID,
            businessID: businessID ?? self.businessID,
            price: price ?? self.price,
            begin: begin ?? self.begin,
            finish: finish ?? self.finish,
            recordsBodyDescription: recordsBodyDescription ?? self.recordsBodyDescription,
            packageDto: packageDto ?? self.packageDto,
            business: business ?? self.business,
            statusPay: statusPay ?? self.statusPay,
            payType: payType ?? self.payType,
            statusProcess: statusProcess ?? self.statusProcess,
            statusRecord: statusRecord ?? self.statusRecord,
            businessCategoryID: businessCategoryID ?? self.businessCategoryID,
            notificationSend: notificationSend ?? self.notificationSend,
            services: services ?? self.services,
            servicesIDS: servicesIDS ?? self.servicesIDS,
            workingSpaceID: workingSpaceID ?? self.workingSpaceID,
            workerID: workerID ?? self.workerID
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Business
class Business: Codable {
    let id, corporationID: String?
    let name: String?
    let businessDescription: String?
    let logoURL: String?
    let address, phone: String?
    let addPhone: String?
    let latitude, longitude: Double?
    let timeZone: Int?
    let businessCategoryID: String?
    let businessCategory: BusinessCategory?
    let objectState: String?
    let workTimes: [WorkTime]?
    let spaces: [Space]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case corporationID = "corporationId"
        case name
        case businessDescription = "description"
        case logoURL = "logoUrl"
        case address, phone, addPhone, latitude, longitude, timeZone
        case businessCategoryID = "businessCategoryId"
        case businessCategory, objectState, workTimes, spaces
    }
    
    init(id: String?, corporationID: String?, name: String?, businessDescription: String?, logoURL: String?, address: String?, phone: String?, addPhone: String?, latitude: Double?, longitude: Double?, timeZone: Int?, businessCategoryID: String?, businessCategory: BusinessCategory?, objectState: String?, workTimes: [WorkTime]?, spaces: [Space]?) {
        self.id = id
        self.corporationID = corporationID
        self.name = name
        self.businessDescription = businessDescription
        self.logoURL = logoURL
        self.address = address
        self.phone = phone
        self.addPhone = addPhone
        self.latitude = latitude
        self.longitude = longitude
        self.timeZone = timeZone
        self.businessCategoryID = businessCategoryID
        self.businessCategory = businessCategory
        self.objectState = objectState
        self.workTimes = workTimes
        self.spaces = spaces
    }
}

// MARK: Business convenience initializers and mutators

extension Business {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Business.self, from: data)
        self.init(id: me.id, corporationID: me.corporationID, name: me.name, businessDescription: me.businessDescription, logoURL: me.logoURL, address: me.address, phone: me.phone, addPhone: me.addPhone, latitude: me.latitude, longitude: me.longitude, timeZone: me.timeZone, businessCategoryID: me.businessCategoryID, businessCategory: me.businessCategory, objectState: me.objectState, workTimes: me.workTimes, spaces: me.spaces)
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
        corporationID: String?? = nil,
        name: String?? = nil,
        businessDescription: String?? = nil,
        logoURL: String?? = nil,
        address: String?? = nil,
        phone: String?? = nil,
        addPhone: String?? = nil,
        latitude: Double?? = nil,
        longitude: Double?? = nil,
        timeZone: Int?? = nil,
        businessCategoryID: String?? = nil,
        businessCategory: BusinessCategory?? = nil,
        objectState: String?? = nil,
        workTimes: [WorkTime]?? = nil,
        spaces: [Space]?? = nil
        ) -> Business {
        return Business(
            id: id ?? self.id,
            corporationID: corporationID ?? self.corporationID,
            name: name ?? self.name,
            businessDescription: businessDescription ?? self.businessDescription,
            logoURL: logoURL ?? self.logoURL,
            address: address ?? self.address,
            phone: phone ?? self.phone,
            addPhone: addPhone ?? self.addPhone,
            latitude: latitude ?? self.latitude,
            longitude: longitude ?? self.longitude,
            timeZone: timeZone ?? self.timeZone,
            businessCategoryID: businessCategoryID ?? self.businessCategoryID,
            businessCategory: businessCategory ?? self.businessCategory,
            objectState: objectState ?? self.objectState,
            workTimes: workTimes ?? self.workTimes,
            spaces: spaces ?? self.spaces
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
class BusinessCategory: Codable {
    let id: String?
    let code: String?
    let name: String?
    let businessCategoryDescription: String?
    let imageURL: String?
    let businessType: String?
    let active: Bool?
    let orderIndex: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, code, name
        case businessCategoryDescription = "description"
        case imageURL = "imageUrl"
        case businessType, active, orderIndex
    }
    
    init(id: String?, code: String?, name: String?, businessCategoryDescription: String?, imageURL: String?, businessType: String?, active: Bool?, orderIndex: Int?) {
        self.id = id
        self.code = code
        self.name = name
        self.businessCategoryDescription = businessCategoryDescription
        self.imageURL = imageURL
        self.businessType = businessType
        self.active = active
        self.orderIndex = orderIndex
    }
}

// MARK: - BusinessCategory
//class BusinessCategory: Codable {
//    let id: String?
//    let code: Code?
//    let name: BusinessCategoryName?
//    let businessCategoryDescription: BusinessCategoryDescription?
//    let imageURL: JSONNull?
//    let businessType: BusinessType?
//    let active: Bool?
//    let orderIndex: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id, code, name
//        case businessCategoryDescription = "description"
//        case imageURL = "imageUrl"
//        case businessType, active, orderIndex
//    }
//
//    init(id: String?, code: Code?, name: BusinessCategoryName?, businessCategoryDescription: BusinessCategoryDescription?, imageURL: JSONNull?, businessType: BusinessType?, active: Bool?, orderIndex: Int?) {
//        self.id = id
//        self.code = code
//        self.name = name
//        self.businessCategoryDescription = businessCategoryDescription
//        self.imageURL = imageURL
//        self.businessType = businessType
//        self.active = active
//        self.orderIndex = orderIndex
//    }
//}
//
//// MARK: BusinessCategory convenience initializers and mutators
//
//extension BusinessCategory {
//    convenience init(data: Data) throws {
//        let me = try newJSONDecoder().decode(BusinessCategory.self, from: data)
//        self.init(id: me.id, code: me.code, name: me.name, businessCategoryDescription: me.businessCategoryDescription, imageURL: me.imageURL, businessType: me.businessType, active: me.active, orderIndex: me.orderIndex)
//    }
//
//    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//        guard let data = json.data(using: encoding) else {
//            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//        }
//        try self.init(data: data)
//    }
//
//    convenience init(fromURL url: URL) throws {
//        try self.init(data: try Data(contentsOf: url))
//    }
//
//    func with(
//        id: String?? = nil,
//        code: Code?? = nil,
//        name: BusinessCategoryName?? = nil,
//        businessCategoryDescription: BusinessCategoryDescription?? = nil,
//        imageURL: JSONNull?? = nil,
//        businessType: BusinessType?? = nil,
//        active: Bool?? = nil,
//        orderIndex: Int?? = nil
//        ) -> BusinessCategory {
//        return BusinessCategory(
//            id: id ?? self.id,
//            code: code ?? self.code,
//            name: name ?? self.name,
//            businessCategoryDescription: businessCategoryDescription ?? self.businessCategoryDescription,
//            imageURL: imageURL ?? self.imageURL,
//            businessType: businessType ?? self.businessType,
//            active: active ?? self.active,
//            orderIndex: orderIndex ?? self.orderIndex
//        )
//    }
//
//    func jsonData() throws -> Data {
//        return try newJSONEncoder().encode(self)
//    }
//
//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
//}
//
//enum BusinessCategoryDescription: String, Codable {
//    case мойкаАвтомобилей = "Мойка автомобилей"
//}
//
//enum BusinessType: String, Codable {
//    case car = "CAR"
//}
//
//enum Code: String, Codable {
//    case carWash = "CAR_WASH"
//}
//
//enum BusinessCategoryName: String, Codable {
//    case мойки = "Мойки"
//}
//
//enum BusinessName: String, Codable {
//    case мойка101 = "Мойка #101"
//    case мойка130 = "Мойка #130"
//    case мойка2 = "Мойка #2"
//}
//
//enum ObjectState: String, Codable {
//    case active = "ACTIVE"
//}

//// MARK: - Space
//class Space: Codable {
//    let id: String?
//    let name: SpaceName?
//    let spaceDescription: JSONNull?
//    let indexNumber: Int?
//    let businessID: String?
//    let statusSpace: StatusSpace?
//    let businessCategoryID: String?
//    let workers: [Worker]?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case spaceDescription = "description"
//        case indexNumber
//        case businessID = "businessId"
//        case statusSpace
//        case businessCategoryID = "businessCategoryId"
//        case workers
//    }
//
//    init(id: String?, name: SpaceName?, spaceDescription: JSONNull?, indexNumber: Int?, businessID: String?, statusSpace: StatusSpace?, businessCategoryID: String?, workers: [Worker]?) {
//        self.id = id
//        self.name = name
//        self.spaceDescription = spaceDescription
//        self.indexNumber = indexNumber
//        self.businessID = businessID
//        self.statusSpace = statusSpace
//        self.businessCategoryID = businessCategoryID
//        self.workers = workers
//    }
//}
//
//// MARK: Space convenience initializers and mutators
//
//extension Space {
//    convenience init(data: Data) throws {
//        let me = try newJSONDecoder().decode(Space.self, from: data)
//        self.init(id: me.id, name: me.name, spaceDescription: me.spaceDescription, indexNumber: me.indexNumber, businessID: me.businessID, statusSpace: me.statusSpace, businessCategoryID: me.businessCategoryID, workers: me.workers)
//    }
//
//    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//        guard let data = json.data(using: encoding) else {
//            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//        }
//        try self.init(data: data)
//    }
//
//    convenience init(fromURL url: URL) throws {
//        try self.init(data: try Data(contentsOf: url))
//    }
//
//    func with(
//        id: String?? = nil,
//        name: SpaceName?? = nil,
//        spaceDescription: JSONNull?? = nil,
//        indexNumber: Int?? = nil,
//        businessID: String?? = nil,
//        statusSpace: StatusSpace?? = nil,
//        businessCategoryID: String?? = nil,
//        workers: [Worker]?? = nil
//        ) -> Space {
//        return Space(
//            id: id ?? self.id,
//            name: name ?? self.name,
//            spaceDescription: spaceDescription ?? self.spaceDescription,
//            indexNumber: indexNumber ?? self.indexNumber,
//            businessID: businessID ?? self.businessID,
//            statusSpace: statusSpace ?? self.statusSpace,
//            businessCategoryID: businessCategoryID ?? self.businessCategoryID,
//            workers: workers ?? self.workers
//        )
//    }
//
//    func jsonData() throws -> Data {
//        return try newJSONEncoder().encode(self)
//    }
//
//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
//}
//
//enum SpaceName: String, Codable {
//    case workingSpace1 = "Working space #1"
//    case workingSpace2 = "Working space #2"
//    case workingSpace3 = "Working space #3"
//    case workingSpace4 = "Working space #4"
//    case workingSpace5 = "Working space #5"
//}
//
//enum StatusSpace: String, Codable {
//    case free = "FREE"
//}
//
//// MARK: - Worker
//class Worker: Codable {
//    let id, userID: String?
//    let position: Position?
//    let workingSpaceID, businessID: String?
//    let user: JSONNull?
//    let workTimes: [JSONAny]?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case userID = "userId"
//        case position
//        case workingSpaceID = "workingSpaceId"
//        case businessID = "businessId"
//        case user, workTimes
//    }
//
//    init(id: String?, userID: String?, position: Position?, workingSpaceID: String?, businessID: String?, user: JSONNull?, workTimes: [JSONAny]?) {
//        self.id = id
//        self.userID = userID
//        self.position = position
//        self.workingSpaceID = workingSpaceID
//        self.businessID = businessID
//        self.user = user
//        self.workTimes = workTimes
//    }
//}
//
//// MARK: Worker convenience initializers and mutators
//
//extension Worker {
//    convenience init(data: Data) throws {
//        let me = try newJSONDecoder().decode(Worker.self, from: data)
//        self.init(id: me.id, userID: me.userID, position: me.position, workingSpaceID: me.workingSpaceID, businessID: me.businessID, user: me.user, workTimes: me.workTimes)
//    }
//
//    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//        guard let data = json.data(using: encoding) else {
//            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//        }
//        try self.init(data: data)
//    }
//
//    convenience init(fromURL url: URL) throws {
//        try self.init(data: try Data(contentsOf: url))
//    }
//
//    func with(
//        id: String?? = nil,
//        userID: String?? = nil,
//        position: Position?? = nil,
//        workingSpaceID: String?? = nil,
//        businessID: String?? = nil,
//        user: JSONNull?? = nil,
//        workTimes: [JSONAny]?? = nil
//        ) -> Worker {
//        return Worker(
//            id: id ?? self.id,
//            userID: userID ?? self.userID,
//            position: position ?? self.position,
//            workingSpaceID: workingSpaceID ?? self.workingSpaceID,
//            businessID: businessID ?? self.businessID,
//            user: user ?? self.user,
//            workTimes: workTimes ?? self.workTimes
//        )
//    }
//
//    func jsonData() throws -> Data {
//        return try newJSONEncoder().encode(self)
//    }
//
//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
//}
//
//enum Position: String, Codable {
//    case воркер = "Воркер"
//}
//
//// MARK: - WorkTime
//class WorkTime: Codable {
//    let id: String?
//    let from, to: Int?
//    let objectID: String?
//    let isWork: Bool?
//    let businessCategoryID: String?
//    let dayOfWeek: DayOfWeek?
//
//    enum CodingKeys: String, CodingKey {
//        case id, from, to
//        case objectID = "objectId"
//        case isWork
//        case businessCategoryID = "businessCategoryId"
//        case dayOfWeek
//    }
//
//    init(id: String?, from: Int?, to: Int?, objectID: String?, isWork: Bool?, businessCategoryID: String?, dayOfWeek: DayOfWeek?) {
//        self.id = id
//        self.from = from
//        self.to = to
//        self.objectID = objectID
//        self.isWork = isWork
//        self.businessCategoryID = businessCategoryID
//        self.dayOfWeek = dayOfWeek
//    }
//}
//
//// MARK: WorkTime convenience initializers and mutators
//
//extension WorkTime {
//    convenience init(data: Data) throws {
//        let me = try newJSONDecoder().decode(WorkTime.self, from: data)
//        self.init(id: me.id, from: me.from, to: me.to, objectID: me.objectID, isWork: me.isWork, businessCategoryID: me.businessCategoryID, dayOfWeek: me.dayOfWeek)
//    }
//
//    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//        guard let data = json.data(using: encoding) else {
//            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//        }
//        try self.init(data: data)
//    }
//
//    convenience init(fromURL url: URL) throws {
//        try self.init(data: try Data(contentsOf: url))
//    }
//
//    func with(
//        id: String?? = nil,
//        from: Int?? = nil,
//        to: Int?? = nil,
//        objectID: String?? = nil,
//        isWork: Bool?? = nil,
//        businessCategoryID: String?? = nil,
//        dayOfWeek: DayOfWeek?? = nil
//        ) -> WorkTime {
//        return WorkTime(
//            id: id ?? self.id,
//            from: from ?? self.from,
//            to: to ?? self.to,
//            objectID: objectID ?? self.objectID,
//            isWork: isWork ?? self.isWork,
//            businessCategoryID: businessCategoryID ?? self.businessCategoryID,
//            dayOfWeek: dayOfWeek ?? self.dayOfWeek
//        )
//    }
//
//    func jsonData() throws -> Data {
//        return try newJSONEncoder().encode(self)
//    }
//
//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
//}
//
//enum DayOfWeek: String, Codable {
//    case friday = "FRIDAY"
//    case monday = "MONDAY"
//    case saturday = "SATURDAY"
//    case sunday = "SUNDAY"
//    case thursday = "THURSDAY"
//    case tuesday = "TUESDAY"
//    case wednesday = "WEDNESDAY"
//}
//
//// MARK: - PackageDto
//class PackageDto: Codable {
//    let id: String?
//    let name: PackageDtoName?
//    let discount, duration: Int?
//    let businessID: String?
//    let objectState: ObjectState?
//    let servicesIDS: [JSONAny]?
//    let services: [ServiceElement]?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, discount, duration
//        case businessID = "businessId"
//        case objectState
//        case servicesIDS = "servicesIds"
//        case services
//    }
//
//    init(id: String?, name: PackageDtoName?, discount: Int?, duration: Int?, businessID: String?, objectState: ObjectState?, servicesIDS: [JSONAny]?, services: [ServiceElement]?) {
//        self.id = id
//        self.name = name
//        self.discount = discount
//        self.duration = duration
//        self.businessID = businessID
//        self.objectState = objectState
//        self.servicesIDS = servicesIDS
//        self.services = services
//    }
//}
//
//// MARK: PackageDto convenience initializers and mutators
//
//extension PackageDto {
//    convenience init(data: Data) throws {
//        let me = try newJSONDecoder().decode(PackageDto.self, from: data)
//        self.init(id: me.id, name: me.name, discount: me.discount, duration: me.duration, businessID: me.businessID, objectState: me.objectState, servicesIDS: me.servicesIDS, services: me.services)
//    }
//
//    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//        guard let data = json.data(using: encoding) else {
//            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//        }
//        try self.init(data: data)
//    }
//
//    convenience init(fromURL url: URL) throws {
//        try self.init(data: try Data(contentsOf: url))
//    }
//
//    func with(
//        id: String?? = nil,
//        name: PackageDtoName?? = nil,
//        discount: Int?? = nil,
//        duration: Int?? = nil,
//        businessID: String?? = nil,
//        objectState: ObjectState?? = nil,
//        servicesIDS: [JSONAny]?? = nil,
//        services: [ServiceElement]?? = nil
//        ) -> PackageDto {
//        return PackageDto(
//            id: id ?? self.id,
//            name: name ?? self.name,
//            discount: discount ?? self.discount,
//            duration: duration ?? self.duration,
//            businessID: businessID ?? self.businessID,
//            objectState: objectState ?? self.objectState,
//            servicesIDS: servicesIDS ?? self.servicesIDS,
//            services: services ?? self.services
//        )
//    }
//
//    func jsonData() throws -> Data {
//        return try newJSONEncoder().encode(self)
//    }
//
//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
//}
//
//enum PackageDtoName: String, Codable {
//    case package1 = "Package #1"
//    case package2 = "Package #2"
//}
//
// MARK: - ServiceElement
class ServiceElementRBE: Codable {
    let id, name: String?
    let serviceDescription: String?
    let price: Int?
    let serviceID, businessID: String?
    let service: ServiceService?
    let objectState: String?
    let duration: Int?
    let serviceClass, attributes: [JSONAny]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case serviceDescription = "description"
        case price
        case serviceID = "serviceId"
        case businessID = "businessId"
        case service, objectState, duration, serviceClass, attributes
    }

    init(id: String?, name: String?, serviceDescription: String?, price: Int?, serviceID: String?, businessID: String?, service: ServiceService?, objectState: String?, duration: Int?, serviceClass: [JSONAny]?, attributes: [JSONAny]?) {
        self.id = id
        self.name = name
        self.serviceDescription = serviceDescription
        self.price = price
        self.serviceID = serviceID
        self.businessID = businessID
        self.service = service
        self.objectState = objectState
        self.duration = duration
        self.serviceClass = serviceClass
        self.attributes = attributes
    }
}

// MARK: ServiceElement convenience initializers and mutators

extension ServiceElementRBE {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(ServiceElementRBE.self, from: data)
        self.init(id: me.id, name: me.name, serviceDescription: me.serviceDescription, price: me.price, serviceID: me.serviceID, businessID: me.businessID, service: me.service, objectState: me.objectState, duration: me.duration, serviceClass: me.serviceClass, attributes: me.attributes)
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
        name: String?? = nil,
        serviceDescription: String?? = nil,
        price: Int?? = nil,
        serviceID: String?? = nil,
        businessID: String?? = nil,
        service: ServiceService?? = nil,
        objectState: String?? = nil,
        duration: Int?? = nil,
        serviceClass: [JSONAny]?? = nil,
        attributes: [JSONAny]?? = nil
        ) -> ServiceElementRBE {
        return ServiceElementRBE(
            id: id ?? self.id,
            name: name ?? self.name,
            serviceDescription: serviceDescription ?? self.serviceDescription,
            price: price ?? self.price,
            serviceID: serviceID ?? self.serviceID,
            businessID: businessID ?? self.businessID,
            service: service ?? self.service,
            objectState: objectState ?? self.objectState,
            duration: duration ?? self.duration,
            serviceClass: serviceClass ?? self.serviceClass,
            attributes: attributes ?? self.attributes
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - ServiceService
class ServiceService: Codable {
    let id, name, serviceDescription, businessCategoryID: String?
    let objectState: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case serviceDescription = "description"
        case businessCategoryID = "businessCategoryId"
        case objectState
    }
    
    init(id: String?, name: String?, serviceDescription: String?, businessCategoryID: String?, objectState: String?) {
        self.id = id
        self.name = name
        self.serviceDescription = serviceDescription
        self.businessCategoryID = businessCategoryID
        self.objectState = objectState
    }
}

// MARK: ServiceService convenience initializers and mutators

extension ServiceService {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(ServiceService.self, from: data)
        self.init(id: me.id, name: me.name, serviceDescription: me.serviceDescription, businessCategoryID: me.businessCategoryID, objectState: me.objectState)
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
        name: String?? = nil,
        serviceDescription: String?? = nil,
        businessCategoryID: String?? = nil,
        objectState: String?? = nil
        ) -> ServiceService {
        return ServiceService(
            id: id ?? self.id,
            name: name ?? self.name,
            serviceDescription: serviceDescription ?? self.serviceDescription,
            businessCategoryID: businessCategoryID ?? self.businessCategoryID,
            objectState: objectState ?? self.objectState
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
//
//enum PayType: String, Codable {
//    case cash = "CASH"
//}
//
//enum RecordsBodyDescription: String, Codable {
//    case android = "Android"
//    case ios = "IOS"
//}
//
//enum StatusPay: String, Codable {
//    case notPaid = "NOT_PAID"
//}
//
//enum StatusProcess: String, Codable {
//    case completed = "COMPLETED"
//    case inProcess = "IN_PROCESS"
//    case waiting = "WAITING"
//}
//
//enum StatusRecord: String, Codable {
//    case completed = "COMPLETED"
//    case created = "CREATED"
//}

//typealias RecordsBody = [ContentRB]
//
//extension Array where Element == RecordsBody.Element {
//    init(data: Data) throws {
//        self = try newJSONDecoder().decode(RecordsBody.self, from: data)
//    }
//
//    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//        guard let data = json.data(using: encoding) else {
//            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//        }
//        try self.init(data: data)
//    }
//
//    init(fromURL url: URL) throws {
//        try self.init(data: try Data(contentsOf: url))
//    }
//
//    func jsonData() throws -> Data {
//        return try newJSONEncoder().encode(self)
//    }
//
//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
//}
