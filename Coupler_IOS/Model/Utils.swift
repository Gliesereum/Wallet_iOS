//
//  File.swift
//  Karma
//
//  Created by macbook on 12/12/2018.
//  Copyright © 2018 Gliesereum. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CoreLocation

class Utils {
  
    
    let preferences = UserDefaults.standard
    var dateFormatter = DateFormatter()
    let constants = Constants()
    let GMJson = "[ { \"featureType\": \"poi.attraction\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"poi.business\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"poi.government\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"poi.medical\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"poi.park\", \"stylers\": [ { \"visibility\": \"simplified\" } ] }, { \"featureType\": \"poi.place_of_worship\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"poi.school\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"poi.sports_complex\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"transit.line\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"transit.station\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"transit.station.airport\", \"stylers\": [ { \"visibility\": \"off\" } ] }, { \"featureType\": \"transit.station.bus\", \"stylers\": [ { \"visibility\": \"off\" } ] } ]"
   
    //Show any Tost
//    func showToast(message : String, viewController: UIViewController) {
//
//        let toastLabel = UILabel(frame: CGRect(x: viewController.view.frame.size.width/2 - 75, y: viewController.view.frame.size.height-100, width: 300, height: 35))
//        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        toastLabel.textColor = UIColor.white
//        toastLabel.textAlignment = .center;
//        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
//        toastLabel.text = message
//        toastLabel.alpha = 1.0
//        toastLabel.layer.cornerRadius = 10;
//        toastLabel.clipsToBounds  =  true
//        viewController.view.addSubview(toastLabel)
//        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
//            toastLabel.alpha = 0.0
//        }, completion: {(isCompleted) in
//            toastLabel.removeFromSuperview()
//        })
//    }
    
    //Set any to Shared Preferens
    func setSaredPref(key: String, value: String) {
        preferences.set(value, forKey: key)
        preferences.synchronize()
    }
    
    //Get any from Shared Preferens
    func getSharedPref(key: String) -> String? {
       
        guard let value = preferences.string(forKey: key) else{
            return nil
        }
        
        return value
    }
    
    //Set any to Shared Preferens
    func setCarInfo(key: String, value: SelectedCarInfo) {
        let userDefaults = UserDefaults.standard
        let encodedData: Data?
            encodedData = try! NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
            userDefaults.set(encodedData, forKey: key)
            userDefaults.synchronize()
        
    }
    
    func setBusiness(key: String, value: BuisnessBodyElement) {
        let userDefaults = UserDefaults.standard
        let encodedData: Data?
        encodedData = try! NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
        userDefaults.set(encodedData, forKey: key)
        userDefaults.synchronize()
        
    }
    //Set any to Shared Preferens
    func setAny(key: String, value: Any) {
        let userDefaults = UserDefaults.standard
        let encodedData: Data?
        encodedData = try! NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
        userDefaults.set(encodedData, forKey: key)
        userDefaults.synchronize()
        
    }
    //CarWashBody
    func setCarWashBody(key: String, value: CarWashBody) {
        let userDefaults = UserDefaults.standard
//        let encodedData: Data?
        let encoder = JSONEncoder()
        let encoded = try? encoder.encode(value)
//        encodedData = try! NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
        userDefaults.set(encoded, forKey: key)
        userDefaults.synchronize()
        
    }
    func getCarWashBody(key: String) -> CarWashBody? {
        let userDefaults = UserDefaults.standard
        guard let decoded  = userDefaults.object(forKey: key) as? Data else{
            return nil
        }
        
        let decoder = JSONDecoder()
        let decodedTeams = try! decoder.decode(CarWashBody.self, from: decoded)
//            NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as! CarWashBody
        
        return decodedTeams
    }
    //Get any from Shared Preferens
    func getCarInfo(key: String) -> SelectedCarInfo? {
        let userDefaults = UserDefaults.standard
        guard let decoded  = userDefaults.object(forKey: key) as? Data else{
            return nil
        }
        let decodedTeams = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as! SelectedCarInfo
        
        return decodedTeams
    }
    func getBuisness(key: String) -> BuisnessBodyElement? {
        let userDefaults = UserDefaults.standard
        guard let decoded  = userDefaults.object(forKey: key) as? Data else{
            return nil
        }
        let decodedTeams = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as! BuisnessBodyElement
        
        return decodedTeams
    }
    
