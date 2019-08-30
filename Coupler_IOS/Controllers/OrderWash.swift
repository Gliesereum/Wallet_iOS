//
//  OrderWash.swift
//  Karma
//
//  Created by macbook on 20/02/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//

import UIKit
import EHHorizontalSelectionView
import AZDialogView
import Alamofire
import MaterialComponents

protocol CreateCarDissmisDelegete: class {
    func CreateCarDismiss()
}

class OrderWash: UIViewController, EHHorizontalSelectionViewProtocol, UITableViewDataSource, UITableViewDelegate, DateTimePickerDelegate, NVActivityIndicatorViewable, UIPopoverPresentationControllerDelegate, DialodDismissDelegate, SetTimeDialogDismissDelegate, OrderDialogDismissDelegate, WorkersListDelegate, CreateCarDissmisDelegete, OrderPopDismissDelegate{
   
    func OrderPopDismiss() {
        pressOrderButton = false
    }
    
    
   
    
   
    @IBOutlet weak var workerImage: UIImageView!
    @IBOutlet weak var workerPosition: UILabel!
    @IBOutlet weak var workerName: UILabel!
    @IBOutlet weak var carServicePrice: UITableView!
    var carWashInfo: CarWashBody? = nil
    @IBOutlet weak var pacetsSelector: EHHorizontalSelectionView!
    @IBOutlet weak var workerBtn: UIButton!
    @IBOutlet weak var saleryLable: UILabel!
    @IBOutlet weak var saleryLable2: UILabel!
    
    @IBOutlet weak var callUsView: MDCButton!
    @IBOutlet weak var packageView: UIView!
    //    @IBOutlet weak var packageLabel: UILabel!
    @IBOutlet weak var allDurations: UILabel!
    @IBOutlet weak var text: UILabel!
//    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var salerLable: UILabel!
//    @IBOutlet weak var selectPackage: UILabel!
    @IBOutlet weak var orderButton: MDCButton!
    @IBOutlet weak var workerView: UIView!
//    @IBOutlet weak var saleryView: UIView!
//    @IBOutlet weak var packageTableView: UIView!
    
    @IBOutlet weak var servicesLable: UILabel!
    @IBOutlet weak var allPrice: UILabel!
    @IBOutlet weak var packetServicesLable: UILabel!
    @IBOutlet weak var packetServicesTable: UITableView!
    @IBOutlet weak var packageContent: UIView!
    
    let timepicker = DateTimePicker()
    let utils = Utils()
    let constants = Constants()
    var durationArray: [Int] = []
    var priceArray: [Int] = []
    var idServicePrice: [String] = []
    var sumPrice = Int()
    var sumDurations = Int()
    @IBOutlet weak var packageLable: UILabel!
    var pricesPackage = [Int]()
    var packagesList: [String] = ["Не выбран"]
    var packageDuration = Int()
    var packagePrice : Int = 0
    var packageId: String = ""
    var currentTime = Int()
    var workSpaceId = String()
    var time = String()
    var workerId = ""
    var createCar = false
    var indexPackage = UInt()
    var counter = false
    var servicesOld = [Serviceice]()
    var targetId : String?
    var packegeServices = [Serviceice]()
    var selectedServices = [Serviceice]()
    var pressOrderButton = false
//    var workers : WorkerByBuisnesBody?\
    var checkedWorker: [Worker] = []
    var worker : Worker?
    
    let dialogController = AZDialogViewController(title: "Выберите время", message: "Время не выбрато")
    
    let cellSpacingHeight: CGFloat = 5
   
    func checkWorker(){
        if  UserDefaults.standard.object(forKey: "ORDERWASHVC") == nil {
            
            self.utils.setSaredPref(key: "ORDERWASHVC", value: "true")
            self.showTutorial()
        }  else if carWashInfo?.workers!.count != 0 || carWashInfo?.workers != nil{
            for workerCheck in (carWashInfo?.workers)!{
                if workerCheck.workingSpaceID != nil{
                    checkedWorker.append(workerCheck)
                }
            }
            if checkedWorker.count == 0 || carWashInfo?.spaces?.count == 0{
                    utils.checkFilds(massage: "У этой компании нет возможности записи онлайн. Вы можете сделать заказ по телефону", vc: self.view)
                    workerView.visiblity(gone: true)
                    workerView.isHidden = true
                    orderButton.isHidden = true
                    callUsView.isHidden = false
                    
                    //            view.layoutIfNeeded()
            }
        } else {
            utils.checkFilds(massage: "У этой компании нет возможности записи онлайн. Вы можете сделать заказ по телефону", vc: self.view)
            workerView.visiblity(gone: true)
            workerView.isHidden = true
            orderButton.isHidden = true
            callUsView.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkWorker()
//          self.utils.setBorder(view: saleryView, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
        
        
       
        
//        packageLable.visiblity(gone: true)
        packetServicesTable.visiblity(gone: true)
        packetServicesTable.visiblity(gone: true)
//        getWorkers()
//        utils.setBorder(view: headerView, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
       
        filterServices()
        carServicePrice.tableFooterView = UIView()
        if carWashInfo?.packages?.count != 0 {
            for package in (carWashInfo?.packages)!{
                if package.objectState != "DELETED"{
                    packagesList.append(package.name!)
                }
            }
        } else {
            packageView.visiblity(gone: true)
            packageView.isHidden = true
            packageLable.isHidden = true
            packageContent.isHidden = true
            
//              view.layoutIfNeeded()
//            packageLabel.visiblity(gone: true)
        }
        if carWashInfo?.servicePrices?.count == 0 || carWashInfo?.servicePrices == nil{
            servicesLable.isHidden = true
        }
        
        packetServicesTable.estimatedRowHeight = 54
        packetServicesTable.tableFooterView = UIView()
        packetServicesTable.layoutIfNeeded()
        packetServicesTable.invalidateIntrinsicContentSize()
        
        carServicePrice.estimatedRowHeight = 66
        carServicePrice.tableFooterView = UIView()
        carServicePrice.layoutIfNeeded()
        carServicePrice.invalidateIntrinsicContentSize()
        pacetsSelector.delegate = self

//        packageTableView.isHidden = true
        packetServicesTable.isHidden = true
        packetServicesLable.isHidden = true
//        packetServicesLable.visiblity(gone: true)
//        packageTableView.layoutIfNeeded()
        
//        packageTableView.layoutIfNeeded()
       view.layoutIfNeeded()
        // Do any additional setup after loading the view.
        
    }
    @IBAction func callUs(_ sender: Any) {
        if carWashInfo?.phone == nil{
            utils.checkFilds(massage: "У этой компании не внесен номер телефона", vc: self.view)
        } else{
            if let phoneCallURL = URL(string: "telprompt://\((carWashInfo?.phone)!)") {
                
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    if #available(iOS 10.0, *) {
                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                        application.openURL(phoneCallURL as URL)
                        
                    }
                }
            }
        }
    }
    
    func voidView(){
        carWashInfo = self.utils.getCarWashBody(key: "CARWASHBODY")
        if packageId != "" {
            addsumPriceDurations(price: packagePrice, duration: packageDuration)
            text.text = packageId
        }
        
        addsumPriceDurations(price: 0, duration: 0)
    }
   
    // MARK: - Navigation
    @IBAction func selectWorker(_ sender: Any) {
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "workersList") as! WorkersList
        customAlert.workers = self.checkedWorker
        customAlert.timeZone = (carWashInfo?.timeZone)!
        customAlert.businesId = carWashInfo?.id
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.popover
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        self.present(customAlert, animated: true, completion: nil)
        
