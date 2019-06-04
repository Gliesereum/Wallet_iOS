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
import DateTimePicker

class OrderWash: UIViewController, EHHorizontalSelectionViewProtocol, UITableViewDataSource, UITableViewDelegate, DateTimePickerDelegate, NVActivityIndicatorViewable, UIPopoverPresentationControllerDelegate, DialodDismissDelegate, SetTimeDialogDismissDelegate, OrderDialogDismissDelegate{
    @IBOutlet weak var carServicePrice: UITableView!
    var carWashInfo: CarWashBody? = nil
    @IBOutlet weak var pacetsSelector: EHHorizontalSelectionView!
    
    @IBOutlet weak var packageLabel: UILabel!
    @IBOutlet weak var allDurations: UILabel!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var salerLable: UILabel!
    
    @IBOutlet weak var allPrice: UILabel!

    let timepicker = DateTimePicker()
    let utils = Utils()
    let constants = Constants()
    var durationArray: [Int] = []
    var priceArray: [Int] = []
    var idServicePrice: [String] = []
    var sumPrice = Int()
    var sumDurations = Int()
    var packagesList: [String] = ["Не выбран"]
    var packageDuration = Int()
    var packagePrice : Int = 0
    var packageId: String = ""
    var currentTime = Int()
    var workSpaceId = String()
    var time = String()
    var counter = false
    var selectedServices = [Serviceice]()
    let dialogController = AZDialogViewController(title: "Выберите время", message: "Время не выбрато")
    
    let cellSpacingHeight: CGFloat = 5
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        utils.setBorder(view: headerView, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
        filterServices()
        carServicePrice.tableFooterView = UIView()
        addsumPriceDurations(price: 0, duration: 0)
        if carWashInfo?.packages?.count != 0 {
            for package in (carWashInfo?.packages)!{
                packagesList.append(package.name!)
            }
        } else {
            pacetsSelector.visiblity(gone: true)
            packageLabel.visiblity(gone: true)
        }
        carServicePrice.rowHeight = UITableView.automaticDimension
        carServicePrice.allowsMultipleSelection = true
        carServicePrice.allowsMultipleSelectionDuringEditing = true
        pacetsSelector.delegate = self

        if packageId != "" {
            addsumPriceDurations(price: packagePrice, duration: packageDuration)
            text.text = packageId
        }
        // Do any additional setup after loading the view.
        
    }
    

   
    // MARK: - Navigation