    //Get any from Shared Preferens
    func getAny(key: String) -> Any? {
        let userDefaults = UserDefaults.standard
        guard let decoded  = userDefaults.object(forKey: key) as? Data else{
            return nil
        }
        let decodedTeams = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as Any
        
        return decodedTeams
    }
    
    func checkAutorization(vc: UIViewController){
        let customAlert = vc.storyboard?.instantiateViewController(withIdentifier: "siginViewController") as! SiginViewController
        customAlert.poper = true
        customAlert.vc = vc
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.popover
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        vc.present(customAlert, animated: true, completion: nil)
        
    }
    
    func checkServer(vc: UIViewController){
        let customAlert = vc.storyboard?.instantiateViewController(withIdentifier: "checkServer") as! CheckServer
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.popover
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        vc.present(customAlert, animated: true, completion: nil)
        
    }
   
    //check responce status code
    func checkResponseStatusCode(code : Int) -> String {
        switch code {
//        case 204:
//            return
//            showToast(message: "Нет ничего", viewController: viewController)
        case 1491:
            return NSLocalizedString("E1491", comment: "")
//            showToast(message: "Value is empty", viewController: viewController)
        case 1492:
            return NSLocalizedString("E1492", comment: "")
//            showToast(message: "Code is empty", viewController: viewController)
        case 1493:
            return NSLocalizedString("E1493", comment: "")
//            showToast(message: "Type is empty", viewController: viewController)
        case 1164:
            return NSLocalizedString("E1164", comment: "")
//            showToast(message: "Verification code not correct try again", viewController: viewController)
        case 1046:
            return NSLocalizedString("E1046", comment: "")
//            showToast(message: "User is anonymous", viewController: viewController)
        case 9000:
            return NSLocalizedString("E9000", comment: "")
//            showToast(message: "Server error", viewController: viewController)
        case 9001:
            return NSLocalizedString("E9001", comment: "")
//            showToast(message: "Service not available now", viewController: viewController)
       
        case 1426:
            return NSLocalizedString("E1426", comment: "")
//            showToast(message: "Service not choose", viewController: viewController)
       
        case 1430:
            return NSLocalizedString("E1430", comment: "")
//            showToast(message: "Not enough time for create record, choose another time", viewController: viewController)
    
        case 1434:
            return NSLocalizedString("E1434", comment: "")
//            showToast(message: "CarWash don't work this day", viewController: viewController)
        case 1435:
            return NSLocalizedString("E1435", comment: "")
//            showToast(message: "CarWash don't work this time", viewController: viewController)
     
        case 1439:
            return NSLocalizedString("E1439", comment: "")
//            showToast(message: "Try to choose past time", viewController: viewController)
      

        default:
            return NSLocalizedString("prest_error", comment: "") + " " + String(code)
//            showToast(message: "...", viewController: viewController)
        }
    }
    func currentTimeInMiliseconds(timeZone: Int) -> Int {
        let currentDate = NSDate()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let date = dateFormatter.date(from: dateFormatter.string(from: currentDate as Date))
        let nowDouble = date!.timeIntervalSince1970
        return Int(nowDouble*1000) + timeZone*60000
    }
    func milisecondsToDate(miliseconds: Int) -> String {
//        let dateVar = Date(timeIntervalSince1970: TimeInterval((miliseconds - 7000000)/1000))
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone 
        let dateVar = Date(timeIntervalSince1970: TimeInterval(miliseconds/1000))

//            Date.init(timeIntervalSinceNow: NSTimeIntervalSince1970(miliseconds)/1000)
        dateFormatter.dateFormat = "dd.MM.yy - HH:mm"
        return dateFormatter.string(from: dateVar)
    }
//    
//    func getImageFromSVG(name: String) -> UIImage {
//        let namSvgImgVar: SVGKImage = SVGKImage(named: name)
////        let namSvgImgVyuVar = SVGKFastImageView(svgkImage: namSvgImgVar)
//        let namImjVar: UIImage = namSvgImgVar.uiImage
//        return namImjVar
//    }
    
