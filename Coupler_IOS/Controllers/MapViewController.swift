//
//  ViewController.swift
//  Karma
//
//  Created by macbook on 03/12/2018.
//  Copyright © 2018 Gliesereum. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
//import SRAttractionsMap
import CoreLocation


//class POIItem: NSObject, GMUClusterItem {
//    var position: CLLocationCoordinate2D
//    var name: String!
//
//    init(position: CLLocationCoordinate2D, name: String) {
//        self.position = position
//        self.name = name
//    }
//}

class MapViewController: UIViewController, GMSMapViewDelegate{ //, GMUClusterManagerDelegate
    
  
    @IBOutlet weak var filterItem: UIBarButtonItem!
    @IBOutlet weak var navTop: UINavigationItem!
    var filterList = FilterMarkerBody()
    let constants = Constants()
    let utils = Utils()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    lazy var mapView = GMSMapView()
    var carWoshInfos = CarWashMarker()
    var drawRoute: String = ""
//    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var serviceSelect: [String] = []
    var pushRecordId = ""
//    var clusterManager: GMUClusterManager!
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .default
//    }
    // An array to hold the list of likely places.
//    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
//    var selectedPlace: GMSPlace?
    
    // A default location to use when location permission is not granted.
    let defaultLocation = CLLocation(latitude: 50.45466, longitude: 30.5238)
    
    // Update the map once the user has made their selection.
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
   
    override func viewDidLoad() {
        super .viewDidLoad()
        // Initialize the location manager.
       
        print("viewDidLoad")
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
    }
    private func randomScale() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
    }
    //MARK: get carwash list
   
    func clearMap(){
        self.mapView.clear()
        
        let marker = GMSMarker()
        
        marker.map = mapView
        
        self.view = mapView
    }
  
//    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
//
//    }
    func setBusinesMarker(){
       

        
        guard self.utils.getBusinesList(key: "BUSINESSLIST") != nil else{

           clearMap()
            
//            let rootVC = SelectSingleBuisnesVC()
            //        rootVC.changeButton.selectedSegmentIndex = 0
//            rootVC.checkCarInfo()
            return
        }
        let businessList = self.utils.getBusinesList(key: "BUSINESSLIST")
        self.mapView.clear()
        //                if self.carWoshInfos === responseBody {
        //                    self.carWoshInfos = responseBody
        for carWash: CarWashMarkerElement in businessList!{
            if carWash.logoURL != nil {
                
                self.addMarkerOnMap(getlatitude: Double(carWash.latitude!), getlongitude: Double(carWash.longitude!), title: carWash.name!, sniper: carWash.id!, logo: carWash.logoURL!, buisness: (carWash.businessCategoryID)!, active: carWash.businessVerify!)
            }else {
                self.addMarkerOnMap(getlatitude: Double(carWash.latitude!), getlongitude: Double(carWash.longitude!), title: carWash.name!, sniper: carWash.id!, logo: "", buisness: (carWash.businessCategoryID)!, active: carWash.businessVerify!)
            }
        }
//        self.view.layoutIfNeeded()
        self.view = mapView
        
    }
    
    func addMarkerOnMap(getlatitude: Double, getlongitude: Double, title: String, sniper: String, logo: String, buisness: String, active: Bool) {
        // Creates a marker in the center of the map.
        var markerImage = UIImage()
        switch buisness {
//            "CAR_WASH"
        case "0c1ca141-fb7d-414c-999f-ed8a8af69b1c":
            
            if active == true {
                
                markerImage = UIImage(named: "pin_carwash")!
            } else {
                
                markerImage = UIImage(named: "pin_carwash_disable")!
            }
//             "TIRE_FITTING"
        case "607b10e5-fc65-463d-a116-5fae6019c782":
            if active == true {
                
                markerImage = UIImage(named: "pin_tires")!
            } else {
                
                markerImage = UIImage(named: "pin_tires_disable")!
            }
//            "CAR_SERVICE"
        case "6a7d64fd-1538-430d-be52-c92ef28d2d3a":
            if active == true {
                
                markerImage = UIImage(named: "pin_sto")!
            } else {
                
                markerImage = UIImage(named: "pin_sto_disable")!
            }
//            "BEAUTY_SALONS"
        case "b355c8ae-6173-49d6-8dca-4adb22d36e9b":
            if active == true {
                
                markerImage = UIImage(named: "pin_beauty")!
            } else {
                
                markerImage = UIImage(named: "pin_beauty_disable")!
            }
//            "MARKETING"
        case "04a606db-77b2-407a-9dad-0a98177c9ba4":
            if active == true {
                
                markerImage = UIImage(named: "pin_consulting")!
            } else {
                
                markerImage = UIImage(named: "pin_consulting_disable")!
            }
            
            
//            "CLINICS"
        case "6030bab7-a582-44e0-9e08-4d81fda946ac":
            if active == true {
                
                markerImage = UIImage(named: "pin_others")!
            } else {
                
                markerImage = UIImage(named: "pin_others_disable")!
            }
//            "DEVELOPMENT"
        case "cbbe5d7f-8b39-42ce-b169-51ce8013f50c":
            if active == true {
                
                markerImage = UIImage(named: "pin_freelance")!
            } else {
                
                markerImage = UIImage(named: "pin_freelance_disable")!
            }
//            "CLEANING"
        case "a6a92d0a-f41c-4279-8105-26c01d160d97":
            if active == true {
                
                markerImage = UIImage(named: "pin_others")!
            } else {
                
                markerImage = UIImage(named: "pin_others_disable")!
            }
        default:
           
            if active == true {
                
                markerImage = UIImage(named: "pin_others")!
            } else {
                
                markerImage = UIImage(named: "pin_others_disable")!
            }
        }
        let matkerView = UIImageView(image: markerImage)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: getlatitude, longitude: getlongitude)
        marker.title = title
        marker.snippet = sniper
