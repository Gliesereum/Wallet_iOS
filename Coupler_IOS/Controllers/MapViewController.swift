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
import SRAttractionsMap
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

class MapViewController: UIViewController, GMSMapViewDelegate, NVActivityIndicatorViewable, UIPopoverPresentationControllerDelegate, FilterDialodDismissDelegate{ //, GMUClusterManagerDelegate
    
  
    @IBOutlet weak var filterItem: UIBarButtonItem!
    @IBOutlet weak var navTop: UINavigationItem!
    var filterList = FilterMarkerBody()
    let constants = Constants()
    let utils = Utils()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    lazy var mapView = GMSMapView()
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
        if utils.getSharedPref(key: "FIRSTSTART") != "true"{
            firstLoad()
        }
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
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
        
//        mapView.isHidden = true
        
//        listLikelyPlaces()

//         listLikelyPlaces()
//        do {
//            // Set the map style by passing a valid JSON string.
//            mapView.mapStyle = try GMSMapStyle(jsonString: constants.mapStyle)
//        } catch {
//            NSLog("One or more of the map styles failed to load. \(error)")
//        }
        getAllCars()
        checkCarInfo()
//        if pushRecordId != "" {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "singleOrderVC") as! SingleOrderVC
//            vc.pushRecordId = pushRecordId
//            self.navigationController?.pushViewController(vc, animated: true)
//            
//        }
        // Set up the cluster manager with the supplied icon generator and
        // renderer.
//        let iconGenerator = GMUDefaultClusterIconGenerator()
//        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
//        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
//                                                 clusterIconGenerator: iconGenerator)
//        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
//                                           renderer: renderer)
//
//        // Generate and add random items to the cluster manager.
//        generateClusterItems()
//
//        // Call cluster() after items have been added to perform the clustering
//        // and rendering on map.
//        clusterManager.cluster()
    }
    /// Randomly generates cluster items within some extent of the camera and
    /// adds them to the cluster manager.
//    private func generateClusterItems() {
//        let extent = 0.2
//        for index in 1...kClusterItemCount {
//            let lat = kCameraLatitude + extent * randomScale()
//            let lng = kCameraLongitude + extent * randomScale()
//            let name = "Item \(index)"
//            let item =
//                POIItem(position: CLLocationCoordinate2DMake(lat, lng), name: name)
//            clusterManager.addItem(item)
//        }
//    }
    
    /// Returns a random value between -1.0 and 1.0.
    private func randomScale() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
    }
    func firstLoad(){
        self.utils.setSaredPref(key: "FIRSTSTART", value: "true")
        utils.checkFilds(massage: "В данный момент интерактивная карта запущена в тестовом режиме. Услуги указанных компаний недоступны. Мы работаем над тем, чтобы как можно скорее наполнить карту нужными вам сервисами.", vc: self.view)
    }
    @IBAction func filterMap(_ sender: Any) {
        addFilter()
    }
    
    func drawPath(from polyStr: String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .black
        polyline.strokeWidth = 10.0
        polyline.map = mapView // Google MapView
        self.drawRoute = ""
        return
    }
    


    //MARK: get carwash list
    func getCarWashList(filterBody: FilterCarWashBody){
        guard self.drawRoute == "" else{
             drawPath(from: drawRoute)
            return
        }
        startAnimating()
        
        self.mapView.clear()
        let restUrl = constants.startUrl + "karma/v1/business/search"
        let parameters = try! JSONEncoder().encode(filterBody)
        let params = try! JSONSerialization.jsonObject(with: parameters, options: .allowFragments)as? [String: Any]
        Alamofire.request(restUrl, method: .post,parameters: params, encoding: JSONEncoding.default).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            do{
                
                let responseBody = try JSONDecoder().decode(CarWashMarker.self, from: response.data!)
                self.mapView.clear()
                for carWash: CarWashMarkerElement in responseBody{
                    if carWash.logoURL != nil {
                       
                        self.addMarkerOnMap(getlatitude: Double(carWash.latitude!), getlongitude: Double(carWash.longitude!), title: carWash.name!, sniper: carWash.id!, logo: carWash.logoURL!, buisness: (carWash.businessCategory?.id)!)
                    }else {
                        self.addMarkerOnMap(getlatitude: Double(carWash.latitude!), getlongitude: Double(carWash.longitude!), title: carWash.name!, sniper: carWash.id!, logo: "", buisness: (carWash.businessCategory?.id)!)
                    }
            }
            }
            catch{
                
                print(error)
                }
          
             self.stopAnimating()
        }
    }
    
    func addMarkerOnMap(getlatitude: Double, getlongitude: Double, title: String, sniper: String, logo: String, buisness: String) {
        // Creates a marker in the center of the map.
        var markerImage = UIImage()
        switch buisness {
        case "0c1ca141-fb7d-414c-999f-ed8a8af69b1c":
            
            markerImage = UIImage(named: "marker")!
        case "607b10e5-fc65-463d-a116-5fae6019c782":
            
            markerImage = UIImage(named: "markerSH")!
        case "6a7d64fd-1538-430d-be52-c92ef28d2d3a":
            
            markerImage = UIImage(named: "markerSTO")!
        default:
            
            markerImage = UIImage(named: "marker")!
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
//    class func instanceFromNib() -> CustomMarkers {
//        return UINib(nibName: "CustomMarker", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomMarkers
//    }
//
//    var tappedMarker = GMSMarker()
//    var infoWindow = CustomMarkers()
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        let index:Int! = Int(marker.accessibilityLabel!)
//        print(index)
//
//        let location = CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude)
//
//        tappedMarker = marker
//        infoWindow.removeFromSuperview()
//
//        infoWindow = MapViewController.instanceFromNib()
//
//
//
//        infoWindow.infoMarkerTitle.text = marker.title
//        infoWindow.infoMarkerSnipper.text = marker.snippet
//        infoWindow.infoMarkerSnipper.isHidden = true
//
//        infoWindow.center = mapView.projection.point(for: location)
//
//        infoWindow.center.y = infoWindow.center.y - 107
//
//        self.view.addSubview(infoWindow)
//
//        return false
//    }
//    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//
//        let location = CLLocationCoordinate2D(latitude: tappedMarker.position.latitude, longitude: tappedMarker.position.longitude)
//        infoWindow.center = mapView.projection.point(for: location)
//        infoWindow.center.y = infoWindow.center.y - 107
//
//
//    }

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
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
       
        getCarWashInfo(carWashId: marker.snippet!)
       
        
    }
    //MARK: get carwash list
    func getCarWashInfo(carWashId: String){
        startAnimating()
        guard utils.getSharedPref(key: "accessToken") != nil else{
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
            utils.setSaredPref(key: "CARWASHID", value: carWashId)
            self.sideMenuViewController!.hideMenuViewController()
            
//            self.utils.checkFilds(massage: "Авторизируйтесь", vc: self.view)
            stopAnimating()
            return
        }
        guard utils.getCarInfo(key: "CARID") != nil else{
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "сarListViewController")), animated: true)
            
            utils.setSaredPref(key: "CARWASHID", value: carWashId)
            self.sideMenuViewController!.hideMenuViewController()
            