//        let vc = storyboard?.instantiateViewController(withIdentifier: "workersList") as! WorkersList
//        vc.workers = workers
//        navigationController?.pushViewController(vc, animated: true)
        
    }
    func DismissWorker(worker: Worker?) {
        
        self.worker = worker
        if worker != nil {
        self.workerId = (worker?.id!)!
        } else {
           self.workerId = ""
        }
    }
    
    @IBAction func orderButton(_ sender: Any) {
        pressOrderButton = true
//        getCurrentTime()
        guard sumPrice != 0 else{
            utils.checkFilds(massage: "Выберите услуги", vc: self.view)
            return
        }
        guard utils.getSharedPref(key: "accessToken") != nil else{
            let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "siginViewController") as! SiginViewController
            customAlert.poper = true
            customAlert.providesPresentationContextTransitionStyle = true
            customAlert.definesPresentationContext = true
            customAlert.modalPresentationStyle = UIModalPresentationStyle.popover
            customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            customAlert.delegate = self
            self.present(customAlert, animated: true, completion: nil)
//            self.utils.checkFilds(massage: "Авторизируйтесь", vc: self.view)
            
            
            
            return
            
        }
        guard utils.getSharedPref(key: "USER") != nil else{
            let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
            customAlert.poper = true
            customAlert.providesPresentationContextTransitionStyle = true
            customAlert.definesPresentationContext = true
            customAlert.modalPresentationStyle = UIModalPresentationStyle.popover
            customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            customAlert.delegate = self
            self.present(customAlert, animated: true, completion: nil)
            return
        }
        if self.carWashInfo?.businessCategory?.businessType == "CAR" {
            
            guard self.createCar != true else{
                let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "createCar") as! CreateCar
                customAlert.poper = true
                customAlert.providesPresentationContextTransitionStyle = true
                customAlert.definesPresentationContext = true
                customAlert.modalPresentationStyle = UIModalPresentationStyle.popover
                customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                customAlert.delegate = self
                self.present(customAlert, animated: true, completion: nil)
                self.createCar = false
                return
            }
            guard self.utils.getCarInfo(key: "CARID") != nil else{
                let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "сarListViewController") as! CarListViewController
                customAlert.poper = true
                customAlert.providesPresentationContextTransitionStyle = true
                customAlert.definesPresentationContext = true
                customAlert.modalPresentationStyle = UIModalPresentationStyle.popover
                customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                customAlert.delegateOr = self
                customAlert.delegate = self
                self.present(customAlert, animated: true, completion: nil)
                return
            }
            pressOrderButton = false
            
        }
       
