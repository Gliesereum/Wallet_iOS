// To parse the JSON, add this file to your project and do:
//
//   let directionBody = try DirectionBody(json)

import Foundation

class DirectionBody: Codable {
    let geocodedWaypoints: [GeocodedWaypoint]?
    let routes: [Route]?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case geocodedWaypoints = "geocoded_waypoints"
        case routes, status
    }
    
    init(geocodedWaypoints: [GeocodedWaypoint]?, routes: [Route]?, status: String?) {
        self.geocodedWaypoints = geocodedWaypoints
        self.routes = routes
        self.status = status
    }
}

class GeocodedWaypoint: Codable {
    let geocoderStatus, placeID: String?
    let types: [String]?
    
    enum CodingKeys: String, CodingKey {
        case geocoderStatus = "geocoder_status"
        case placeID = "place_id"
        case types
    }
    
    init(geocoderStatus: String?, placeID: String?, types: [String]?) {
        self.geocoderStatus = geocoderStatus
        self.placeID = placeID
        self.types = types
    }
}

class Route: Codable {
    let bounds: Bounds?
    let copyrights: String?
    let legs: [Leg]?
    let overviewPolyline: Polyline?
    let summary: String?
    let warnings, waypointOrder: [JSONAny]?
    
    enum CodingKeys: String, CodingKey {
        case bounds, copyrights, legs
        case overviewPolyline = "overview_polyline"
        case summary, warnings
        case waypointOrder = "waypoint_order"
    }
    
    init(bounds: Bounds?, copyrights: String?, legs: [Leg]?, overviewPolyline: Polyline?, summary: String?, warnings: [JSONAny]?, waypointOrder: [JSONAny]?) {
        self.bounds = bounds
        self.copyrights = copyrights
        self.legs = legs
        self.overviewPolyline = overviewPolyline
        self.summary = summary
        self.warnings = warnings
        self.waypointOrder = waypointOrder
    }
}

class Bounds: Codable {
    let northeast, southwest: Northeast?
    
    init(northeast: Northeast?, southwest: Northeast?) {
        self.northeast = northeast
        self.southwest = southwest
    }
}

class Northeast: Codable {
    let lat, lng: Double?
    
    init(lat: Double?, lng: Double?) {
        self.lat = lat
        self.lng = lng
    }
}

class Leg: Codable {
    let distance, duration: Distance?
    let endAddress: String?
    let endLocation: Northeast?
    let startAddress: String?
    let startLocation: Northeast?
    let steps: [Step]?
    let trafficSpeedEntry, viaWaypoint: [JSONAny]?
    
    enum CodingKeys: String, CodingKey {
        case distance, duration
        case endAddress = "end_address"
        case endLocation = "end_location"
        case startAddress = "start_address"
        case startLocation = "start_location"
        case steps
        case trafficSpeedEntry = "traffic_speed_entry"
        case viaWaypoint = "via_waypoint"
    }
    
    init(distance: Distance?, duration: Distance?, endAddress: String?, endLocation: Northeast?, startAddress: String?, startLocation: Northeast?, steps: [Step]?, trafficSpeedEntry: [JSONAny]?, viaWaypoint: [JSONAny]?) {
        self.distance = distance
        self.duration = duration
        self.endAddress = endAddress
        self.endLocation = endLocation
        self.startAddress = startAddress
        self.startLocation = startLocation
        self.steps = steps
        self.trafficSpeedEntry = trafficSpeedEntry
        self.viaWaypoint = viaWaypoint
    }
}

class Distance: Codable {
    let text: String?
    let value: Int?
    
    init(text: String?, value: Int?) {
        self.text = text
        self.value = value
    }
}

class Step: Codable {
    let distance, duration: Distance?
    let endLocation: Northeast?
    let htmlInstructions: String?
    let polyline: Polyline?
    let startLocation: Northeast?
    let travelMode, maneuver: String?
    
    enum CodingKeys: String, CodingKey {
        case distance, duration
        case endLocation = "end_location"
        case htmlInstructions = "html_instructions"
        case polyline
        case startLocation = "start_location"
        case travelMode = "travel_mode"
        case maneuver
    }
    
    init(distance: Distance?, duration: Distance?, endLocation: Northeast?, htmlInstructions: String?, polyline: Polyline?, startLocation: Northeast?, travelMode: String?, maneuver: String?) {
        self.distance = distance
        self.duration = duration
        self.endLocation = endLocation
        self.htmlInstructions = htmlInstructions
        self.polyline = polyline
        self.startLocation = startLocation
        self.travelMode = travelMode
        self.maneuver = maneuver
    }
}

class Polyline: Codable {
    let points: String?
    
    init(points: String?) {
        self.points = points
    }
}

// MARK: Convenience initializers and mutators

