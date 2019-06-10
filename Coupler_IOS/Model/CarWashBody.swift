// To parse the JSON, add this file to your project and do:
//
//   let carWashBody = try CarWashBody(json)

import Foundation

class CarWashBody: Codable {
    let id, name, corporationID, businessID: String?
    let description: String?
    let logoURL: String?
    let address, phone: String?
    let addPhone: String?
    let latitude, longitude: Double?
    let timeZone: Int?
    let rating: Rating?
    let objectState: String?
    let workTimes: [WorkTime]?
    let spaces: [Space]?
    var servicePrices: [Serviceice]?
    let packages: [Package]?
    let media: [Media]?
    let comments: [Comment]?
    let records: [JSONAny]?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case corporationID = "corporationId"
        case businessID = "businessId"
        case description
        case logoURL = "logoUrl"
        case address, phone, addPhone, latitude, longitude, timeZone, rating, objectState, workTimes, spaces, servicePrices, packages, media, comments, records
    }
    
    init(id: String?, name: String?, corporationID: String?, businessID: String?, description: String?, logoURL: String?, address: String?, phone: String?, addPhone: String?, latitude: Double?, longitude: Double?, timeZone: Int?, rating: Rating?, objectState: String?, workTimes: [WorkTime]?, spaces: [Space]?, servicePrices: [Serviceice]?, packages: [Package]?, media: [Media]?, comments: [Comment]?, records: [JSONAny]?) {
        self.id = id
        self.name = name
        self.corporationID = corporationID
        self.businessID = businessID
        self.description = description
        self.logoURL = logoURL
        self.address = address
        self.phone = phone
        self.addPhone = addPhone
        self.latitude = latitude
        self.longitude = longitude
        self.timeZone = timeZone
        self.rating = rating
        self.objectState = objectState
        self.workTimes = workTimes
        self.spaces = spaces
        self.servicePrices = servicePrices
        self.packages = packages
        self.media = media
        self.comments = comments
        self.records = records
    }
}

class Comment: Codable {
    let id, objectID, text: String?
    let rating: Int?
    let ownerID, firstName, lastName, middleName: String?
    let dateCreated: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case objectID = "objectId"
        case text, rating
        case ownerID = "ownerId"
        case firstName, lastName, middleName, dateCreated
    }
    
    init(id: String?, objectID: String?, text: String?, rating: Int?, ownerID: String?, firstName: String?, lastName: String?, middleName: String?, dateCreated: Int?) {
        self.id = id
        self.objectID = objectID
        self.text = text
        self.rating = rating
        self.ownerID = ownerID
        self.firstName = firstName
        self.lastName = lastName
        self.middleName = middleName
        self.dateCreated = dateCreated
    }
}

class Media: Codable {
    let id, objectID: String?
    let title, description: String?
    let url: String?
    let mediaType: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case objectID = "objectId"
        case title, description, url, mediaType
    }
    
    init(id: String?, objectID: String?, title: String?, description: String?, url: String?, mediaType: String?) {
        self.id = id
        self.objectID = objectID
        self.title = title
        self.description = description
        self.url = url
        self.mediaType = mediaType
    }
}

enum ObjectState: String, Codable {
    case active = "ACTIVE"
}

class Package: Codable {
    let id, name: String?
    let discount, duration: Int?
    let businessID: String?
    let objectState: ObjectState?
    let servicesIDS: [JSONAny]?
    let services: [Serviceice]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, discount, duration
        case businessID = "businessId"
        case objectState
        case servicesIDS = "servicesIds"
        case services
    }
    
    init(id: String?, name: String?, discount: Int?, duration: Int?, businessID: String?, objectState: ObjectState?, servicesIDS: [JSONAny]?, services: [Serviceice]?) {
        self.id = id
        self.name = name
        self.discount = discount
        self.duration = duration
        self.businessID = businessID
        self.objectState = objectState
        self.servicesIDS = servicesIDS
        self.services = services
    }
}