    @IBAction func orderButton(_ sender: Any) {
//        getCurrentTime()
        guard sumPrice != 0 else{
            utils.checkFilds(massage: "Выберите услуги", vc: self.view)
            return
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
        return packagesList[Int(index)]
    }
    
    func horizontalSelection(_ selectionView: EHHorizontalSelectionView, didSelectObjectAt index: UInt) {
//        text.text = arrayPacets[Int(index)]
       
        guard index != 0 else{
            if text.text != nil{
                remuvePackage(self)
                
            }
            return
        }
        addCategory(package: (carWashInfo?.packages![Int(index) - 1])!)
        
    
    }

//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.arrayPacets.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pacetsCell", for: indexPath as IndexPath) as! CastomPacetsCell
//        cell.pacets.text = self.arrayPacets[indexPath.item] as! String
//        return cell
//    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedServices.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customServicesPrice", for: indexPath) as! CustomServicesPrice
        let carServicePrices = selectedServices[indexPath.section]
        
        utils.setBorder(view: cell, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.isSelected{
            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
        } else {
            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
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
            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
            
        }, completion:nil)
        addsumPriceDurations(price: Int(cell.price.text!)!, duration: Int(cell.time.text!)!)
        idServicePrice.append(cell.id.text!)
       
        
    }
    func addsumPriceDurations(price: Int, duration: Int)  {
        startAnimating()
        durationArray.append(duration)
        sumDurations = durationArray.reduce(0, +)
        allDurations.text = "\u{231B}" + String(sumDurations) + " мин."
        priceArray.append(price)
        sumPrice = priceArray.reduce(0, +)
        allPrice.text = "💵" + String(sumPrice) + " грн."
        stopAnimating()
    }
    func removesumPriceDurations(price: Int, duration: Int)  {
        sumPrice = sumPrice - price
        allPrice.text = "💵" + String(sumPrice) + " грн."
        if priceArray.firstIndex(of: price) != nil {
        priceArray.remove(at: priceArray.firstIndex(of: price)!)
        }
        
        sumDurations = sumDurations - duration
        allDurations.text = "\u{231B}" + String(sumDurations) + " мин."
         if durationArray.firstIndex(of: duration) != nil {
        durationArray.remove(at: durationArray.firstIndex(of: duration)!)
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
            cell.contentView.backgroundColor = .white
            
        }, completion:nil)
        removesumPriceDurations(price: Int(cell.price.text!)!, duration: Int(cell.time.text!)!)
        idServicePrice.remove(at: idServicePrice.firstIndex(of: cell.id.text!)!)
      
    }
    
    func getCurrentTime(setTime: Int, selected: Int) -> Int {
        let restUrl = constants.startUrl + "karma/v1/record/free-time"
//       utils.currentTimeInMiliseconds(timeZone: (carWashInfo?.timeZone)!)
        startAnimating()
        let parameters = try! JSONEncoder().encode(OrderBodyCarWash.init(begin: setTime, businessID: carWashInfo?.businessID, description: "IOS", packageID: self.text.text, servicesIDS: idServicePrice, targetID: utils.getSharedPref(key: "CARID"), workingSpaceID: nil))
        let params = try! JSONSerialization.jsonObject(with: parameters, options: .allowFragments)as? [String: Any]
        Alamofire.request(restUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization": (self.utils.getSharedPref(key: "accessToken"))!]).responseJSON { response  in
            do{
                guard response.response?.statusCode != 500 else{ self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "mapViewController")), animated: true)
                self.sideMenuViewController!.hideMenuViewController()
                SCLAlertView().showError("Внимание!", subTitle: "Нет связи с сервером", closeButtonTitle: "Закрыть")
                //            TinyToast.shared.show(message: "Нет связи с сервером", valign: .bottom, duration: .normal)
                    
                    self.stopAnimating()
                return
                }
                guard response.result.error == nil else {
                    SCLAlertView().showError("Внимание!", subTitle: "Нет связи с сервером", closeButtonTitle: "Закрыть")
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
                    if selected != 3{
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
                
                    self.currentTime = currentFreeTime.begin!
                    self.workSpaceId = currentFreeTime.workingSpaceID!
                self.time = self.utils.milisecondsToTime(miliseconds: self.currentTime, timeZone: (self.carWashInfo?.timeZone)! )
                    self.dialogController.message = "Выбраное время \(self.time)"
                if selected == 0 {
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
        let restUrl = constants.startUrl + "karma/v1/record"
        let carInfo = utils.getCarInfo(key: "CARID")!
        let parameters = try! JSONEncoder().encode(OrderBodyCarWash.init(begin: currentTime, businessID: carWashInfo?.businessID, description: "IOS", packageID: self.text.text, servicesIDS: idServicePrice, targetID: carInfo.carId, workingSpaceID: self.workSpaceId))
        let params = try! JSONSerialization.jsonObject(with: parameters, options: .allowFragments)as? [String: Any]
        Alamofire.request(restUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization": (self.utils.getSharedPref(key: "accessToken"))!]).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            
            self.stopAnimating()
       
           
//            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "mapViewController") as! MapViewController
//          self.navigationController?.pushViewController(newViewController, animated: true)
            self.utils.doneMassage(massage: "Заказ сделан", vc: self.view)
        self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "ordersTableViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
//            self.sideMenuViewController!.hideMenuViewController()
//            let newViewController = MapViewController()
//            self.navigationController?.pushViewController(newViewController, animated: true)
            
        }
    }
    
    func showDialog(){
        
        time = self.utils.milisecondsToDate(miliseconds: self.currentTime)
        if counter == true {
            dialogController.removeAllActions()
        }
        self.counter = true
        
        
       
                    dialogController.dismissDirection = .bottom
                    dialogController.titleColor = .black
                    dialogController.messageColor = .black
                    dialogController.dismissWithOutsideTouch = true
        
                    let primary = #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1)
        
        
                    dialogController.buttonStyle = { (button,height,position) in
                        button.tintColor = .black
                        button.backgroundColor = .white
                        button.layer.masksToBounds = true
                        button.setTitleColor(UIColor.black, for: [])
                        button.layer.masksToBounds = true
                        button.layer.borderColor = primary.cgColor
        
                    }
        
        
                    dialogController.cancelEnabled = true
                    dialogController.cancelButtonStyle = { (button, height) in
                        button.tintColor = primary
                        button.setTitle("Отмена", for: [])
                        return true
                    }
       
        
                    dialogController.addAction(AZDialogAction(title: "Ближайшее время", handler: { (dialog) -> (Void) in
        
                        self.time = self.utils.milisecondsToDate(miliseconds: self.getCurrentTime(setTime: self.utils.currentTimeInMiliseconds(timeZone: (self.carWashInfo?.timeZone)!), selected: 1))
                        self.dialogController.message = "Ближайшее время \(self.time)"
                        
                    }))
        
                    dialogController.addAction(AZDialogAction(title: "Выбрать время", handler: { (dialog) -> (Void) in
                        let min = Date().addingTimeInterval(-60)
                        let max = Date().addingTimeInterval(60 * 60 * 24 * 30)
                        let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
                        picker.includeMonth = true // if true the month shows at bottom of date cell
                        picker.highlightColor = .black
                        picker.darkColor = UIColor.darkGray
                        picker.doneButtonTitle = "Выберите время"
                        picker.doneBackgroundColor = .black
                        picker.completionHandler = { date in
                            let formatter = DateFormatter()
                            formatter.dateFormat = "hh:mm aa dd/MM/YYYY"
                            self.title = formatter.string(from: date)
                        }
                        picker.delegate = self
//                        picker.delegate = self as! DateTimePickerDelegate
                        picker.show()
                      
                        
                       
                    }))
        
                    dialogController.addAction(AZDialogAction(title: "Заказать", handler: { (dialog) -> (Void) in
                        self.orderWash()
                        dialog.dismiss()
                    }))
        
        
                    dialogController.show(in: self)
    }
    
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
//        self.currentTime = self.utils.dateToMillisecond(date: didSelectDate, timeZone: (self.carWashInfo?.timeZone)!)
        guard self.getSelectTime(setTime: self.utils.dateToMillisecond(date: didSelectDate, timeZone: (self.carWashInfo?.timeZone)!)) != 0 else{
            picker.doneButtonTitle = "Выберите другое время"
//             TinyToast.shared.show(message: "Мойка не работает в данное время. Выберите другое время", valign: .center, duration: 1)
            return
        }
        picker.doneButtonTitle = "Выбрать это время"
    }
    func addCategory(package: Package) {
        
//        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "packetsDialog") as! PacketsDialog
//        popoverContent.package = package
//        popoverContent.carWashInfo = carWashInfo
//        let nav = UINavigationController(rootViewController: popoverContent)
//        nav.modalPresentationStyle = UIModalPresentationStyle.popover
//        let popover = nav.popoverPresentationController
//        popover!.delegate = self
//        popover!.sourceView = self.view
//        popover!.sourceRect = CGRect(x: 100, y: 100, width: 0, height: 0)
//
//        self.present(nav, animated: true, completion: nil)
//        popover?.dismissalTransitionDidEnd(true)
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "packetsDialog") as! PacketsDialog
        customAlert.package = package
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        self.present(customAlert, animated: true, completion: nil)
        
    }
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        if packageId != "" {
            addsumPriceDurations(price: packagePrice, duration: packageDuration)
            text.text = packageId
        }
    }
    @IBAction func remuvePackage(_ sender: Any) {
        removesumPriceDurations(price: packagePrice, duration: packageDuration)
        text.text = nil
        self.salerLable.text = "0%"
    }
    
    func Dismiss(packageDuration: Int, packagePrice: Int, packageId: String, discont: Int) {
        if self.packagePrice <= 0{
            removesumPriceDurations(price: self.packagePrice, duration: self.packageDuration)
            
            self.salerLable.text = "0%"
        }
        guard packageId != "cancel" else{
//            self.pacetsSelector?.select()
            return
        }
        guard self.packageId == "" else{
            removesumPriceDurations(price: self.packagePrice, duration: self.packageDuration)
            self.packageId = packageId
            self.packagePrice = packagePrice
            self.packageDuration = packageDuration
            self.salerLable.text = "\(discont)%"
            viewDidLoad()
            return
        }
        self.packageId = packageId
        self.packagePrice = packagePrice
        self.packageDuration = packageDuration
        self.salerLable.text = "\(discont)%"
        viewDidLoad()
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard utils.getSharedPref(key: "accessToken") != nil else{
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
            self.utils.checkFilds(massage: "Авторизируйтесь", vc: self.view)
            stopAnimating()
            return
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
        customAlert.selectedTime = time
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
        let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
        picker.includeMonth = true // if true the month shows at bottom of date cell
        picker.highlightColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
        picker.darkColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
        picker.doneButtonTitle = "Выберите время"
        picker.doneBackgroundColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm aa dd/MM/YYYY"
            self.title = formatter.string(from: date)
        }
        picker.dismissHandler = showOrderDialog
        picker.delegate = self
        //                        picker.delegate = self as! DateTimePickerDelegate
        picker.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        utils.checkPushNot(vc: self)
    }
    func getSelectTime(setTime: Int) -> Int {
        let restUrl = constants.startUrl + "karma/v1/record/free-time"
        //       utils.currentTimeInMiliseconds(timeZone: (carWashInfo?.timeZone)!)
        startAnimating()
        let parameters = try! JSONEncoder().encode(OrderBodyCarWash.init(begin: setTime, businessID: carWashInfo?.businessID, description: "IOS", packageID: self.text.text, servicesIDS: idServicePrice, targetID: utils.getSharedPref(key: "CARID"), workingSpaceID: nil))
        let params = try! JSONSerialization.jsonObject(with: parameters, options: .allowFragments)as? [String: Any]
        Alamofire.request(restUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization": (self.utils.getSharedPref(key: "accessToken"))!]).responseCurrentFreeTime { response  in
                guard response.response?.statusCode != 500 else{ self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "mapViewController")), animated: true)
                    self.sideMenuViewController!.hideMenuViewController()
                    SCLAlertView().showError("Внимание!", subTitle: "Нет связи с сервером", closeButtonTitle: "Закрыть")
                    //            TinyToast.shared.show(message: "Нет связи с сервером", valign: .bottom, duration: .normal)
                    
                    self.stopAnimating()
                    return
                }
                guard response.result.error == nil else {
                    SCLAlertView().showError("Внимание!", subTitle: "Нет связи с сервером", closeButtonTitle: "Закрыть")
                    self.view.endEditing(true)
                    
                    self.stopAnimating()
                    return
                }
            
                guard response.response?.statusCode != 400 else {
                    self.stopAnimating()
                    self.currentTime = 0
                    //                    TinyToast.shared.show(message: errorBody.message!, valign: .bottom, duration: .normal)
                    return
                }
                if let currentFreeTime = response.result.value{
                guard currentFreeTime.begin != nil else{
                    return
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
                }
        return self.currentTime
    }
}

