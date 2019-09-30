//
//  SelectSingleBuisnesVC.swift
//  Coupler_IOS
//
//  Created by macbook on 12/07/2019.
//  Copyright © 2019 Coupler. All rights reserved.
//

import UIKit
import Alamofire
import MaterialComponents

class SelectSingleBuisnesVC: UIViewController, UIPopoverPresentationControllerDelegate, FilterDialodDismissDelegate {

    @IBOutlet weak var changeButton: UISegmentedControl!
//    @IBOutlet weak var searchText: MDCTextField!
    @IBOutlet weak var filterMap: UIBarButtonItem!
    let constants = Constants()
    let utils = Utils()
    
    let mapView = MapViewController()
    let listView = BusinessListVC()
    var serviceSelect: [String] = []
    var search = false
    
    enum TabIndex : Int {
        case firstChildTab = 0
        case secondChildTab = 1
    }
    
//    @IBOutlet weak var segmentedControl: CustomSegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    var currentViewController: UIViewController?
    lazy var firstChildTabVC: UIViewController? = {
        let firstChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "mapViewController")
        return firstChildTabVC
    }()
    lazy var secondChildTabVC : UIViewController? = {
        let secondChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "businessListVC")
        
        return secondChildTabVC
    }()
    
    
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        checkCarInfo()
//        changeButton.initUI()
        if changeButton != nil{
            changeButton.layer.borderColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
            changeButton.layer.borderWidth = 1
            changeButton.layer.cornerRadius = 4
        }
//        searchText.addDoneCancelToolbar()
//        self.changeButton.selectedSegmentIndex = TabIndex.firstChildTab.rawValue
//        if UserDefaults.standard.object(forKey: "MAPVC") == nil{
//            
//            self.showTutorial()
//        }
        
//
        
//        utils.setBorder(view: changeButton, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), borderColor: #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), borderWidth: 1, cornerRadius: 4)
//        utils.setBorder(view: changeButton, backgroundColor: <#T##UIColor#>, borderColor: <#T##CGColor#>, borderWidth: <#T##CGFloat#>, cornerRadius: <#T##CGFloat#>)
       
        
//        if utils.getBusinesList(key: "BUSINESSLIST") != nil{
//            setBusinesMarker()
//        }else {
//            checkCarInfo()
        
//        }
    }
//    @IBAction func search(_ sender: Any) {
//        guard searchText.text!.count >= 1 else{
//
//            checkCarInfo(searchText: nil)
////            utils.checkFilds(massage: "Введите название", vc: self.view)
//            return
//        }
//        checkCarInfo(searchText: searchText.text)
//    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
    }
    
    // MARK: - Switching Tabs Functions
    @IBAction func switchTabs(_ sender: UISegmentedControl) {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParent()
        
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            
            self.addChild(vc)
            vc.didMove(toParent: self)
            
            vc.view.frame = self.contentView.bounds
            self.contentView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case TabIndex.firstChildTab.rawValue :
            vc = firstChildTabVC
        case TabIndex.secondChildTab.rawValue :
            vc = secondChildTabVC
        default:
            return nil
        }
        
        return vc
    }