    func dateToMillisecond(date: Date, timeZone: Int) -> Int {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let date = dateFormatter.date(from: dateFormatter.string(from: date as Date))
        let nowDouble = date!.timeIntervalSince1970
        return Int(nowDouble*1000) + timeZone*60000
    }
    func checkResponse(response: DataResponse<Any>, vc: UIViewController) -> Bool {
        guard response.response?.statusCode != 500 else{
            checkServer(vc: vc)
//            vc.view.endEditing(true)
//
//            vc.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: vc.storyboard!.instantiateViewController(withIdentifier: "selectSingleBuisnesVC")), animated: true)
//            vc.sideMenuViewController!.hideMenuViewController()
//            SCLAlertView().showError("Внимание!", subTitle: "Нет связи с сервером", closeButtonTitle: "Закрыть")
//            TinyToast.shared.show(message: "Нет связи с сервером", valign: .bottom, duration: .normal)
            return false
        }
        guard response.result.error == nil else {
            checkServer(vc: vc)
//                 SCLAlertView().showError("Внимание!", subTitle: "Нет связи с сервером", closeButtonTitle: "Закрыть")
//                TinyToast.shared.show(message: "Нет связи с сервером", valign: .bottom, duration: .normal)
            
            vc.view.endEditing(true)
                return false
            }
        do{
//            guard response.response?.statusCode != 204 else{
//            SCLAlertView().showWarning("Внимание!", subTitle: "Нет данных", closeButtonTitle: "Закрыть")
//            //                TinyToast.shared.show(message: "Нет данных", valign: .bottom, duration: .normal)
//            return false
//            }
            guard response.response?.statusCode == 200 else{
                let errorBody = try JSONDecoder().decode(ErrorBody.self, from: response.data!)
                guard errorBody.code != 1104 else{
                    refreshToken()
                    return false
                }
               
                guard checkResponseStatusCode(code: errorBody.code!) != "..." else{
                    return true
                }
                guard errorBody.code != 1102 else{
                    deleteToken()
                    
                    vc.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: vc.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
                    vc.sideMenuViewController!.hideMenuViewController()
                    return false
                }
                vc.view.endEditing(true)
                SCLAlertView().showWarning(NSLocalizedString("Attention", comment: ""), subTitle: checkResponseStatusCode(code: errorBody.code!), closeButtonTitle: NSLocalizedString("Clouse", comment: ""))
//                    TinyToast.shared.show(message: errorBody.message!, valign: .bottom, duration: .normal)
            return false
            }
        }
        catch{
            print(error)
                    
        }
            // make sure we got some JSON since that's what we expect
        
       
            
       
        return true
    }
    
    func deleteToken(){
      
            UserDefaults.standard.removeObject(forKey: "accessToken")
            UserDefaults.standard.removeObject(forKey: "refreshToken")
            UserDefaults.standard.removeObject(forKey: "CARID")
            UserDefaults.standard.removeObject(forKey: "USERAVATAR")
            UserDefaults.standard.removeObject(forKey: "USER")
            UserDefaults.standard.removeObject(forKey: "REGISTRATIONTOKEN")
    }
    func refreshToken(){
        let restUrl = constants.startUrl + "account/v1/auth/refresh"
        let toDo: [String: String]  = ["refreshToken": getSharedPref(key: "refreshToken")!]
        Alamofire.request(restUrl, method: .post, parameters: toDo, headers: self.constants.appID).responseJSON { response  in
            
            guard response.response?.statusCode != 400 else{
                UserDefaults.standard.removeObject(forKey: "accessToken")
                UserDefaults.standard.removeObject(forKey: "refreshToken")
                UserDefaults.standard.removeObject(forKey: "CARID")
               
                return
            }
            do{
                let sigInModel = try JSONDecoder().decode(SigInModel.self, from: response.data!)
                
                self.setSaredPref(key: "accessToken", value: "Bearer " + sigInModel.tokenInfo!.accessToken!)
                self.setSaredPref(key: "refreshToken", value: "Bearer " +  sigInModel.tokenInfo!.refreshToken!)
                
                print("accessToken " + (self.getSharedPref(key: "accessToken"))! + " - " + "refreshToken " + (self.getSharedPref(key: "refreshToken"))!)
                
                
            }
            catch{
                
            }
            
        }
    }
    
    
    func milisecondsToTime(miliseconds: Int, timeZone: Int) -> String {
        //        let dateVar = Date(timeIntervalSince1970: TimeInterval((miliseconds - 7000000)/1000))
        let dateVar = Date(timeIntervalSince1970: TimeInterval(miliseconds/1000))
        
        //            Date.init(timeIntervalSinceNow: NSTimeIntervalSince1970(miliseconds)/1000)
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        return dateFormatter.string(from: dateVar)
    }
    