//        showDialog()
            showSelectTimeDialog(enable: true)
       
    }
    
    func numberOfItems(inHorizontalSelection hSelView: EHHorizontalSelectionView) -> UInt {
//        return UInt(arrayPacets.count)
        return UInt(packagesList.count)
    }

    func titleForItem(at index: UInt, forHorisontalSelection hSelView: EHHorizontalSelectionView) -> String? {
//        return arrayPacets[Int(index)] as! String
        if packagesList[Int(index)] == "Не выбран"{
            self.indexPackage = index
        }
        return packagesList[Int(index)]
    }
    
    func horizontalSelection(_ selectionView: EHHorizontalSelectionView, didSelectObjectAt index: UInt) {
//        text.text = arrayPacets[Int(index)]
       
        guard index != 0 else{
            if text.text != nil{
                remuvePackage(self)
                removeAll()
//                selectPackage.text = "Не выбран"
                selectedServices = servicesOld
             
                carServicePrice.reloadData()
                carServicePrice.invalidateIntrinsicContentSize()
                packetServicesTable.isHidden = true
                packetServicesLable.isHidden = true
                salerLable.isHidden = true
                saleryLable.isHidden = true
                saleryLable2.isHidden = true
//                packageTableView.isHidden = true
//                packageTableView.visiblity(gone: true)
//                packageTableView.layoutIfNeeded()
                packegeServices.removeAll()
                packetServicesTable.reloadData()
                packetServicesTable.invalidateIntrinsicContentSize()
                view.layoutIfNeeded()
            }
            return
        }
        addCategory(package: (carWashInfo?.packages![Int(index) - 1])!)
        
    
    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if tableView == packetServicesTable{
//            return packegeServices.count
//        } else{
//            return selectedServices.count
//
//        }
//
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == packetServicesTable{
            return packegeServices.count
        } else{
            
            if selectedServices.count == 0 {
                servicesLable.isHidden = true
            } else {
                servicesLable.isHidden = false
                
            }
            return selectedServices.count
        }
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.clear
//        return headerView
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 5
//
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == packetServicesTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "customServicesPricePackage", for: indexPath) as! CustomServicesPrice
//            self.utils.setBorder(view: cell, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), borderWidth: 1, cornerRadius: 4)
//            cell.name.textColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
            let carServicePrices = packegeServices[indexPath.row]
            cell.name.text = carServicePrices.name
            //        cell.price.text = String(describing: carServicePrices?.price ?? 0)
            cell.id.text = carServicePrices.id
            //        cell.time.text = String(describing: carServicePrices?.duration ?? 0)
            return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "customServicesPrice", for: indexPath) as! CustomServicesPrice
            let carServicePrices = selectedServices[indexPath.row]
            