//    func firstLoad(){
//        self.utils.setSaredPref(key: "FIRSTSTART", value: "true")
//        utils.checkFilds(massage: "В данный момент интерактивная карта запущена в тестовом режиме. Услуги указанных компаний недоступны. Мы работаем над тем, чтобы как можно скорее наполнить карту нужными вам сервисами.", vc: self.view)
//    }
    @IBAction func filterMap(_ sender: Any) {
        addFilter()
    }
    
    func checkCurrentView(){
        guard search != true else{
            
//            self.listView.refreshTable()
            
            search = false
            return
        }
        if self.currentViewController == self.firstChildTabVC{
            //                                self.contentView.layoutIfNeeded()
            //                                self.mapView.mapView.layoutIfNeeded()
            //                                self.mapView.mapView.clear()
            self.mapView.setBusinesMarker()
            self.displayCurrentTab(TabIndex.firstChildTab.rawValue)
            //
        } else if self.currentViewController == self.secondChildTabVC{
            
            self.displayCurrentTab(TabIndex.secondChildTab.rawValue)
            
//            self.listView.refreshTable()
        } else {
            
            
            self.mapView.setBusinesMarker()
            self.displayCurrentTab(TabIndex.firstChildTab.rawValue)
            //                            self.mapView.setBusinesMarker()
        }
    }
    func getCarWashList(filterBody: FilterCarWashBody, completion : @escaping ()->()){
        //        guard self.drawRoute == "" else{
        //             drawPath(from: drawRoute)
        //            return
        //        }
        showActivityIndicator()
        
        let restUrl = constants.startUrl + "karma/v1/business/search/document"
        let parameters = try! JSONEncoder().encode(filterBody)
        let params = try! JSONSerialization.jsonObject(with: parameters, options: .allowFragments)as? [String: Any]
        var headers = ["":""]
        if  self.utils.getSharedPref(key: "accessToken") != nil{
            headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]
        } else {
            headers = [ "Application-Id":self.constants.iosId]
        }
            Alamofire.request(restUrl, method: .post,parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response  in
                guard response.response?.statusCode != 204 else{
                    //                self.recordTableView.
                    
                    
                    self.hideActivityIndicator()
                    
                   
//                self.mapView.setBusinesMarker()
                    
                    UserDefaults.standard.removeObject(forKey: "BUSINESSLIST")
//                    if filterBody.fullTextQuery != nil {
//                        self.listView.refreshTable()
//                    } else {
                    self.checkCurrentView()
                    completion()
//                    }
//                    self.displayCurrentTab(TabIndex.firstChildTab.rawValue)
//                    if UserDefaults.standard.object(forKey: "MAPVC") == nil{
//                        
//                        self.utils.setSaredPref(key: "MAPVC", value: "true")
//                        self.showTutorial()
//                    }
                    return
                }
                
//                self.changeButton.selectedSegmentIndex = TabIndex.secondChildTab.rawValue
//                self.displayCurrentTab(TabIndex.secondChildTab.rawValue)
                do{
                    let businessList = self.utils.getBusinesList(key: "BUSINESSLIST")
                    
                    let responseBody = try JSONDecoder().decode(CarWashMarker.self, from: response.data!)
//
                    
                    self.hideActivityIndicator()
                    
                    if self.utils.getBusinesList(key: "BUSINESSLIST") != nil{
                        if (businessList! == responseBody){
                            print("NNNNNNNIIIIIIILLLLLL")
                        }else{
                            self.utils.setBusinesList(key: "BUSINESSLIST", value: responseBody)
                            
//                            self.mapView.setBusinesMarker()
//
                            self.checkCurrentView()
                            
                            completion()
                        }
                    }else{
                        
//                        self.mapView.setBusinesMarker()
                        self.utils.setBusinesList(key: "BUSINESSLIST", value: responseBody)
                        
                    
                        self.checkCurrentView()
                        
                        completion()
//                        if self.changeButton.selectedSegmentIndex == 0{
//                            self.mapView.setBusinesMarker()
//                        }
//                        if self.changeButton.selectedSegmentIndex == 1{
//                            self.listView.refreshTable()
//                        }
                        
                    }
                    
                   
                }
                catch{
                    
                    self.hideActivityIndicator()
                    print(error)
                }
               
            }
        
      
        
    }
