// To parse the JSON, add this file to your project and do:
//
//   let allRecordsCarWash = try AllRecordsCarWash(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseAllRecordsCarWash { response in
//     if let allRecordsCarWash = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

typealias AllRecordsCarWash = [AllRecordsCarWashElement]

class AllRecordsCarWashElement: Codable {
    let id, targetID: String?
    let packageID: String?
    let businessID: String?
    let price, begin, finish: Int?
    let description: AllRecordsCarWashDescription?
    let packageDto: PackageDto?
    let business: BusinessARCE?
    let statusPay, statusProcess: JSONNull?
    let statusRecord: StatusRecord?
    let serviceType: ServiceTypeARCE?
    let services: [ServiceElement]?
    let servicesIDS: [JSONAny]?
    let workingSpaceID: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case targetID = "targetId"
        case packageID = "packageId"
        case businessID = "businessId"
        case price, begin, finish, description, packageDto, business, statusPay, statusProcess, statusRecord, serviceType, services
        case servicesIDS = "servicesIds"
        case workingSpaceID = "workingSpaceId"
    }
    
    init(id: String?, targetID: String?, packageID: String?, businessID: String?, price: Int?, begin: Int?, finish: Int?, description: AllRecordsCarWashDescription?, packageDto: PackageDto?, business: BusinessARCE?, statusPay: JSONNull?, statusProcess: JSONNull?, statusRecord: StatusRecord?, serviceType: ServiceTypeARCE?, services: [ServiceElement]?, servicesIDS: [JSONAny]?, workingSpaceID: String?) {
        self.id = id
        self.targetID = targetID
        self.packageID = packageID
        self.businessID = businessID
        self.price = price
        self.begin = begin
        self.finish = finish
        self.description = description
        self.packageDto = packageDto
        self.business = business
        self.statusPay = statusPay
        self.statusProcess = statusProcess
        self.statusRecord = statusRecord
        self.serviceType = serviceType
        self.services = services
        self.servicesIDS = servicesIDS
        self.workingSpaceID = workingSpaceID
    }
}

class BusinessARCE: Codable {
    let id, corporationID: String?
    let name: BusinessName?
    let description: String?
    let logoURL: JSONNull?
    let address: Address?
    let phone: String?
    let addPhone: JSONNull?
    let latitude, longitude: Double?
    let timeZone: Int?
    let serviceType: ServiceTypeARCE?
    let objectState: ObjectStateARCE?
    let workTimes: [WorkTimeARCE]?
    let spaces: [SpaceARCE]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case corporationID = "corporationId"
        case name, description
        case logoURL = "logoUrl"
        case address, phone, addPhone, latitude, longitude, timeZone, serviceType, objectState, workTimes, spaces
    }
    
    init(id: String?, corporationID: String?, name: BusinessName?, description: String?, logoURL: JSONNull?, address: Address?, phone: String?, addPhone: JSONNull?, latitude: Double?, longitude: Double?, timeZone: Int?, serviceType: ServiceTypeARCE?, objectState: ObjectStateARCE?, workTimes: [WorkTimeARCE]?, spaces: [SpaceARCE]?) {
        self.id = id
        self.corporationID = corporationID
        self.name = name
        self.description = description
        self.logoURL = logoURL
        self.address = address
        self.phone = phone
        self.addPhone = addPhone
        self.latitude = latitude
        self.longitude = longitude
        self.timeZone = timeZone
        self.serviceType = serviceType
        self.objectState = objectState
        self.workTimes = workTimes
        self.spaces = spaces
    }
}

enum Address: String, Codable {
    case bulvarVatslavaHavelaKyivUkraine02000 = "bulvar Vatslava Havela, Kyiv, Ukraine, 02000"
    case vatslavaHavelaBoulevard6KyivUkraine02000 = "Vatslava Havela Boulevard, 6, Kyiv, Ukraine, 02000"
}

enum BusinessName: String, Codable {
    case testAndroidApp = "Test Android App"
    case testAndroidNew = "Test Android New"
}