extension DirectionBody {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(DirectionBody.self, from: data)
        self.init(geocodedWaypoints: me.geocodedWaypoints, routes: me.routes, status: me.status)
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
        geocodedWaypoints: [GeocodedWaypoint]?? = nil,
        routes: [Route]?? = nil,
        status: String?? = nil
        ) -> DirectionBody {
        return DirectionBody(
            geocodedWaypoints: geocodedWaypoints ?? self.geocodedWaypoints,
            routes: routes ?? self.routes,
            status: status ?? self.status
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension GeocodedWaypoint {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(GeocodedWaypoint.self, from: data)
        self.init(geocoderStatus: me.geocoderStatus, placeID: me.placeID, types: me.types)
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
        geocoderStatus: String?? = nil,
        placeID: String?? = nil,
        types: [String]?? = nil
        ) -> GeocodedWaypoint {
        return GeocodedWaypoint(
            geocoderStatus: geocoderStatus ?? self.geocoderStatus,
            placeID: placeID ?? self.placeID,
            types: types ?? self.types
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Route {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Route.self, from: data)
        self.init(bounds: me.bounds, copyrights: me.copyrights, legs: me.legs, overviewPolyline: me.overviewPolyline, summary: me.summary, warnings: me.warnings, waypointOrder: me.waypointOrder)
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
        bounds: Bounds?? = nil,
        copyrights: String?? = nil,
        legs: [Leg]?? = nil,
        overviewPolyline: Polyline?? = nil,
        summary: String?? = nil,
        warnings: [JSONAny]?? = nil,
        waypointOrder: [JSONAny]?? = nil
        ) -> Route {
        return Route(
            bounds: bounds ?? self.bounds,
            copyrights: copyrights ?? self.copyrights,
            legs: legs ?? self.legs,
            overviewPolyline: overviewPolyline ?? self.overviewPolyline,
            summary: summary ?? self.summary,
            warnings: warnings ?? self.warnings,
            waypointOrder: waypointOrder ?? self.waypointOrder
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Bounds {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Bounds.self, from: data)
        self.init(northeast: me.northeast, southwest: me.southwest)
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
        northeast: Northeast?? = nil,
        southwest: Northeast?? = nil
        ) -> Bounds {
        return Bounds(
            northeast: northeast ?? self.northeast,
            southwest: southwest ?? self.southwest
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Northeast {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Northeast.self, from: data)
        self.init(lat: me.lat, lng: me.lng)
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
        lat: Double?? = nil,
        lng: Double?? = nil
        ) -> Northeast {
        return Northeast(
            lat: lat ?? self.lat,
            lng: lng ?? self.lng
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Leg {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Leg.self, from: data)
        self.init(distance: me.distance, duration: me.duration, endAddress: me.endAddress, endLocation: me.endLocation, startAddress: me.startAddress, startLocation: me.startLocation, steps: me.steps, trafficSpeedEntry: me.trafficSpeedEntry, viaWaypoint: me.viaWaypoint)
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
        distance: Distance?? = nil,
        duration: Distance?? = nil,
        endAddress: String?? = nil,
        endLocation: Northeast?? = nil,
        startAddress: String?? = nil,
        startLocation: Northeast?? = nil,
        steps: [Step]?? = nil,
        trafficSpeedEntry: [JSONAny]?? = nil,
        viaWaypoint: [JSONAny]?? = nil
        ) -> Leg {
        return Leg(
            distance: distance ?? self.distance,
            duration: duration ?? self.duration,
            endAddress: endAddress ?? self.endAddress,
            endLocation: endLocation ?? self.endLocation,
            startAddress: startAddress ?? self.startAddress,
            startLocation: startLocation ?? self.startLocation,
            steps: steps ?? self.steps,
            trafficSpeedEntry: trafficSpeedEntry ?? self.trafficSpeedEntry,
            viaWaypoint: viaWaypoint ?? self.viaWaypoint
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Distance {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Distance.self, from: data)
        self.init(text: me.text, value: me.value)
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
        text: String?? = nil,
        value: Int?? = nil
        ) -> Distance {
        return Distance(
            text: text ?? self.text,
            value: value ?? self.value
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Step {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Step.self, from: data)
        self.init(distance: me.distance, duration: me.duration, endLocation: me.endLocation, htmlInstructions: me.htmlInstructions, polyline: me.polyline, startLocation: me.startLocation, travelMode: me.travelMode, maneuver: me.maneuver)
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
        distance: Distance?? = nil,
        duration: Distance?? = nil,
        endLocation: Northeast?? = nil,
        htmlInstructions: String?? = nil,
        polyline: Polyline?? = nil,
        startLocation: Northeast?? = nil,
        travelMode: String?? = nil,
        maneuver: String?? = nil
        ) -> Step {
        return Step(
            distance: distance ?? self.distance,
            duration: duration ?? self.duration,
            endLocation: endLocation ?? self.endLocation,
            htmlInstructions: htmlInstructions ?? self.htmlInstructions,
            polyline: polyline ?? self.polyline,
            startLocation: startLocation ?? self.startLocation,
            travelMode: travelMode ?? self.travelMode,
            maneuver: maneuver ?? self.maneuver
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Polyline {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Polyline.self, from: data)
        self.init(points: me.points)
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
        points: String?? = nil
        ) -> Polyline {
        return Polyline(
            points: points ?? self.points
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