class Serviceice: Codable {
    let id, name: String?
    let description: String?
    let price: Int?
    let serviceID, businessID: String?
    let service: Service?
    let objectState: ObjectState?
    let duration: Int?
    let serviceClass: [Service]?
    let attributes: [Attribute]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, price
        case serviceID = "serviceId"
        case businessID = "businessId"
        case service, objectState, duration, serviceClass, attributes
    }
    
    init(id: String?, name: String?, description: String?, price: Int?, serviceID: String?, businessID: String?, service: Service?, objectState: ObjectState?, duration: Int?, serviceClass: [Service]?, attributes: [Attribute]?) {
        self.id = id
        self.name = name
        self.description = description
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

class Attribute: Codable {
    let id, value, title, filterID: String?
    
    enum CodingKeys: String, CodingKey {
        case id, value, title
        case filterID = "filterId"
    }
    
    init(id: String?, value: String?, title: String?, filterID: String?) {
        self.id = id
        self.value = value
        self.title = title
        self.filterID = filterID
    }
}

class Service: Codable {
    let id, name, description: String?
    let serviceType: ServiceType?
    let objectState: ObjectState?
    let orderIndex: Int?
    
    init(id: String?, name: String?, description: String?, serviceType: ServiceType?, objectState: ObjectState?, orderIndex: Int?) {
        self.id = id
        self.name = name
        self.description = description
        self.serviceType = serviceType
        self.objectState = objectState
        self.orderIndex = orderIndex
    }
}

enum ServiceType: String, Codable {
    case carWash = "CAR_WASH"
}

class Rating: Codable {
    let rating: Double?
    let count: Int?
    
    init(rating: Double?, count: Int?) {
        self.rating = rating
        self.count = count
    }
}

class Space: Codable {
    let businessID, id, statusSpace: String?
    let indexNumber: Int?
    let spaceDescription: String?
    let businessCategoryID, name: String?
    let workers: [JSONAny]?
    
    enum CodingKeys: String, CodingKey {
        case businessID = "businessId"
        case id, statusSpace, indexNumber
        case spaceDescription = "description"
        case businessCategoryID = "businessCategoryId"
        case name, workers
    }
    
    init(businessID: String?, id: String?, statusSpace: String?, indexNumber: Int?, spaceDescription: String?, businessCategoryID: String?, name: String?, workers: [JSONAny]?) {
        self.businessID = businessID
        self.id = id
        self.statusSpace = statusSpace
        self.indexNumber = indexNumber
        self.spaceDescription = spaceDescription
        self.businessCategoryID = businessCategoryID
        self.name = name
        self.workers = workers
    }
}


class Worker: Codable {
    let id, userID, position, workingSpaceID: String?
    let businessID: String?
    let workTimes: [JSONAny]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case position
        case workingSpaceID = "workingSpaceId"
        case businessID = "businessId"
        case workTimes
    }
    
    init(id: String?, userID: String?, position: String?, workingSpaceID: String?, businessID: String?, workTimes: [JSONAny]?) {
        self.id = id
        self.userID = userID
        self.position = position
        self.workingSpaceID = workingSpaceID
        self.businessID = businessID
        self.workTimes = workTimes
    }
}

class WorkTime: Codable {
    let id: String?
    let from, to: Int?
    let objectID: String?
    let isWork: Bool?
    let serviceType: String?
    let dayOfWeek: String?
    
    enum CodingKeys: String, CodingKey {
        case id, from, to
        case objectID = "objectId"
        case isWork, serviceType, dayOfWeek
    }
    
    init(id: String?, from: Int?, to: Int?, objectID: String?, isWork: Bool?, serviceType: String?, dayOfWeek: String?) {
        self.id = id
        self.from = from
        self.to = to
        self.objectID = objectID
        self.isWork = isWork
        self.serviceType = serviceType
        self.dayOfWeek = dayOfWeek
    }
}

// MARK: Convenience initializers and mutators