//            self.utils.checkFilds(massage: "Выберите машину", vc: self.view)
            stopAnimating()
            return
        }
        let headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!]
        let restUrl = constants.startUrl + "karma/v1/business/\(carWashId)/full-model"
        Alamofire.request(restUrl, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            if self.utils.getSharedPref(key: "CARWASHID") != nil{
                
                UserDefaults.standard.removeObject(forKey: "CARWASHID")
            }
            do{
               
                let responseBody = try JSONDecoder().decode(CarWashBody.self, from: response.data!)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "carWashInfo") as! CarWashInfo
                vc.carWashInfo = responseBody
                self.navigationController?.pushViewController(vc, animated: true)
             
                
                self.stopAnimating()
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
    func getAllCars(){
        startAnimating()
        let restUrl = constants.startUrl + "karma/v1/car/user"
        guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
           
            stopAnimating()
            return
        }
        let headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!]
        Alamofire.request(restUrl, method: .get, headers: headers).responseJSON { response  in
            
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            
            
            do{
                let carList = try JSONDecoder().decode(AllCarList.self, from: response.data!)
                
                for element in carList{
                    
                    if element.favorite == true {
                        var carAttributes = [String]()
                        for attribute in element.attributes!{
                            carAttributes.append(attribute.id!)
                        }
                        var servicesClasses = [String]()
                        for servicesClass in element.services! {
                            servicesClasses.append(servicesClass.id!)
                        }
                        let carInfo = SelectedCarInfo.init(carId: (element.id)!, carInfo: (element.brand?.name)! + " " + (element.model?.name)!, carAttributes: carAttributes, carServices: servicesClasses)
                        
                        
                        self.utils.setCarInfo(key: "CARID", value: carInfo)
                    }
                }
            }
            catch{
                
            }
            self.checkCarInfo()
            self.stopAnimating()
            
            
        }
    }
    
    func checkCarInfo(){
        if utils.getCarInfo(key: "CARID") != nil{
            let carInfo = utils.getCarInfo(key: "CARID")
            self.navTop.title = carInfo?.carInfo
            self.navTop.titleView?.tintColor = .white
            if serviceSelect.count != 0{
                if UserDefaults.standard.object(forKey: "BUISNESSID") != nil{
                    getCarWashList(filterBody: FilterCarWashBody.init(serviceIDS: serviceSelect, targetID: carInfo?.carId, businessCategoryID: UserDefaults.standard.object(forKey: "BUISNESSID") as? String))
                }else{
                getCarWashList(filterBody: FilterCarWashBody.init(serviceIDS: serviceSelect, targetID: carInfo?.carId, businessCategoryID: nil))
                }
            
            } else{
                if UserDefaults.standard.object(forKey: "BUISNESSID") != nil{
                getCarWashList(filterBody: FilterCarWashBody.init(serviceIDS: nil, targetID: carInfo?.carId, businessCategoryID: UserDefaults.standard.object(forKey: "BUISNESSID") as? String))
                }else{
                    getCarWashList(filterBody: FilterCarWashBody.init(serviceIDS: nil, targetID: carInfo?.carId, businessCategoryID: nil))
                }
            }
            
        }else {
            if serviceSelect.count != 0{
                if UserDefaults.standard.object(forKey: "BUISNESSID") != nil{
                    
                    self.navTop.title = "Машина не выбрана"
                    getCarWashList(filterBody: FilterCarWashBody.init(serviceIDS: serviceSelect, targetID: nil, businessCategoryID: UserDefaults.standard.object(forKey: "BUISNESSID") as? String))
                }else{
                self.navTop.title = "Машина не выбрана"
                getCarWashList(filterBody: FilterCarWashBody.init(serviceIDS: nil, targetID: nil, businessCategoryID: nil))
                }
            
            } else{
                if UserDefaults.standard.object(forKey: "BUISNESSID") != nil{
                    
                    self.navTop.title = "Машина не выбрана"
                    getCarWashList(filterBody: FilterCarWashBody.init(serviceIDS: nil, targetID: nil, businessCategoryID: UserDefaults.standard.object(forKey: "BUISNESSID") as? String))
                }else{
                    self.navTop.title = "Машина не выбрана"
                    getCarWashList(filterBody: FilterCarWashBody.init(serviceIDS: nil, targetID: nil, businessCategoryID: nil))
                }
            }
        
        }
        guard self.utils.getSharedPref(key: "CARWASHID") == nil else{
            
            getCarWashInfo(carWashId: self.utils.getSharedPref(key: "CARWASHID")!)
            return
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func addFilter() {
        if serviceSelect.count != 0{
            serviceSelect.removeAll()
            checkCarInfo()
        }
        guard UserDefaults.standard.object(forKey: "BUISNESSID") != nil else{
            
            self.utils.checkFilds(massage: "Выберите сервис", vc: self.view)
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "businessTableViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            stopAnimating()
            return
        }
      
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "filterDialog") as! FilterDialog
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        transitionVc(vc: customAlert, duration: 0.5, type: .fromRight)
//        self.present(customAlert, animated: true, completion: nil)
        
    }
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
       
    }
   
    func Dismiss(filterListId: [String], filterOn: Bool) {
        if filterOn == true{
            serviceSelect = filterListId
            checkCarInfo()
        } else {
            if serviceSelect.count != 0{
            serviceSelect.removeAll()
            }
            checkCarInfo()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: "MAPVC") == nil{
            
            self.utils.setSaredPref(key: "MAPVC", value: "true")
            self.showTutorial()
        }
//        utils.checkPushNot(vc: self)
    }
    func showTutorial() {
        let infoDesc = InfoDescriptor(for: "На этой карте расположены различные маркера сервисов. Вы можете выбрать нужный вам сервис нажатием на маркер. При нажатии на маркер появится детально окно с названием сервиса. Чтобы открыть данный сервис просто нажмите на его название ")
        var infoTask = PassthroughTask(with: [])
        infoTask.infoDescriptor = infoDesc
        
        let buttonItemView = filterItem.value(forKey: "view") as? UIView
        let leftDesc2 = LabelDescriptor(for: "Чтобы выбрать услуги и отфильровать карту по ним нажмите сюда")
        leftDesc2.position = .left
        let leftHoleDesc2 = HoleViewDescriptor(view: buttonItemView!, type: .circle)
        leftHoleDesc2.labelDescriptor = leftDesc2
        let rightLeftTask2 = PassthroughTask(with: [leftHoleDesc2])
        PassthroughManager.shared.display(tasks: [infoTask, rightLeftTask2]) {
            isUserSkipDemo in
            
            print("isUserSkipDemo: \(isUserSkipDemo)")
        }
        
    }
   
}

