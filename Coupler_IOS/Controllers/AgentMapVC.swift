//
//  AgentMapVC.swift
//  Coupler_IOS
//
//  Created by macbook on 28/08/2019.
//  Copyright © 2019 Coupler. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
//import SRAttractionsMap
import CoreLocation
import MaterialComponents



class AgentMapVC: UIViewController, GMSMapViewDelegate, NVActivityIndicatorViewable, CLLocationManagerDelegate {

    
    @IBOutlet weak var viewMap: UIView!
    @IBOutlet weak var addMarker: MDCButton!
    let constants = Constants()
    let utils = Utils()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var currentCoordinate: CLLocationCoordinate2D?
    lazy var mapView = GMSMapView()

    var zoomLevel: Float = 15.0
    
    let defaultLocation = CLLocation(latitude: 50.45466, longitude: 30.5238)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 500
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        //        placesClient = GMSPlacesClient.shared()
        
                // Create a map.
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: viewMap.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        mapView.settings.myLocationButton = true
        
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        do {
            mapView.mapStyle = try GMSMapStyle(jsonString: constants.mapStyle)
            mapView.delegate = self
            // Add the map to the view, hide it until we've got a location update.
            viewMap.addSubview(mapView)
        } catch{
            
        }
        // Do any additional setup after loading the view.
    }
    private func randomScale() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
    }
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        // Clear the map.
        mapView.clear()
        
        // Add a marker to the map.
        //        if selectedPlace != nil {
        //            let marker = GMSMarker(position: (self.selectedPlace?.coordinate)!)
        //            marker.title = selectedPlace?.name
        //            marker.snippet = selectedPlace?.formattedAddress
        //            marker.map = mapView
        //        }
        
        //        listLikelyPlaces()
    }
    
    @IBAction func newMarker(_ sender: Any) {
        
        guard currentCoordinate != nil else{
            
            utils.checkFilds(massage: "Нажмите на карту чтобы задать координаты маркеру", vc: self.view)
            return
        }
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "setMarkerDialog") as! SetMarkerDialog
        customAlert.currentCoordinate = self.currentCoordinate
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//        customAlert.delegate = self
        self.present(customAlert, animated: true, completion: nil)
        
    }
    
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
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        // Custom logic here
        mapView.clear()
        let marker = GMSMarker()
        marker.position = coordinate
        currentCoordinate = coordinate
        marker.title = "Новый маркер"
        marker.snippet = ""
        let markerImage = UIImage(named: "pin_primary")!
        let matkerView = UIImageView(image: markerImage)
        marker.iconView = matkerView
        marker.map = mapView
        addMarker.setBackgroundColor(#colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), for: .normal)
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
    
    func setNewMarker(){
        let restUrl = constants.startUrl + "/agent/current-user-agent"
        Alamofire.request(restUrl, method: .get, headers: ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                
                return
            }
            
            
        }
    }

}