//            utils.setBorder(view: cell, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
            cell.clipsToBounds = true
            //        if carInfo.
            cell.name.text = carServicePrices.name
            cell.price.text = String(describing: carServicePrices.price ?? 0)
            cell.id.text = carServicePrices.id
            cell.time.text = String(describing: carServicePrices.duration ?? 0)
            
            //        guard utils.filterArray(savedInfos: carInfo!.carAttributes, serverInfos: carServicePrices?.attributes.) != false else {
            //            return cell
            //        }
            //        guard utils.filterArray(savedInfos: carInfo!.carServices, serverInfos: carServicePrices!.carAttributes) != false else {
            //            return cell
            //        }
            
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == packetServicesTable{
            
        } else{
        
            let cells = cell as! CustomServicesPrice
            if cell.isSelected{
    //             utils.setBorder(view: cell, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), borderWidth: 1, cornerRadius: 4)
                cells.checkBox.isHidden = false
                cells.uncheckBox.isHidden = true
            } else {
    //             utils.setBorder(view: cell, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
                cells.checkBox.isHidden = true
                cells.uncheckBox.isHidden = false
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: CustomServicesPrice = tableView.cellForRow(at: indexPath) as! CustomServicesPrice
//        durationArray.append(Int(cell.time.text!)!)
//        sumDurations = durationArray.reduce(0, +)
//        allDurations.text = "\u{231B}" + String(sumDurations) + " мин."
//        priceArray.append(Int(cell.price.text!)!)
//        sumPrice = priceArray.reduce(0, +)
//        allPrice.text = "💵" + String(sumPrice) + " грн."
        UIView.animate(withDuration: 0.4, delay: 0.0, options:[.transitionCurlDown], animations: {
            
//            self.utils.setBorder(view: cell, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), borderWidth: 1, cornerRadius: 4)
            cell.checkBox.isHidden = false
            cell.uncheckBox.isHidden = true
            
        }, completion:nil)
        addsumPriceDurations(price: Int(cell.price.text!)!, duration: Int(cell.time.text!)!)
        idServicePrice.append(cell.id.text!)
       
        
    }
    func addsumPriceDurations(price: Int, duration: Int)  {
        startAnimating()
        durationArray.append(duration)
        sumDurations = durationArray.reduce(0, +)
        allDurations.text = String(sumDurations)
        priceArray.append(price)
        sumPrice = priceArray.reduce(0, +)
        allPrice.text = String(sumPrice)
        stopAnimating()
    }
    func removesumPriceDurations(price: Int, duration: Int, packageService: String)  {
        sumPrice = sumPrice - price
        allPrice.text = String(sumPrice)
        if priceArray.firstIndex(of: price) != nil {
        priceArray.remove(at: priceArray.firstIndex(of: price)!)
        }
        
        sumDurations = sumDurations - duration
        allDurations.text = String(sumDurations)
         if durationArray.firstIndex(of: duration) != nil {
        durationArray.remove(at: durationArray.firstIndex(of: duration)!)
        }
        if packageService == "PACKAGE"{
        carWashInfo?.servicePrices = servicesOld
        carServicePrice.reloadData()
        carServicePrice.invalidateIntrinsicContentSize()
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell: CustomServicesPrice = tableView.cellForRow(at: indexPath) as! CustomServicesPrice
//        sumPrice = sumPrice - Int(cell.price.text!)!
//        allPrice.text = "💵" + String(sumPrice) + " грн."
//        priceArray.remove(at: priceArray.index(of: Int(cell.price.text!)!)!)
//
//        sumDurations = sumDurations - Int(cell.time.text!)!
//        allDurations.text = "\u{231B}" + String(sumDurations) + " мин."
//        durationArray.remove(at: durationArray.index(of: Int(cell.time.text!)!)!)
        UIView.animate(withDuration: 0.2, delay: 0.0, options:[.curveEaseInOut], animations: {
            
//            self.utils.setBorder(view: cell, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
            cell.checkBox.isHidden = true
            cell.uncheckBox.isHidden = false
        }, completion:nil)
        removesumPriceDurations(price: Int(cell.price.text!)!, duration: Int(cell.time.text!)!, packageService: "SERVICE")
        idServicePrice.remove(at: idServicePrice.firstIndex(of: cell.id.text!)!)
      
    }
    
    func getCurrentTime(setTime: Int, selected: Int) -> Int {
       
        let restUrl = constants.startUrl + "karma/v1/record/free-time"
//       utils.currentTimeInMiliseconds(timeZone: (carWashInfo?.timeZone)!)
        startAnimating()
        var parameters = try! JSONEncoder().encode(OrderBodyCarWash.init(begin: setTime, businessID: carWashInfo?.businessID, workerId: nil, description: "IOS", packageID: self.packageId, servicesIDS: idServicePrice, targetID: nil, workingSpaceID: nil))
        if workerId != "" &&  self.carWashInfo?.businessCategory?.businessType == "CAR" {
         parameters = try! JSONEncoder().encode(OrderBodyCarWash.init(begin: setTime, businessID: carWashInfo?.businessID, workerId: self.workerId, description: "IOS", packageID: self.text.text, servicesIDS: idServicePrice, targetID: targetId, workingSpaceID: nil))
        } else if workerId != ""{
            parameters = try! JSONEncoder().encode(OrderBodyCarWash.init(begin: setTime, businessID: carWashInfo?.businessID, workerId: self.workerId, description: "IOS", packageID: self.text.text, servicesIDS: idServicePrice, targetID: nil, workingSpaceID: nil))
        } else if self.carWashInfo?.businessCategory?.businessType == "CAR" {
            parameters = try! JSONEncoder().encode(OrderBodyCarWash.init(begin: setTime, businessID: carWashInfo?.businessID, workerId: nil, description: "IOS", packageID: self.text.text, servicesIDS: idServicePrice, targetID: targetId, workingSpaceID: self.workSpaceId))
        }

        let params = try! JSONSerialization.jsonObject(with: parameters, options: .allowFragments)as? [String: Any]
        Alamofire.request(restUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]).responseJSON { response  in
            do{
                guard response.response?.statusCode != 500 else{
//                    self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "selectSingleBuisnesVC")), animated: true)
//                self.sideMenuViewController!.hideMenuViewController()
                    self.utils.checkServer(vc: self)
//                SCLAlertView().showError("Внимание!", subTitle: "Нет связи с сервером", closeButtonTitle: "Закрыть")
                //            TinyToast.shared.show(message: "Нет связи с сервером", valign: .bottom, duration: .normal)
                    
                    self.stopAnimating()
                return
                }
                guard response.result.error == nil else {
                    self.utils.checkServer(vc: self)
//                    SCLAlertView().showError("Внимание!", subTitle: "Нет связи с сервером", closeButtonTitle: "Закрыть")
                    self.view.endEditing(true)
                    
                    self.stopAnimating()
                    return
                }
                guard response.response?.statusCode == 200 else{
                    let errorBody = try JSONDecoder().decode(ErrorBody.self, from: response.data!)
                    guard errorBody.code != 1104 else{
                        self.utils.refreshToken()
                        
                        self.stopAnimating()
                        return
                    }
                    guard self.utils.checkResponseStatusCode(code: errorBody.code!) != "..." else{
                        
                        self.stopAnimating()
                        return
                    }
                    
                    if selected != 3 || selected != 4{
                    self.view.endEditing(true)
                    SCLAlertView().showWarning("Внимание!", subTitle: self.utils.checkResponseStatusCode(code: errorBody.code!), closeButtonTitle: "Закрыть")
                    }
                   
                    self.stopAnimating()
                    self.currentTime = 0
                    if selected == 0 {
                        self.showSelectTimeDialog(enable: false)
                    }
                        //                    TinyToast.shared.show(message: errorBody.message!, valign: .bottom, duration: .normal)
                    return
                    }
                let currentFreeTime = try JSONDecoder().decode(CurrentFreeTime.self, from: response.data!)
                    guard currentFreeTime.begin != nil else{
                        return
                    }
                
                if self.workerId == ""{
                    self.workerId = currentFreeTime.workerID!
                }
                    self.currentTime = currentFreeTime.begin!
                    self.workSpaceId = currentFreeTime.workingSpaceID!
                self.time = self.utils.milisecondsToTime(miliseconds: self.currentTime, timeZone: (self.carWashInfo?.timeZone)! )
                    self.dialogController.message = "Выбраное время \(self.time)"
                if selected == 0 || selected == 4 {
                    self.showOrderDialog()
                }
                
            }
            catch{
                    self.stopAnimating()
            }
            
            self.stopAnimating()
        
//
        }
//        guard self.currentTime != 0 else{
//            return 0
//        }
        return self.currentTime
    }
    func orderWash(){
        startAnimating()
       
         var parameters = try! JSONEncoder().encode(OrderBodyCarWash.init(begin: currentTime, businessID: carWashInfo?.businessID, workerId: self.workerId, description: "IOS", packageID: self.text.text, servicesIDS: idServicePrice, targetID: nil, workingSpaceID: self.workSpaceId))
        if workerId != "" &&  self.carWashInfo?.businessCategory?.businessType == "CAR" {
            parameters = try! JSONEncoder().encode(OrderBodyCarWash.init(begin: currentTime, businessID: carWashInfo?.businessID, workerId: self.workerId, description: "IOS", packageID: self.text.text, servicesIDS: idServicePrice, targetID: targetId, workingSpaceID: self.workSpaceId))
            
        } else if workerId != ""{
             parameters = try! JSONEncoder().encode(OrderBodyCarWash.init(begin: currentTime, businessID: carWashInfo?.businessID, workerId: self.workerId, description: "IOS", packageID: self.text.text, servicesIDS: idServicePrice, targetID: nil, workingSpaceID: self.workSpaceId))
        } else if self.carWashInfo?.businessCategory?.businessType == "CAR" {
            parameters = try! JSONEncoder().encode(OrderBodyCarWash.init(begin: currentTime, businessID: carWashInfo?.businessID, workerId: nil, description: "IOS", packageID: self.text.text, servicesIDS: idServicePrice, targetID: targetId, workingSpaceID: self.workSpaceId))
        }
        let restUrl = constants.startUrl + "karma/v1/record"
//        self.worker = Worker.init(userID: nil, position: nil, businessID: nil, id: workerId, corporationID: nil, workTimes: nil, workingSpaceID: nil, user: nil)
//       
        
        let params = try! JSONSerialization.jsonObject(with: parameters, options: .allowFragments)as? [String: Any]
        Alamofire.request(restUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            
            self.stopAnimating()
       
           
//            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "mapViewController") as! MapViewController
//          self.navigationController?.pushViewController(newViewController, animated: true)
            self.utils.doneMassage(massage: "Заказ сделан", vc: self.view)
            self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "ordersTableViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
//            self.sideMenuViewController!.hideMenuViewController()
//            let newViewController = MapViewController()
//            self.navigationController?.pushViewController(newViewController, animated: true)
            
        }
    }
    
    
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
//        self.currentTime = self.utils.dateToMillisecond(date: didSelectDate, timeZone: (self.carWashInfo?.timeZone)!)
        self.getSelectTime(setTime: self.utils.dateToMillisecond(date: didSelectDate, timeZone: (self.carWashInfo?.timeZone)!), select: 0, completion: {
            
            if self.currentTime != 0 {
                picker.doneButtonTitle = "Свободно"
            
                picker.doneBackgroundColor = #colorLiteral(red: 0.2, green: 0.6, blue: 0, alpha: 1)
            } else{
                picker.doneButtonTitle = "Занято"
                picker.doneBackgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                //             TinyToast.shared.show(message: "Мойка не работает в данное{ время. Выберите другое время", valign: .center, duration: 1)
                
            }
        })
    }
    func addCategory(package: Package) {

        pricesPackage.removeAll()
        for price in (package.services)!{
            pricesPackage.append(price.price!)
        }
        let packageDuration = (package.duration)!
        let packagePrice = ((pricesPackage.reduce(0, +) - ((pricesPackage.reduce(0, +) * (package.discount)!) / 100)))
        let packageId = (package.id)!
        let discont = package.discount
        let packageName = package.name
        
            if self.packagePrice <= 0{
                removesumPriceDurations(price: self.packagePrice, duration: self.packageDuration, packageService: "PACKAGE")

                self.salerLable.text = "0"

                removeAll()

            }

            guard self.packageId == "" else{
                removeAll()
                removesumPriceDurations(price: self.packagePrice, duration: self.packageDuration, packageService: "PACKAGE")
                self.packageId = String(describing: packageId)
                self.packagePrice = packagePrice
                self.packageDuration = packageDuration
                self.salerLable.text = "\(discont!)"
                //            self.selectPackage.text = packageName
                voidView()
                //            viewDidLoad()
                selectedServices = servicesOld
                packegeServices = package.services!
                packetServicesTable.reloadData()
                packetServicesTable.isHidden = false
                packetServicesLable.isHidden = false
                
                salerLable.isHidden = false
                saleryLable.isHidden = false
                saleryLable2.isHidden = false
//                packageTableView.isHidden = false
                
//                packageTableView.visiblity(gone: false, dimension: packageTableView.contentScaleFactor, attribute: .height)
//                packageTableView.layoutIfNeeded()
            packetServicesTable.invalidateIntrinsicContentSize()
                filterServicesByPackages(packageId: packageId)
                view.layoutIfNeeded()
                return
            }
        removeAll()
        self.packageId = packageId
        self.packagePrice = packagePrice
        self.packageDuration = packageDuration
        self.salerLable.text = "\(discont!)"
        
        //        self.selectPackage.text = packageName
        voidView()
        //        viewDidLoad()
        selectedServices = servicesOld
        packegeServices = package.services!
        packetServicesTable.reloadData()
        packetServicesTable.isHidden = false
        packetServicesLable.isHidden = false
        
        salerLable.isHidden = false
        saleryLable.isHidden = false
        saleryLable2.isHidden = false
//        packageTableView.isHidden = false
//        packageTableView.visiblity(gone: false, dimension: packageTableView.contentScaleFactor, attribute: .height)
//        packageTableView.layoutIfNeeded()
        packetServicesTable.invalidateIntrinsicContentSize()
        filterServicesByPackages(packageId: packageId)
//        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "packetsDialog") as! PacketsDialog
//        customAlert.package = package
//        customAlert.providesPresentationContextTransitionStyle = true
//        customAlert.definesPresentationContext = true
//        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//        customAlert.delegate = self
//        self.present(customAlert, animated: true, completion: nil)

    }
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        if packageId != "" {
            addsumPriceDurations(price: packagePrice, duration: packageDuration)
            text.text = packageId
        }
    }
    @IBAction func remuvePackage(_ sender: Any) {
        removesumPriceDurations(price: packagePrice, duration: packageDuration, packageService: "PACKAGE")
        text.text = nil
        self.salerLable.text = "0"
    }
    
    func Dismiss(packageDuration: Int, packagePrice: Int, packageId: String, discont: Int, packageName: String) {
        if self.packagePrice <= 0{
            removesumPriceDurations(price: self.packagePrice, duration: self.packageDuration, packageService: "PACKAGE")
            
            self.salerLable.text = "0"
            
            removeAll()
            
        }
        guard packageId != "cancel" else{
//            self.pacetsSelector.selectItem(at: indexPackage, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
            self.pacetsSelector.select(indexPackage)
//            self.pacetsSelector?.select()
            return
        }
        guard self.packageId == "" else{
            removeAll()
            removesumPriceDurations(price: self.packagePrice, duration: self.packageDuration, packageService: "PACKAGE")
            self.packageId = packageId
            self.packagePrice = packagePrice
            self.packageDuration = packageDuration
            self.salerLable.text = "\(discont)"
//            self.selectPackage.text = packageName
            voidView()
//            viewDidLoad()
            selectedServices = servicesOld
            filterServicesByPackages(packageId: packageId)
            return
        }
        removeAll()
        self.packageId = packageId
        self.packagePrice = packagePrice
        self.packageDuration = packageDuration
        self.salerLable.text = "\(discont)"
        
//        self.selectPackage.text = packageName
        voidView()
//        viewDidLoad()
        selectedServices = servicesOld
        filterServicesByPackages(packageId: packageId)
    }
    func filterServicesByPackages(packageId: String){
        
            for packages in (carWashInfo?.packages)!{
                if packages.id == packageId{
                    for serviceP in packages.services!{
                        for serviceS in selectedServices{
                            if serviceS.id == serviceP.id{
                                selectedServices.remove2(serviceS)
                            
                        }
                    }
                }
            }
        }
        carServicePrice.reloadData()
        carServicePrice.invalidateIntrinsicContentSize()
    }
    func removeAll(){
        idServicePrice.removeAll()
        removesumPriceDurations(price: self.sumPrice, duration: self.sumDurations, packageService: "PACKAGE")
        self.sumPrice = 0
        self.sumDurations = 0
        self.durationArray.removeAll()
        self.priceArray.removeAll()
    }
    
    func filterServices(){
        let carInfo = self.utils.getCarInfo(key: "CARID")
        var checkAtribute = Bool()
        var checkClases = Bool()
        if selectedServices.count == 0 {
            selectedServices.removeAll()
        }
        for servicePrice in (carWashInfo?.servicePrices)!{
            if servicePrice.attributes!.count != 0 {
                for attribute in (servicePrice.attributes)!{
                    
                    checkAtribute = utils.filterArray(savedInfos: carInfo!.carAttributes, serverInfos: attribute.id!)
                    if checkAtribute == true {
                        if servicePrice.serviceClass?.count != 0 {
                            for service in (servicePrice.serviceClass)!{
                                checkClases = utils.filterArray(savedInfos: carInfo!.carAttributes, serverInfos: service.id!)
                                if checkClases == true {
                                    selectedServices.append(servicePrice)
                                    
                                }
                            }
                        }
                    }
                }
                
            } else {
                
                if servicePrice.serviceClass?.count != 0 {
                    for service in (servicePrice.serviceClass)!{
                        checkClases = utils.filterArray(savedInfos: carInfo!.carAttributes, serverInfos: service.id!)
                        if checkClases == true {
                            selectedServices.append(servicePrice)
                            
                        }
                    }
                } else {
                    selectedServices.append(servicePrice)
                }
            }
        }
        servicesOld.removeAll()
        servicesOld = selectedServices
        if selectedServices.count == 0{
            servicesLable.isEnabled = true
        } else {
            servicesLable.isEnabled = false
        }
        
        carServicePrice.reloadData()
        carServicePrice.invalidateIntrinsicContentSize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        guard utils.getSharedPref(key: "accessToken") != nil else{
//            stopAnimating()
//            return
//        }
       
        if worker != nil{
            workerName.text = (worker?.user?.firstName)! + " " + (worker?.user?.lastName)!
            workerPosition.text = worker?.position
            if let workerAvatar = worker?.user?.avatarURL{
                workerImage.downloaded(from: workerAvatar)
            }
        } else {
            workerName.text = "Любой мастер"
            workerPosition.text = ""
            workerImage.image = UIImage(named: "Ellipse")
        }
        if let carInfo = utils.getCarInfo(key: "CARID") {
            self.targetId = carInfo.carId
        }
        if pressOrderButton == true{
           
                orderButton(orderButton)
        }
        
    }
    
    func showTutorial() {
        let infoDesc = InfoDescriptor(for: "Здесь вы можете выбрать услуги / пакеты услуг, удобное для вас время и сделать заказ")
        var infoTask = PassthroughTask(with: [])
        infoTask.infoDescriptor = infoDesc
        
        
        let leftDesc = LabelDescriptor(for: "Тут Вы можете выбрать пакет услуг, или просмотреть его. Чтобы отменить выбраный пакет, выберите пункт 'Не Выбран' ")
        leftDesc.position = .bottom
        let leftHoleDesc = HoleViewDescriptor(view: pacetsSelector, type: .rect(cornerRadius: 5, margin: 10))
        leftHoleDesc.labelDescriptor = leftDesc
        let rightLeftTask = PassthroughTask(with: [leftHoleDesc])
        
        
        let leftDesc1 = LabelDescriptor(for: "Нажмите сюда если хотите выбрать время и завершить заказ ")
        leftDesc1.position = .bottom
        let leftHoleDesc1 = HoleViewDescriptor(view: orderButton, type: .rect(cornerRadius: 5, margin: 10))
        leftHoleDesc1.labelDescriptor = leftDesc1
        let rightLeftTask1 = PassthroughTask(with: [leftHoleDesc1])
        
        let leftDesc2 = LabelDescriptor(for: "Нажмите сюда если хотите выбрать исполнителя ")
        leftDesc2.position = .bottom
        let leftHoleDesc2 = HoleViewDescriptor(view: workerBtn, type: .rect(cornerRadius: 5, margin: 10))
        leftHoleDesc2.labelDescriptor = leftDesc2
        let rightLeftTask2 = PassthroughTask(with: [leftHoleDesc2])
      
        let cellDesc = LabelDescriptor(for: "Вы можете выбрать интересующие Вас услуги из данного списка")
        cellDesc.position = .bottom
        let cellHoleDesc = CellViewDescriptor(tableView: self.carServicePrice, indexPath: IndexPath(row: 0, section: 0), forOrientation: .any)
        cellHoleDesc.labelDescriptor = cellDesc
        let cellTask = PassthroughTask(with: [cellHoleDesc])
        
//        if carWashInfo?.workers!.count == 0 || carWashInfo?.workers == nil{
//
//            PassthroughManager.shared.display(tasks: [infoTask, rightLeftTask, cellTask]) {
//                isUserSkipDemo in
//                if self.carWashInfo?.workers!.count == 0 || self.carWashInfo?.workers == nil{
//                    self.utils.checkFilds(massage: "У этой компании нет возможности записи онлайн. Вы можете сделать заказ по телефону", vc: self.view)
//                    self.workerView.visiblity(gone: true)
//                    self.workerView.isHidden = true
//                    self.orderButton.isHidden = true
//                    self.callUsView.isHidden = false
//
//                    self.view.layoutIfNeeded()
//                }
//                print("isUserSkipDemo: \(isUserSkipDemo)")
//            }
//        } else if carWashInfo?.servicePrices?.count == 0 || carWashInfo?.servicePrices == nil{
//
//            } else  if carWashInfo?.packages?.count != 0 {
//            PassthroughManager.shared.display(tasks: [infoTask, cellTask, rightLeftTask1, rightLeftTask2]) {
//                isUserSkipDemo in
//                if self.carWashInfo?.workers!.count == 0 || self.carWashInfo?.workers == nil{
//                    self.utils.checkFilds(massage: "У этой компании нет возможности записи онлайн. Вы можете сделать заказ по телефону", vc: self.view)
//                    self.workerView.visiblity(gone: true)
//                    self.workerView.isHidden = true
//                    self.orderButton.isHidden = true
//                    self.callUsView.isHidden = false
//
//                    self.view.layoutIfNeeded()
//                }
//                print("isUserSkipDemo: \(isUserSkipDemo)")
//            }
//
//        } else {
            PassthroughManager.shared.display(tasks: [infoTask]) {
                isUserSkipDemo in
                if self.carWashInfo?.workers!.count != 0 || self.carWashInfo?.workers != nil{
                    for workerCheck in (self.carWashInfo?.workers)!{
                        if workerCheck.workingSpaceID != nil{
                            self.checkedWorker.append(workerCheck)
                        }
                    }
                    if self.checkedWorker.count == 0 || self.carWashInfo?.spaces?.count == 0{
                        self.utils.checkFilds(massage: "У этой компании нет возможности записи онлайн. Вы можете сделать заказ по телефону", vc: self.view)
                        self.workerView.visiblity(gone: true)
                        self.workerView.isHidden = true
                        self.orderButton.isHidden = true
                        self.callUsView.isHidden = false
                        
                        //            view.layoutIfNeeded()
                    }
                } else {
                    self.utils.checkFilds(massage: "У этой компании нет возможности записи онлайн. Вы можете сделать заказ по телефону", vc: self.view)
                    self.workerView.visiblity(gone: true)
                    self.workerView.isHidden = true
                    self.orderButton.isHidden = true
                    self.callUsView.isHidden = false
                }
                print("isUserSkipDemo: \(isUserSkipDemo)")
//            }
        }
    }
    
    func showSelectTimeDialog(enable: Bool) {
        
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "setTimeDialog") as! SetTimeDialog
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.enable = enable
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        self.present(customAlert, animated: true, completion: nil)
        
    }
    
    func DismissTime(currentTime: Int) {
        
        if currentTime == 0{
            getCurrentTime(setTime: self.utils.currentTimeInMiliseconds(timeZone: (self.carWashInfo?.timeZone)!), selected: 0)
            
        }
        if currentTime == 1{
           showDateTimePikerDialog()
        }
    }