enum ObjectStateARCE: String, Codable {
    case active = "ACTIVE"
    case deleted = "DELETED"
}

enum ServiceTypeARCE: String, Codable {
    case carWash = "CAR_WASH"
}

class SpaceARCE: Codable {
    let id: String?
    let indexNumber: Int?
    let businessID: String?
    let statusSpace: JSONNull?
    let serviceType: ServiceTypeARCE?
    let workers: [JSONAny]?
    
    enum CodingKeys: String, CodingKey {
        case id, indexNumber
        case businessID = "businessId"
        case statusSpace, serviceType, workers
    }
    
    init(id: String?, indexNumber: Int?, businessID: String?, statusSpace: JSONNull?, serviceType: ServiceTypeARCE?, workers: [JSONAny]?) {
        self.id = id
        self.indexNumber = indexNumber
        self.businessID = businessID
        self.statusSpace = statusSpace
        self.serviceType = serviceType
        self.workers = workers
    }
}

class WorkTimeARCE: Codable {
    let id: String?
    let from, to: Int?
    let objectID: String?
    let isWork: Bool?
    let serviceType: ServiceTypeARCE?
    let dayOfWeek: DayOfWeek?
    
    enum CodingKeys: String, CodingKey {
        case id, from, to
        case objectID = "objectId"
        case isWork, serviceType, dayOfWeek
    }
    
    init(id: String?, from: Int?, to: Int?, objectID: String?, isWork: Bool?, serviceType: ServiceTypeARCE?, dayOfWeek: DayOfWeek?) {
        self.id = id
        self.from = from
        self.to = to
        self.objectID = objectID
        self.isWork = isWork
        self.serviceType = serviceType
        self.dayOfWeek = dayOfWeek
    }
}

enum DayOfWeek: String, Codable {
    case friday = "FRIDAY"
    case monday = "MONDAY"
    case saturday = "SATURDAY"
    case sunday = "SUNDAY"
    case thursday = "THURSDAY"
    case tuesday = "TUESDAY"
    case wednesday = "WEDNESDAY"
}

enum AllRecordsCarWashDescription: String, Codable {
    case android = "Android"
}