//    func setMapView(){
//
//        self.displayCurrentTab(TabIndex.firstChildTab.rawValue)
//    }
    
    func getAllCars(){
        showActivityIndicator()
        let restUrl = constants.startUrl + "karma/v1/car/user"
        guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
            
            self.checkCarInfo(searchText: nil, completion: {})
            hideActivityIndicator()
            return
        }
        let headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]
       
        Alamofire.request(restUrl, method: .get, headers: headers).responseJSON { response  in
            
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                
                self.checkCarInfo(searchText: nil, completion: {})
                self.hideActivityIndicator()
                return
            }
            
            
            do{
//                self.checkCarInfo()
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
            self.checkCarInfo(searchText: nil, completion: {})
            self.hideActivityIndicator()
            
            
        }
    }
    
    func checkCarInfo(searchText: String?, completion : @escaping ()->()){
        if self.utils.getSharedPref(key: "CARWASHID") != nil {
           mapView.getCarWashInfo(carWashId: self.utils.getSharedPref(key: "CARWASHID")!)
        }
        if utils.getCarInfo(key: "CARID") != nil && self.utils.getSharedPref(key: "BUISNESSTYPE") == "CAR"{
            let carInfo = utils.getCarInfo(key: "CARID")
//            self.navTop.title = carInfo?.carInfo
//            self.navTop.titleView?.tintColor = .white
            if serviceSelect.count != 0{
                if UserDefaults.standard.object(forKey: "BUISNESSID") != nil{
                    getCarWashList(filterBody: FilterCarWashBody.init(serviceIDS: serviceSelect, targetID: carInfo?.carId, businessCategoryID: UserDefaults.standard.object(forKey: "BUISNESSID") as? String, fullTextQuery: searchText), completion: completion)
                }else{
                    getCarWashList(filterBody: FilterCarWashBody.init(serviceIDS: serviceSelect, targetID: carInfo?.carId, businessCategoryID: nil, fullTextQuery: searchText), completion: completion)
                }
                
            } else{
                if UserDefaults.standard.object(forKey: "BUISNESSID") != nil{
                    getCarWashList(filterBody: FilterCarWashBody.init(serviceIDS: nil, targetID: carInfo?.carId, businessCategoryID: UserDefaults.standard.object(forKey: "BUISNESSID") as? String, fullTextQuery: searchText), completion: completion)
                }else{
                    getCarWashList(filterBody: FilterCarWashBody.init(serviceIDS: nil, targetID: carInfo?.carId, businessCategoryID: nil, fullTextQuery: searchText), completion: completion)
                }
            }
            
        }else {
            if serviceSelect.count != 0{
                if UserDefaults.standard.object(forKey: "BUISNESSID") != nil{
                    //
                    //                    self.navTop.title = "Машина не выбрана"
                    getCarWashList(filterBody: FilterCarWashBody.init(serviceIDS: serviceSelect, targetID: nil, businessCategoryID: UserDefaults.standard.object(forKey: "BUISNESSID") as? String, fullTextQuery: searchText), completion: completion)
                }else{
                    //                self.navTop.title = "Машина не выбрана"
                    getCarWashList(filterBody: FilterCarWashBody.init(serviceIDS: nil, targetID: nil, businessCategoryID: nil, fullTextQuery: searchText), completion: completion)
                }
                
            } else{
                if UserDefaults.standard.object(forKey: "BUISNESSID") != nil{
                    
                    //                    self.navTop.title = "Машина не выбрана"
                    getCarWashList(filterBody: FilterCarWashBody.init(serviceIDS: nil, targetID: nil, businessCategoryID: UserDefaults.standard.object(forKey: "BUISNESSID") as? String, fullTextQuery: searchText), completion: completion)
                }else{
                    //                    self.navTop.title = "Машина не выбрана"
                    getCarWashList(filterBody: FilterCarWashBody.init(serviceIDS: nil, targetID: nil, businessCategoryID: nil, fullTextQuery: searchText), completion: completion)
                }
            }
            
        }
        
    }
    
    func addFilter() {
        //        if serviceSelect.count != 0{
        //            serviceSelect.removeAll()
        //            checkCarInfo()
        //        }
//        showActivityIndicator()
        guard UserDefaults.standard.object(forKey: "BUISNESSID") != nil else{
            
            self.utils.checkFilds(massage: "Выберите сервис", vc: self.view)
            self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "businessTableViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
//            hideActivityIndicator()
            return
        }
        
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "filterDialog") as! FilterDialog
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        customAlert.filterListIdOld = serviceSelect
        transitionVc(vc: customAlert, duration: 0.5, type: .fromRight)
        //        self.present(customAlert, animated: true, completion: nil)
        
    }
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    func Dismiss(filterListId: [String], filterOn: Bool) {
        if filterOn == true{
            serviceSelect = filterListId
            checkCarInfo(searchText: nil, completion: {})
        } else {
            if serviceSelect.count != 0{
                serviceSelect.removeAll()
            }
            checkCarInfo(searchText: nil, completion: {})
        }
    }
    override func viewDidAppear(_ animated: Bool) {
//      
    }
    func showTutorial() {
        let infoDesc = InfoDescriptor(for: NSLocalizedString("tutor_SSBVC_1", comment: ""))
        var infoTask = PassthroughTask(with: [])
        infoTask.infoDescriptor = infoDesc
        
                let buttonItemView = filterMap.value(forKey: "view") as? UIView
                let leftDesc2 = LabelDescriptor(for: NSLocalizedString("tutor_SSBVC_2", comment: ""))
                leftDesc2.position = .left
        let leftHoleDesc2 = HoleViewDescriptor(view: buttonItemView!, type: .rect(cornerRadius: 5, margin: 10))
                leftHoleDesc2.labelDescriptor = leftDesc2
                let rightLeftTask2 = PassthroughTask(with: [leftHoleDesc2])
        
        let leftDesc1 = LabelDescriptor(for: NSLocalizedString("tutor_SSBVC_3", comment: ""))
        leftDesc1.position = .bottom
        let leftHoleDesc1 = HoleViewDescriptor(view: changeButton!, type: .rect(cornerRadius: 5, margin: 10))
        leftHoleDesc1.labelDescriptor = leftDesc1
        let rightLeftTask1 = PassthroughTask(with: [leftHoleDesc1])
        PassthroughManager.shared.display(tasks: [infoTask, rightLeftTask2, rightLeftTask1]) {
            isUserSkipDemo in
            
            self.mapView.setBusinesMarker()
            
            self.utils.setSaredPref(key: "MAPVC", value: "true")
            self.changeButton.selectedSegmentIndex = TabIndex.firstChildTab.rawValue
//            self.displayCurrentTab(TabIndex.firstChildTab.rawValue)
//            self.firstLoad()
            print("isUserSkipDemo: \(isUserSkipDemo)")
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getAllCars()

        
        print("start")
    }
}
