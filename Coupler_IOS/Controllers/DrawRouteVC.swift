//
//  DrawRouteVC.swift
//  Karma
//
//  Created by macbook on 30/05/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//

import UIKit

import Alamofire
import GoogleMaps
import CoreLocation

class DrawRouteVC: UIViewController,GMSMapViewDelegate {
    
    let constants = Constants()
    let utils = Utils()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var destinationLt: String?
    var destinationTitle: String?
    var destinationLg: String?
    let defaultLocation = CLLocation(latitude: 50.45466, longitude: 30.5238)
    var zoomLevel: Float = 15.0
    lazy var mapView = GMSMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRoute(sourceLat: self.utils.getSharedPref(key: "curLat")!, sourceLong: self.utils.getSharedPref(key: "curLon")!, destinationLt: destinationLt!, destinationLg: destinationLg!)
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 500
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        do {
            mapView.mapStyle = try GMSMapStyle(jsonString: constants.mapStyle)
            mapView.delegate = self
            // Add the map to the view, hide it until we've got a location update.
            view = mapView
        } catch{
            
        }
        addMarkerOnMap(getlatitude: Double(destinationLt!) as! Double, getlongitude: Double(destinationLg!) as! Double, title: destinationTitle!)
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func drawPath()
//    {
//
//        let origin = "\(43.1561681),\(-75.8449946)"
//        let destination = "\(38.8950712),\(-77.0362758)"
//
//        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=API_KEY"
//
//
//
//        Alamofire.request(url).responseJSON { response in
//            print(response.request!)  // original URL request
//            print(response.response!) // HTTP URL response
//            print(response.data!)     // server data
//            print(response.result)   // result of response serialization
//
//            do {
//                let json = try JSON(data: response.data!)
//                let routes = json["routes"].arrayValue
//
//                for route in routes
//                {
//                    let routeOverviewPolyline = route["overview_polyline"].dictionary
//                    let points = routeOverviewPolyline?["points"]?.stringValue
//                }
//            }
//            catch {
//                print("ERROR: not working")
//            }
//
//
//
//        }
//
//    }
    func addMarkerOnMap(getlatitude: Double, getlongitude: Double, title: String) {
        // Creates a marker in the center of the map.
        var markerImage = UIImage()
        markerImage = UIImage(named: "pin_primary")!
        let matkerView = UIImageView(image: markerImage)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: getlatitude, longitude: getlongitude)
        marker.title = title
//        marker.snippet = sniper
        //        marker.icon = GMSMarker.markerImage(with: .orange)
        
        marker.tracksViewChanges = false
        marker.iconView = matkerView
        marker.tracksInfoWindowChanges = true
        marker.map = mapView
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.7)
//        marker.userData = logo
        marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.3)
    }
    func fetchRoute(sourceLat: String, sourceLong: String, destinationLt: String, destinationLg: String) {
        
        //        let session = URLSession.shared
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(sourceLat),\(sourceLong)&destination=\(destinationLt),\(destinationLg)&sensor=false&mode=driving&key=AIzaSyB_I2EBQDEm4ul0POhWNxrZ0SOKNo8mDAM")!
        print(url)
        
        Alamofire.request(url, method: .get, headers: self.constants.appID).responseJSON { response  in
            
            guard response.response?.statusCode == 200 else{
                return
            }
            do{
                let sigInModel = try JSONDecoder().decode(DirectionBody.self, from: response.data!)
                
                guard sigInModel.status != "REQUEST_DENIED" else {
                    self.utils.checkFilds(massage: NSLocalizedString("Error_row", comment: ""), vc: self.view)
                    return
                }
                let points = sigInModel.routes?.first?.overviewPolyline?.points
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
                polyline.strokeWidth = 4.0
                polyline.map = self.mapView
                
            }
            catch{
                
            }
            
            
        }
        
        
    }

}
extension DrawRouteVC: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        utils.setSaredPref(key: "curLat", value: String(location.coordinate.latitude))
        utils.setSaredPref(key: "curLon", value: String(location.coordinate.longitude))
        
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
        //        listLikelyPlaces()
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        default:
            break
            
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let customMarker:CustomMarkers = CustomMarkers.instanceFromNib() as! CustomMarkers
        
        customMarker.infoMarkerTitle.text = marker.title
        customMarker.infoMarkerSnipper.text = marker.snippet
        customMarker.infoMarkerSnipper.isHidden = true
        //        customMarker.viewSelf.backgroundColor = UIColor(patternImage: UIImage(named: "bginfoWindow.png")!)
        //
        //        if marker.userData  as! String == "" {
        //
        ////            customMarker.infoMarkerImage.image = UIImage(named: "logo_v1SmallLogo")
        //        }else {
        //            customMarker.infoMarkerImage.downloaded(from: marker.userData! as! String)
        //        }
        return customMarker
    }
}