//    func Dissmis
    func showOrderDialog() {
     
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "orderDialog") as! OrderDialog
        customAlert.selectedTime = self.utils.milisecondsToTime(miliseconds: self.currentTime, timeZone: (self.carWashInfo?.timeZone)! )
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        self.present(customAlert, animated: true, completion: nil)
        
    }
    func DismissOrder(select: Bool) {
        if select == true{
            orderWash()
        }else{
            showSelectTimeDialog(enable: true)
        }
    }
    func showDateTimePikerDialog(){
        let min = Date().addingTimeInterval(-60)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 30)
        let date = Date(timeIntervalSince1970: TimeInterval(currentTime/1000))
        let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
        picker.includeMonth = true // if true the month shows at bottom of date cell
        picker.highlightColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
        picker.darkColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
        picker.cancelButtonTitle = "Закрыть"
        picker.doneButtonTitle = "Выберите время"
        picker.doneBackgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        picker.completionHandler = { date in
            self.currentTime = self.utils.dateToMillisecond(date: date, timeZone: (self.carWashInfo?.timeZone)!)
            self.getSelectTime(setTime: self.currentTime, select: 4, completion: {})
//            self.showOrderDialog()
        }
        
//        picker.completionHandler!(picker.selectedDate)
        
//        picker.dismissHandler = self.dis.dismiss()
        picker.delegate = self
        //                        picker.delegate = self as! DateTimePickerDelegate
        picker.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        voidView()
        utils.checkPushNot(vc: self)
    }
    func getSelectTime(setTime: Int, select: Int,completion : @escaping ()->()) {
        let restUrl = constants.startUrl + "karma/v1/record/free-time"
        //       utils.currentTimeInMiliseconds(timeZone: (carWashInfo?.timeZone)!)
        startAnimating()
//        self.worker = Worker.init(userID: nil, position: nil, businessID: nil, id: workerId, corporationID: nil, workTimes: nil, workingSpaceID: nil, user: nil)
        var parameters = try! JSONEncoder().encode(OrderBodyCarWash.init(begin: setTime, businessID: carWashInfo?.businessID, workerId: nil, description: "IOS", packageID: self.text.text, servicesIDS: idServicePrice, targetID: utils.getSharedPref(key: "CARID"), workingSpaceID: nil))
        
        if workerId != "" &&  self.carWashInfo?.businessCategory?.businessType == "CAR" {
            parameters = try! JSONEncoder().encode(OrderBodyCarWash.init(begin: setTime, businessID: carWashInfo?.businessID, workerId: self.workerId, description: "IOS", packageID: self.text.text, servicesIDS: idServicePrice, targetID: targetId, workingSpaceID: self.workSpaceId))
            
        } else if workerId != ""{
            parameters = try! JSONEncoder().encode(OrderBodyCarWash.init(begin: setTime, businessID: carWashInfo?.businessID, workerId: self.workerId, description: "IOS", packageID: self.text.text, servicesIDS: idServicePrice, targetID: nil, workingSpaceID: self.workSpaceId))
        } else if self.carWashInfo?.businessCategory?.businessType == "CAR" {
            parameters = try! JSONEncoder().encode(OrderBodyCarWash.init(begin: setTime, businessID: carWashInfo?.businessID, workerId: nil, description: "IOS", packageID: self.text.text, servicesIDS: idServicePrice, targetID: targetId, workingSpaceID: self.workSpaceId))
        }

        let params = try! JSONSerialization.jsonObject(with: parameters, options: .allowFragments)as? [String: Any]
        Alamofire.request(restUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]).responseCurrentFreeTime { response  in
            guard response.response?.statusCode != 500 else{
                self.utils.checkServer(vc: self)

                    self.stopAnimating()
                    return
                }
                guard response.result.error == nil else {
                    self.utils.checkServer(vc: self)

//                    SCLAlertView().showError("Внимание!", subTitle: "Нет связи с сервером", closeButtonTitle: "Закрыть")
                    self.view.endEditing(true)
                    
                    self.stopAnimating()
                    return
                }
            
                guard response.response?.statusCode != 400 else {
                    self.stopAnimating()
                    self.currentTime = 0
                    if select == 4 {
                        self.showDateTimePikerDialog()
//                        TinyToast.shared.show(message: "Точка не работает в это время", valign: .center, duration: 1)
                    }
                    completion()
                    return
                }
                if let currentFreeTime = response.result.value{
                guard currentFreeTime.begin != nil else{
                    return
                }
                if select == 4 {
                    self.showOrderDialog()
                    
                    self.time = self.utils.milisecondsToTime(miliseconds: self.currentTime, timeZone: (self.carWashInfo?.timeZone)! )
                }
                if self.workerId == ""{
                    self.workerId = currentFreeTime.workerID!
                }
                self.currentTime = currentFreeTime.begin!
                self.workSpaceId = currentFreeTime.workingSpaceID!
                self.time = self.utils.milisecondsToTime(miliseconds: self.currentTime, timeZone: (self.carWashInfo?.timeZone)! )
                self.dialogController.message = "Выбраное время \(self.time)"
                   
            self.stopAnimating()
                    
            //
                }
        //        guard self.currentTime != 0 else{
        //            return 0
            
            completion()
                }
    }
    