//        marker.icon = GMSMarker.markerImage(with: .orange)

        marker.tracksViewChanges = false
        marker.iconView = matkerView
        marker.tracksInfoWindowChanges = true
        marker.map = mapView
        marker.userData = logo
        marker.infoWindowAnchor = CGPoint(x: 0.6, y: 0.5)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {

        let customMarker:CustomMarkers = CustomMarkers.instanceFromNib() as! CustomMarkers
        
        customMarker.infoMarkerTitle.text = marker.title
        customMarker.infoMarkerSnipper.text = marker.snippet
        customMarker.infoMarkerSnipper.isHidden = true
        customMarker.infoMarkerImage.downloaded(from: marker.userData as! String)
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
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
       
        getCarWashInfo(carWashId: marker.snippet!)
       
        
    }
    //MARK: get carwash list
    func getCarWashInfo(carWashId: String){
        showActivityIndicator()
//
        if self.utils.getSharedPref(key: "CARWASHID") != nil{
        
        UserDefaults.standard.removeObject(forKey: "CARWASHID")
    }
        let headers = [ "Application-Id":self.constants.iosId]
        let restUrl = constants.startUrl + "karma/v1/business/full-model-by-id?id=\(carWashId)"
        Alamofire.request(restUrl, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.hideActivityIndicator()
                return
            }
           
            do{
               
                let responseBody = try JSONDecoder().decode(CarWashBody.self, from: response.data!)
                
//               
                //Thread 1: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "carWashInfo") as! CarWashInfo
                vc.carWashInfo = responseBody
                self.utils.setCarWashBody(key: "CARWASHBODY", value: responseBody)
                self.navigationController?.pushViewController(vc, animated: true)
             
                
                self.hideActivityIndicator()
            } catch{
                print(error)
            }
        }
    }
}
// Delegates to handle events for the location manager.
extension MapViewController: CLLocationManagerDelegate {
    
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
   
    
//
    override func viewDidAppear(_ animated: Bool) {
        
//        let rootVC = SelectSingleBuisnesVC()
//        rootVC.checkCarInfo()
//        let rootVC = SelectSingleBuisnesVC()
//        rootVC.changeButton.selectedSegmentIndex = 0
    }
    override func viewWillAppear(_ animated: Bool) {
            setBusinesMarker()
//        rootVC.changeButton.selectedSegmentIndex = 0
//        print("viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        clearMap()
    }
    
    
    
   
    
    
   
}