extension CarWashBody {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(CarWashBody.self, from: data)
        self.init(id: me.id, name: me.name, corporationID: me.corporationID, businessID: me.businessID, description: me.description, logoURL: me.logoURL, address: me.address, phone: me.phone, addPhone: me.addPhone, latitude: me.latitude, longitude: me.longitude, timeZone: me.timeZone, rating: me.rating, objectState: me.objectState, workTimes: me.workTimes, spaces: me.spaces, servicePrices: me.servicePrices, packages: me.packages, media: me.media, comments: me.comments, records: me.records)
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
        corporationID: String?? = nil,
        businessID: String?? = nil,
        description: String?? = nil,
        logoURL: String?? = nil,
        address: String?? = nil,
        phone: String?? = nil,
        addPhone: String?? = nil,
        latitude: Double?? = nil,
        longitude: Double?? = nil,
        timeZone: Int?? = nil,
        rating: Rating?? = nil,
        objectState: String?? = nil,
        workTimes: [WorkTime]?? = nil,
        spaces: [Space]?? = nil,
        servicePrices: [Serviceice]?? = nil,
        packages: [Package]?? = nil,
        media: [Media]?? = nil,
        comments: [Comment]?? = nil,
        records: [JSONAny]?? = nil
        ) -> CarWashBody {
        return CarWashBody(
            id: id ?? self.id,
            name: name ?? self.name,
            corporationID: corporationID ?? self.corporationID,
            businessID: businessID ?? self.businessID,
            description: description ?? self.description,
            logoURL: logoURL ?? self.logoURL,
            address: address ?? self.address,
            phone: phone ?? self.phone,
            addPhone: addPhone ?? self.addPhone,
            latitude: latitude ?? self.latitude,
            longitude: longitude ?? self.longitude,
            timeZone: timeZone ?? self.timeZone,
            rating: rating ?? self.rating,
            objectState: objectState ?? self.objectState,
            workTimes: workTimes ?? self.workTimes,
            spaces: spaces ?? self.spaces,
            servicePrices: servicePrices ?? self.servicePrices,
            packages: packages ?? self.packages,
            media: media ?? self.media,
            comments: comments ?? self.comments,
            records: records ?? self.records
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Comment {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Comment.self, from: data)
        self.init(id: me.id, objectID: me.objectID, text: me.text, rating: me.rating, ownerID: me.ownerID, firstName: me.firstName, lastName: me.lastName, middleName: me.middleName, dateCreated: me.dateCreated)
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
        objectID: String?? = nil,
        text: String?? = nil,
        rating: Int?? = nil,
        ownerID: String?? = nil,
        firstName: String?? = nil,
        lastName: String?? = nil,
        middleName: String?? = nil,
        dateCreated: Int?? = nil
        ) -> Comment {
        return Comment(
            id: id ?? self.id,
            objectID: objectID ?? self.objectID,
            text: text ?? self.text,
            rating: rating ?? self.rating,
            ownerID: ownerID ?? self.ownerID,
            firstName: firstName ?? self.firstName,
            lastName: lastName ?? self.lastName,
            middleName: middleName ?? self.middleName,
            dateCreated: dateCreated ?? self.dateCreated
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Media {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Media.self, from: data)
        self.init(id: me.id, objectID: me.objectID, title: me.title, description: me.description, url: me.url, mediaType: me.mediaType)
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
        objectID: String?? = nil,
        title: String?? = nil,
        description: String?? = nil,
        url: String?? = nil,
        mediaType: String?? = nil
        ) -> Media {
        return Media(
            id: id ?? self.id,
            objectID: objectID ?? self.objectID,
            title: title ?? self.title,
            description: description ?? self.description,
            url: url ?? self.url,
            mediaType: mediaType ?? self.mediaType
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Package {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Package.self, from: data)
        self.init(id: me.id, name: me.name, discount: me.discount, duration: me.duration, businessID: me.businessID, objectState: me.objectState, servicesIDS: me.servicesIDS, services: me.services)
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
        discount: Int?? = nil,
        duration: Int?? = nil,
        businessID: String?? = nil,
        objectState: ObjectState?? = nil,
        servicesIDS: [JSONAny]?? = nil,
        services: [Serviceice]?? = nil
        ) -> Package {
        return Package(
            id: id ?? self.id,
            name: name ?? self.name,
            discount: discount ?? self.discount,
            duration: duration ?? self.duration,
            businessID: businessID ?? self.businessID,
            objectState: objectState ?? self.objectState,
            servicesIDS: servicesIDS ?? self.servicesIDS,
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

extension Serviceice {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Serviceice.self, from: data)
        self.init(id: me.id, name: me.name, description: me.description, price: me.price, serviceID: me.serviceID, businessID: me.businessID, service: me.service, objectState: me.objectState, duration: me.duration, serviceClass: me.serviceClass, attributes: me.attributes)
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
        description: String?? = nil,
        price: Int?? = nil,
        serviceID: String?? = nil,
        businessID: String?? = nil,
        service: Service?? = nil,
        objectState: ObjectState?? = nil,
        duration: Int?? = nil,
        serviceClass: [Service]?? = nil,
        attributes: [Attribute]?? = nil
        ) -> Serviceice {
        return Serviceice(
            id: id ?? self.id,
            name: name ?? self.name,
            description: description ?? self.description,
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

extension Attribute {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Attribute.self, from: data)
        self.init(id: me.id, value: me.value, title: me.title, filterID: me.filterID)
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
        value: String?? = nil,
        title: String?? = nil,
        filterID: String?? = nil
        ) -> Attribute {
        return Attribute(
            id: id ?? self.id,
            value: value ?? self.value,
            title: title ?? self.title,
            filterID: filterID ?? self.filterID
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Service {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Service.self, from: data)
        self.init(id: me.id, name: me.name, description: me.description, serviceType: me.serviceType, objectState: me.objectState, orderIndex: me.orderIndex)
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
        description: String?? = nil,
        serviceType: ServiceType?? = nil,
        objectState: ObjectState?? = nil,
        orderIndex: Int?? = nil
        ) -> Service {
        return Service(
            id: id ?? self.id,
            name: name ?? self.name,
            description: description ?? self.description,
            serviceType: serviceType ?? self.serviceType,
            objectState: objectState ?? self.objectState,
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

extension Rating {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Rating.self, from: data)
        self.init(rating: me.rating, count: me.count)
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
        rating: Double?? = nil,
        count: Int?? = nil
        ) -> Rating {
        return Rating(
            rating: rating ?? self.rating,
            count: count ?? self.count
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: Space convenience initializers and mutators

extension Space {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Space.self, from: data)
        self.init(businessID: me.businessID, id: me.id, statusSpace: me.statusSpace, indexNumber: me.indexNumber, spaceDescription: me.spaceDescription, businessCategoryID: me.businessCategoryID, name: me.name, workers: me.workers)
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
        businessID: String?? = nil,
        id: String?? = nil,
        statusSpace: String?? = nil,
        indexNumber: Int?? = nil,
        spaceDescription: String?? = nil,
        businessCategoryID: String?? = nil,
        name: String?? = nil,
        workers: [JSONAny]?? = nil
        ) -> Space {
        return Space(
            businessID: businessID ?? self.businessID,
            id: id ?? self.id,
            statusSpace: statusSpace ?? self.statusSpace,
            indexNumber: indexNumber ?? self.indexNumber,
            spaceDescription: spaceDescription ?? self.spaceDescription,
            businessCategoryID: businessCategoryID ?? self.businessCategoryID,
            name: name ?? self.name,
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


extension Worker {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Worker.self, from: data)
        self.init(id: me.id, userID: me.userID, position: me.position, workingSpaceID: me.workingSpaceID, businessID: me.businessID, workTimes: me.workTimes)
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
        workTimes: [JSONAny]?? = nil
        ) -> Worker {
        return Worker(
            id: id ?? self.id,
            userID: userID ?? self.userID,
            position: position ?? self.position,
            workingSpaceID: workingSpaceID ?? self.workingSpaceID,
            businessID: businessID ?? self.businessID,
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

extension WorkTime {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(WorkTime.self, from: data)
        self.init(id: me.id, from: me.from, to: me.to, objectID: me.objectID, isWork: me.isWork, serviceType: me.serviceType, dayOfWeek: me.dayOfWeek)
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
        serviceType: String?? = nil,
        dayOfWeek: String?? = nil
        ) -> WorkTime {
        return WorkTime(
            id: id ?? self.id,
            from: from ?? self.from,
            to: to ?? self.to,
            objectID: objectID ?? self.objectID,
            isWork: isWork ?? self.isWork,
            serviceType: serviceType ?? self.serviceType,
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
