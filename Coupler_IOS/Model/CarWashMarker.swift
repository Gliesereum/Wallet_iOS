import Foundation

// MARK: - CarWashMarkerElement
class CarWashMarkerElement: Codable {
    let id, corporationID, name, carWashMarkerDescription: String?
    let logoURL: String?
    let address, phone: String?
    let addPhone: JSONNull?
    let latitude, longitude: Double?
    let timeZone: Int?
    let businessCategoryID: String?
    let businessCategory: BusinessCategory?
    let objectState: ObjectStateCWME?
    let workTimes: [WorkTimeCWME]?
    let spaces: [SpaceCWME]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case corporationID = "corporationId"
        case name
        case carWashMarkerDescription = "description"
        case logoURL = "logoUrl"
        case address, phone, addPhone, latitude, longitude, timeZone
        case businessCategoryID = "businessCategoryId"
        case businessCategory, objectState, workTimes, spaces
    }
    
    init(id: String?, corporationID: String?, name: String?, carWashMarkerDescription: String?, logoURL: String?, address: String?, phone: String?, addPhone: JSONNull?, latitude: Double?, longitude: Double?, timeZone: Int?, businessCategoryID: String?, businessCategory: BusinessCategory?, objectState: ObjectStateCWME?, workTimes: [WorkTimeCWME]?, spaces: [SpaceCWME]?) {
        self.id = id
        self.corporationID = corporationID
        self.name = name
        self.carWashMarkerDescription = carWashMarkerDescription
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

// MARK: CarWashMarkerElement convenience initializers and mutators

extension CarWashMarkerElement {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(CarWashMarkerElement.self, from: data)
        self.init(id: me.id, corporationID: me.corporationID, name: me.name, carWashMarkerDescription: me.carWashMarkerDescription, logoURL: me.logoURL, address: me.address, phone: me.phone, addPhone: me.addPhone, latitude: me.latitude, longitude: me.longitude, timeZone: me.timeZone, businessCategoryID: me.businessCategoryID, businessCategory: me.businessCategory, objectState: me.objectState, workTimes: me.workTimes, spaces: me.spaces)
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
        carWashMarkerDescription: String?? = nil,
        logoURL: String?? = nil,
        address: String?? = nil,
        phone: String?? = nil,
        addPhone: JSONNull?? = nil,
        latitude: Double?? = nil,
        longitude: Double?? = nil,
        timeZone: Int?? = nil,
        businessCategoryID: String?? = nil,
        businessCategory: BusinessCategory?? = nil,
        objectState: ObjectStateCWME?? = nil,
        workTimes: [WorkTimeCWME]?? = nil,
        spaces: [SpaceCWME]?? = nil
        ) -> CarWashMarkerElement {
        return CarWashMarkerElement(
            id: id ?? self.id,
            corporationID: corporationID ?? self.corporationID,
            name: name ?? self.name,
            carWashMarkerDescription: carWashMarkerDescription ?? self.carWashMarkerDescription,
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

// MARK: - BusinessCategory
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

// MARK: BusinessCategory convenience initializers and mutators

extension BusinessCategory {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(BusinessCategory.self, from: data)
        self.init(id: me.id, code: me.code, name: me.name, businessCategoryDescription: me.businessCategoryDescription, imageURL: me.imageURL, businessType: me.businessType, active: me.active, orderIndex: me.orderIndex)
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
        code: String?? = nil,
        name: String?? = nil,
        businessCategoryDescription: String?? = nil,
        imageURL: String?? = nil,
        businessType: String?? = nil,
        active: Bool?? = nil,
        orderIndex: Int?? = nil
        ) -> BusinessCategory {
        return BusinessCategory(
            id: id ?? self.id,
            code: code ?? self.code,
            name: name ?? self.name,
            businessCategoryDescription: businessCategoryDescription ?? self.businessCategoryDescription,
            imageURL: imageURL ?? self.imageURL,
            businessType: businessType ?? self.businessType,
            active: active ?? self.active,
            orderIndex: orderIndex ?? self.orderIndex
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

enum Description: String, Codable {
    case мойкаАвтомобилей = "Мойка автомобилей"
    case станцияТехническогоОбслуживания = "Станция технического обслуживания"
    case шиномонтажДляАвтомобилей = "Шиномонтаж для автомобилей"
}

enum BusinessType: String, Codable {
    case car = "CAR"
}

enum Code: String, Codable {
    case carService = "CAR_SERVICE"
    case carWash = "CAR_WASH"
    case tireFitting = "TIRE_FITTING"
}

enum Name: String, Codable {
    case мойка = "Мойка"
    case сто = "СТО"
    case шиномонтаж = "Шиномонтаж"
}

enum ObjectStateCWME: String, Codable {
    case active = "ACTIVE"
}

// MARK: - Space
class SpaceCWME: Codable {
    let id: String?
    let name: String?
    let spaceDescription: JSONNull?
    let indexNumber: Int?
    let businessID: String?
    let statusSpace: StatusSpace?
    let businessCategoryID: String?
    let workers: [WorkerCWME]?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case spaceDescription = "description"
        case indexNumber
        case businessID = "businessId"
        case statusSpace
        case businessCategoryID = "businessCategoryId"
        case workers
    }
    
    init(id: String?, name: String?, spaceDescription: JSONNull?, indexNumber: Int?, businessID: String?, statusSpace: StatusSpace?, businessCategoryID: String?, workers: [WorkerCWME]?) {
        self.id = id
        self.name = name
        self.spaceDescription = spaceDescription
        self.indexNumber = indexNumber
        self.businessID = businessID
        self.statusSpace = statusSpace
        self.businessCategoryID = businessCategoryID
        self.workers = workers
    }
}

// MARK: Space convenience initializers and mutators

extension SpaceCWME {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(SpaceCWME.self, from: data)
        self.init(id: me.id, name: me.name, spaceDescription: me.spaceDescription, indexNumber: me.indexNumber, businessID: me.businessID, statusSpace: me.statusSpace, businessCategoryID: me.businessCategoryID, workers: me.workers)
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
        spaceDescription: JSONNull?? = nil,
        indexNumber: Int?? = nil,
        businessID: String?? = nil,
        statusSpace: StatusSpace?? = nil,
        businessCategoryID: String?? = nil,
        workers: [WorkerCWME]?? = nil
        ) -> SpaceCWME {
        return SpaceCWME(
            id: id ?? self.id,
            name: name ?? self.name,
            spaceDescription: spaceDescription ?? self.spaceDescription,
            indexNumber: indexNumber ?? self.indexNumber,
            businessID: businessID ?? self.businessID,
            statusSpace: statusSpace ?? self.statusSpace,
            businessCategoryID: businessCategoryID ?? self.businessCategoryID,
            workers: workers ?? self.workers
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

enum StatusSpace: String, Codable {
    case free = "FREE"
}

// MARK: - Worker
class WorkerCWME: Codable {
    let id, userID, position, workingSpaceID: String?
    let businessID: String?
    let user: JSONNull?
    let workTimes: [JSONAny]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case position
        case workingSpaceID = "workingSpaceId"
        case businessID = "businessId"
        case user, workTimes
    }
    
    init(id: String?, userID: String?, position: String?, workingSpaceID: String?, businessID: String?, user: JSONNull?, workTimes: [JSONAny]?) {
        self.id = id
        self.userID = userID
        self.position = position
        self.workingSpaceID = workingSpaceID
        self.businessID = businessID
        self.user = user
        self.workTimes = workTimes
    }
}

// MARK: Worker convenience initializers and mutators

extension WorkerCWME {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(WorkerCWME.self, from: data)
        self.init(id: me.id, userID: me.userID, position: me.position, workingSpaceID: me.workingSpaceID, businessID: me.businessID, user: me.user, workTimes: me.workTimes)
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
        position: String?? = nil,
        workingSpaceID: String?? = nil,
        businessID: String?? = nil,
        user: JSONNull?? = nil,
        workTimes: [JSONAny]?? = nil
        ) -> WorkerCWME {
        return WorkerCWME(
            id: id ?? self.id,
            userID: userID ?? self.userID,
            position: position ?? self.position,
            workingSpaceID: workingSpaceID ?? self.workingSpaceID,
            businessID: businessID ?? self.businessID,
            user: user ?? self.user,
            workTimes: workTimes ?? self.workTimes
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - WorkTime
class WorkTimeCWME: Codable {
    let id: String?
    let from, to: Int?
    let objectID: String?
    let isWork: Bool?
    let businessCategoryID: String?
    let dayOfWeek: DayOfWeekCWME?
    
    enum CodingKeys: String, CodingKey {
        case id, from, to
        case objectID = "objectId"
        case isWork
        case businessCategoryID = "businessCategoryId"
        case dayOfWeek
    }
    
    init(id: String?, from: Int?, to: Int?, objectID: String?, isWork: Bool?, businessCategoryID: String?, dayOfWeek: DayOfWeekCWME?) {
        self.id = id
        self.from = from
        self.to = to
        self.objectID = objectID
        self.isWork = isWork
        self.businessCategoryID = businessCategoryID
        self.dayOfWeek = dayOfWeek
    }
}

// MARK: WorkTime convenience initializers and mutators

extension WorkTimeCWME {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(WorkTimeCWME.self, from: data)
        self.init(id: me.id, from: me.from, to: me.to, objectID: me.objectID, isWork: me.isWork, businessCategoryID: me.businessCategoryID, dayOfWeek: me.dayOfWeek)
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
        from: Int?? = nil,
        to: Int?? = nil,
        objectID: String?? = nil,
        isWork: Bool?? = nil,
        businessCategoryID: String?? = nil,
        dayOfWeek: DayOfWeekCWME?? = nil
        ) -> WorkTimeCWME {
        return WorkTimeCWME(
            id: id ?? self.id,
            from: from ?? self.from,
            to: to ?? self.to,
            objectID: objectID ?? self.objectID,
            isWork: isWork ?? self.isWork,
            businessCategoryID: businessCategoryID ?? self.businessCategoryID,
            dayOfWeek: dayOfWeek ?? self.dayOfWeek
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

enum DayOfWeekCWME: String, Codable {
    case friday = "FRIDAY"
    case monday = "MONDAY"
    case saturday = "SATURDAY"
    case sunday = "SUNDAY"
    case thursday = "THURSDAY"
    case tuesday = "TUESDAY"
    case wednesday = "WEDNESDAY"
}

typealias CarWashMarker = [CarWashMarkerElement]

extension Array where Element == CarWashMarker.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CarWashMarker.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