class PackageDto: Codable {
    let id: String?
    let name: String?
    let discount, duration: Int?
    let businessID: String?
    let objectState: String?
    let servicesIDS: [JSONAny]?
    let services: [ServiceElement]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, discount, duration
        case businessID = "businessId"
        case objectState
        case servicesIDS = "servicesIds"
        case services
    }
    
    init(id: String?, name: String?, discount: Int?, duration: Int?, businessID: String?, objectState: String?, servicesIDS: [JSONAny]?, services: [ServiceElement]?) {
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

enum PackageDtoName: String, Codable {
    case пакетAllIN = "Пакет All-IN"
    case пакетДляВсех = "Пакет для всех"
    case скоросной = "Скоросной"
}

class ServiceElement: Codable {
    let id: String?
    let name: String?
    let description: String?
    let price: Int?
    let serviceID, businessID: String?
    let service: ServiceClassClass?
    let objectState: ObjectStateARCE?
    let duration: Int?
    let serviceClass: [ServiceClassClass]?
    let attributes: [JSONAny]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, price
        case serviceID = "serviceId"
        case businessID = "businessId"
        case service, objectState, duration, serviceClass, attributes
    }
    
    init(id: String?, name: String?, description: String?, price: Int?, serviceID: String?, businessID: String?, service: ServiceClassClass?, objectState: ObjectStateARCE?, duration: Int?, serviceClass: [ServiceClassClass]?, attributes: [JSONAny]?) {
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

enum PurpleName: String, Codable {
    case karamba = "Karamba"
    case антидождь = "Антидождь"
    case дляВсех = "Для всех"
    case кабриолетКожаСтандарт = "Кабриолет Кожа Стандарт"
    case кода = "Кода"
    case мойкаДвигателяля = "Мойка Двигателяля"
    case обработкаРезиновыхУплотнителей = "Обработка резиновых уплотнителей"
    case снятиеБитумаСмолы = "Снятие битума, смолы"
    case твердыйВоск = "Твердый воск"
}

class ServiceClassClass: Codable {
    let id: String?
    let name: String?
    let description: String?
    let objectState: String?
    let orderIndex: Int?
    
    init(id: String?, name: String?, description: String?, objectState: String?, orderIndex: Int?) {
        self.id = id
        self.name = name
        self.description = description
        self.objectState = objectState
        self.orderIndex = orderIndex
    }
}

enum ServiceDescription: String, Codable {
    case автоСтандартКласса = "авто стандарт класса"
    case мойкаДвигателяИМоторногоОтсекаПродувка = "Мойка двигателя и моторного отсека, продувка"
    case натираниеСиликономРезинокДверей = "Натирание силиконом резинок дверей"
    case покрытиеКузоваТвердымВоском = "Покрытие кузова твердым воском"
    case покрытиеЛобовогоСтеклаСредствамиАнтидождь = "Покрытие лобового стекла средствами \"Антидождь\""
    case полировкаКожаныхДеталейСалонаХимическимиСредствами = "Полировка кожаных деталей салона химическими средствами"
    case снятиеБитумаСмолы = "Снятие битума, смолы"
    case чисткаСалонаПылесосом = "Чистка салона пылесосом"
}

enum ServiceClassName: String, Codable {
    case антидождь = "Антидождь"
    case мойкаДвигателя = "Мойка двигателя"
    case обработкаКожи = "Обработка кожи"
    case обработкаРезиновыхУплотнителейДверей = "Обработка резиновых уплотнителей дверей"
    case пылесос = "Пылесос"
    case снятиеБитумаСмолы = "Снятие битума, смолы"
    case стандарт = "Стандарт"
    case твердыйВоск = "Твердый воск"
}

enum StatusRecord: String, Codable {
    case created = "CREATED"
}

// MARK: Convenience initializers and mutators

extension AllRecordsCarWashElement {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(AllRecordsCarWashElement.self, from: data)
        self.init(id: me.id, targetID: me.targetID, packageID: me.packageID, businessID: me.businessID, price: me.price, begin: me.begin, finish: me.finish, description: me.description, packageDto: me.packageDto, business: me.business, statusPay: me.statusPay, statusProcess: me.statusProcess, statusRecord: me.statusRecord, serviceType: me.serviceType, services: me.services, servicesIDS: me.servicesIDS, workingSpaceID: me.workingSpaceID)
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
        targetID: String?,
        packageID: String?,
        businessID: String?,
        price: Int?,
        begin: Int?,
        finish: Int?,
        description: AllRecordsCarWashDescription?,
        packageDto: PackageDto?,
        business: BusinessARCE?,
        statusPay: JSONNull?,
        statusProcess: JSONNull?,
        statusRecord: StatusRecord?,
        serviceType: ServiceTypeARCE?,
        services: [ServiceElement]?,
        servicesIDS: [JSONAny]?,
        workingSpaceID: String?
        ) -> AllRecordsCarWashElement {
        return AllRecordsCarWashElement(
            id: id ?? self.id,
            targetID: targetID ?? self.targetID,
            packageID: packageID ?? self.packageID,
            businessID: businessID ?? self.businessID,
            price: price ?? self.price,
            begin: begin ?? self.begin,
            finish: finish ?? self.finish,
            description: description ?? self.description,
            packageDto: packageDto ?? self.packageDto,
            business: business ?? self.business,
            statusPay: statusPay ?? self.statusPay,
            statusProcess: statusProcess ?? self.statusProcess,
            statusRecord: statusRecord ?? self.statusRecord,
            serviceType: serviceType ?? self.serviceType,
            services: services ?? self.services,
            servicesIDS: servicesIDS ?? self.servicesIDS,
            workingSpaceID: workingSpaceID ?? self.workingSpaceID
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension BusinessARCE {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(BusinessARCE.self, from: data)
        self.init(id: me.id, corporationID: me.corporationID, name: me.name, description: me.description, logoURL: me.logoURL, address: me.address, phone: me.phone, addPhone: me.addPhone, latitude: me.latitude, longitude: me.longitude, timeZone: me.timeZone, serviceType: me.serviceType, objectState: me.objectState, workTimes: me.workTimes, spaces: me.spaces)
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
        corporationID: String?,
        name: BusinessName?,
        description: String?,
        logoURL: JSONNull?,
        address: Address?,
        phone: String?,
        addPhone: JSONNull?,
        latitude: Double?,
        longitude: Double?,
        timeZone: Int?,
        serviceType: ServiceTypeARCE?,
        objectState: ObjectStateARCE?,
        workTimes: [WorkTimeARCE]?,
        spaces: [SpaceARCE]?
        ) -> BusinessARCE {
        return BusinessARCE(
            id: id ?? self.id,
            corporationID: corporationID ?? self.corporationID,
            name: name ?? self.name,
            description: description ?? self.description,
            logoURL: logoURL ?? self.logoURL,
            address: address ?? self.address,
            phone: phone ?? self.phone,
            addPhone: addPhone ?? self.addPhone,
            latitude: latitude ?? self.latitude,
            longitude: longitude ?? self.longitude,
            timeZone: timeZone ?? self.timeZone,
            serviceType: serviceType ?? self.serviceType,
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

extension SpaceARCE {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(SpaceARCE.self, from: data)
        self.init(id: me.id, indexNumber: me.indexNumber, businessID: me.businessID, statusSpace: me.statusSpace, serviceType: me.serviceType, workers: me.workers)
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
        indexNumber: Int?,
        businessID: String?,
        statusSpace: JSONNull?,
        serviceType: ServiceTypeARCE?,
        workers: [JSONAny]?
        ) -> SpaceARCE {
        return SpaceARCE(
            id: id ?? self.id,
            indexNumber: indexNumber ?? self.indexNumber,
            businessID: businessID ?? self.businessID,
            statusSpace: statusSpace ?? self.statusSpace,
            serviceType: serviceType ?? self.serviceType,
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

extension WorkTimeARCE {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(WorkTimeARCE.self, from: data)
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
        id: String?,
        from: Int?,
        to: Int?,
        objectID: String?,
        isWork: Bool?,
        serviceType: ServiceTypeARCE?,
        dayOfWeek: DayOfWeek?
        ) -> WorkTimeARCE {
        return WorkTimeARCE(
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

extension PackageDto {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(PackageDto.self, from: data)
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
        id: String?,
        name: String?,
        discount: Int?,
        duration: Int?,
        businessID: String?,
        objectState: String?,
        servicesIDS: [JSONAny]?,
        services: [ServiceElement]?
        ) -> PackageDto {
        return PackageDto(
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

extension ServiceElement {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(ServiceElement.self, from: data)
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
        id: String?,
        name: String?,
        description: String?,
        price: Int?,
        serviceID: String?,
        businessID: String?,
        service: ServiceClassClass?,
        objectState: ObjectStateARCE?,
        duration: Int?,
        serviceClass: [ServiceClassClass]?,
        attributes: [JSONAny]?
        ) -> ServiceElement {
        return ServiceElement(
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

extension ServiceClassClass {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(ServiceClassClass.self, from: data)
        self.init(id: me.id, name: me.name, description: me.description, objectState: me.objectState, orderIndex: me.orderIndex)
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
        name: String?,
        description: String?,
        objectState: String?,
        orderIndex: Int?
        ) -> ServiceClassClass {
        return ServiceClassClass(
            id: id ?? self.id,
            name: name ?? self.name,
            description: description ?? self.description,
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

extension Array where Element == AllRecordsCarWash.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AllRecordsCarWash.self, from: data)
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
    func responseAllRecordsCarWash(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<AllRecordsCarWash>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