    func milisecondsToDateB(miliseconds: Int) -> String {
        //        let dateVar = Date(timeIntervalSince1970: TimeInterval((miliseconds - 7000000)/1000))
        let dateVar = Date(timeIntervalSince1970: TimeInterval(miliseconds/1000))
        
        //            Date.init(timeIntervalSinceNow: NSTimeIntervalSince1970(miliseconds)/1000)
        dateFormatter.dateFormat = "dd.MM.yy"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        return dateFormatter.string(from: dateVar)
    }
    
    
   
    
    
    func checkFilds(massage: String, vc: UIView){
        
        SCLAlertView().showWarning(NSLocalizedString("Attention", comment: ""), subTitle: massage, closeButtonTitle: NSLocalizedString("Clouse", comment: ""))
        vc.endEditing(true)
    }
   
    func filterArray(savedInfos: [String?], serverInfos: String) -> Bool {
        guard serverInfos.count != 0 else{
            return true
        }
        for savedInfo in savedInfos{
                if savedInfo == serverInfos {
                    return true
                
            }
        }
        return false
    }
    
    func doneMassage(massage: String, vc: UIView){
        
        vc.endEditing(true)
        SCLAlertView().showSuccess(NSLocalizedString("Excellent", comment: ""), subTitle: massage, closeButtonTitle: NSLocalizedString("Clouse", comment: ""))
        
    }
    
    func setBorder(view: UIView, backgroundColor: UIColor, borderColor: CGColor, borderWidth: CGFloat, cornerRadius: CGFloat){
        view.backgroundColor = backgroundColor
        view.layer.borderColor = borderColor
        view.layer.borderWidth = borderWidth
        view.layer.cornerRadius = cornerRadius
    }
    
    func checkStatus(status: String) -> String{
        switch status {
        case "WAITING":
            return NSLocalizedString("waiting", comment: "")
        case "IN_PROCESS":
            return NSLocalizedString("in_process", comment: "")
        case "COMPLETED":
            return NSLocalizedString("complite", comment: "")
        case "CANCELED":
            return NSLocalizedString("canceled", comment: "")
        case "EXPIRED":
            return NSLocalizedString("EXPIRED", comment: "")
            
        default:
            return ""
        }
    }
    
//    func checkWorckTime(carWoshInfo){
//        var CurrentDate = NSDate()
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.timeZone = NSTimeZone()
//        dateFormatter.dateFormat = "ccc"
//        
//        let Monday = dateFormatter.stringFromDate(CurrentDate)
//    }
    
    func changeImageSize(with image: UIImage, scaledTo newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
    
    func checkPushNot(vc: UIViewController){
        if getSharedPref(key: "OBJECTID") != nil{
            
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vcc = storyboard.instantiateViewController(withIdentifier: "singleOrderVC") as! SingleOrderVC
            vc.navigationController?.pushViewController(vcc, animated: true)
            
        }
    }
//    func milisecondsToDateA(milliseconds: Int) -> Date {
//        let date = NSDate(timeIntervalSince1970: TimeInterval(milliseconds))
//        let formatter = DateFormatter()
//        formatter.dateFormat = "hh:mm aa dd/MM/YYYY"
//        return formatter.string(from: date as Date)
//    }
    
    //Set CarWashMarker to Shared Preferens
    func setBusinesList(key: String, value: CarWashMarker) {
        let userDefaults = UserDefaults.standard
        if let data = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(data, forKey: key)
            
            userDefaults.synchronize()
        }
        
    }
    
    //Get CarWashMarker from Shared Preferens
    func getBusinesList(key: String) -> CarWashMarker? {
        
        if let data = UserDefaults.standard.value(forKey: key) as? Data,
            let configuration = try? JSONDecoder().decode(CarWashMarker.self, from: data) {
            return configuration
        }else{
        return nil
        }
    }
    
    static func showActivityIndicator(view: UIView, targetVC: UIViewController) {
        
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.backgroundColor = UIColor(red:0.16, green:0.17, blue:0.21, alpha:0.3)
        activityIndicator.layer.cornerRadius = 6
        activityIndicator.center = targetVC.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.tag = 1
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    static func hideActivityIndicator(view: UIView) {
        let activityIndicator = view.viewWithTag(1) as? UIActivityIndicatorView
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
   
}