//    func getWorkers(){
//
//        let restUrl = constants.startUrl + "karma/v1/worker/by-business?businessId=" + (carWashInfo?.id!)!
//
//        let headers = ["Application-Id":self.constants.iosId]
//        Alamofire.request(restUrl, method: .get, headers: headers).responseJSON { response in
//            guard self.utils.checkResponse(response: response, vc: self) == true else{
//                self.stopAnimating()
//                return
//            }
//
//            do{
//
//                let responseBody = try JSONDecoder().decode(WorkerByBuisnesBody.self, from: response.data!)
//                self.workers = responseBody
//
//
//            }catch{
//                print(error)
//            }
//
//        }
//    }
    func CreateCarDismiss() {
//        getAllCars()
        self.createCar = true

       
    }
    
    func getAllCars(){
        startAnimating()
        let restUrl = constants.startUrl + "karma/v1/car/user"
        guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
            
            self.utils.checkAutorization(vc: self)
            stopAnimating()
            return
        }
        let headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]
        Alamofire.request(restUrl, method: .get, headers: headers).responseJSON { response  in
            guard response.response?.statusCode != 204 else{
            
                self.createCar = true
                self.stopAnimating()
                return
            }
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            
            
            do{
                let carList = try JSONDecoder().decode(AllCarList.self, from: response.data!)
                
                if carList.count == 0 {
                    
                    self.createCar = true
                }
            }
            catch{
                
            }
            self.stopAnimating()
            
            
        }
    }
}

