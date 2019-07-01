//
//  File.swift
//  Karma
//
//  Created by macbook on 12/12/2018.
//  Copyright © 2018 Gliesereum. All rights reserved.
//

import Foundation
import UIKit
import SVGKit
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
    
    //Set any to Shared Preferens
    func setAny(key: String, value: Any) {
        let userDefaults = UserDefaults.standard
        let encodedData: Data?
        encodedData = try! NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
        userDefaults.set(encodedData, forKey: key)
        userDefaults.synchronize()
        
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
    
    //Get any from Shared Preferens
    func getAny(key: String) -> Any? {
        let userDefaults = UserDefaults.standard
        guard let decoded  = userDefaults.object(forKey: key) as? Data else{
            return nil
        }
        let decodedTeams = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as Any
        
        return decodedTeams
    }
   
    //check responce status code
    func checkResponseStatusCode(code : Int) -> String {
        switch code {
//        case 204:
//            return
//            showToast(message: "Нет ничего", viewController: viewController)
        case 1160:
            return "Значение пусто"
//            showToast(message: "Value is empty", viewController: viewController)
        case 1161:
            return "Код пуст"
//            showToast(message: "Code is empty", viewController: viewController)
        case 1162:
            return "Тип пуст"
//            showToast(message: "Type is empty", viewController: viewController)
        case 1163:
            return "Тип пользователя пуст"
//            showToast(message: "User type is empty", viewController: viewController)
        case 1164:
            return "Неправильный код подтверждения, попробуйте еще раз"
//            showToast(message: "Verification code not correct try again", viewController: viewController)
        case 1000:
            return "Идентификатор не указан"
//            showToast(message: "Id not specified", viewController: viewController)
        case 1001:
            return "Ошибка проверки"
//            showToast(message: "Validation error", viewController: viewController)
        case 1002:
            return "Не действует URI"
//            showToast(message: "Not valid uri", viewController: viewController)
        case 1003:
            return "Тело запроса недействительно"
//            showToast(message: "Request body is invalid", viewController: viewController)
        case 1004:
            return "Не существует по id"
//            showToast(message: "Not exist by id", viewController: viewController)
        case 1040:
            return "У текущего пользователя нет прав"
//            showToast(message: "Current user don't have any permission", viewController: viewController)
        case 1041:
            return "У текущего пользователя нет прав на модуль"
//            showToast(message: "Current user don't have permission to module", viewController: viewController)
        case 1042:
            return "Текущий пользователь не имеет разрешения на конечную точку"
//            showToast(message: "Current user don't have permission to endpoint", viewController: viewController)
        case 1043:
            return "Модуль не активен"
//            showToast(message: "Module not active", viewController: viewController)
        case 1044:
            return "Конечная точка не активна"
//            showToast(message: "Endpoint not active", viewController: viewController)
        case 1045:
            return "Конечная точка не найдена"
//            showToast(message: "Endpoint not found", viewController: viewController)
        case 1046:
            return "Пользователь анонимный"
//            showToast(message: "User is anonymous", viewController: viewController)
        case 9000:
            return "Ошибка сервера"
//            showToast(message: "Server error", viewController: viewController)
        case 9001:
            return "Сервис недоступен сейчас"
//            showToast(message: "Service not available now", viewController: viewController)
        case 1140:
            return "Значение адреса электронной почты пусто"
//            showToast(message: "Value email is empty", viewController: viewController)
        case 1141:
            return "Код значения по электронной почте пуст"
//            showToast(message: "Value code by email is empty", viewController: viewController)
        case 1142:
            return "Электронная почта не найдена"
//            showToast(message: "Email not found ", viewController: viewController)
        case 1143:
            return "Электронная почта уже существует"
//            showToast(message: "Email already exist", viewController: viewController)
        case 1144:
            return "Неверный адрес электронной почты"
//            showToast(message: "Not valid email", viewController: viewController)
        case 1145:
            return "У пользователя уже есть электронная почта"
//            showToast(message: "User already has some email", viewController: viewController)
        case 1146:
            return "Пользователь не имеет никакой электронной почты"
//            showToast(message: "User doesn't any email", viewController: viewController)
        case 1147:
            return "Вы не можете удалить электронную почту. У тебя нет телефона. Электронная почта - единственный способ подтвердить свой аккаунт"
//            showToast(message: "You can't delete email. You don't have phone. Email is only way to verify your account", viewController: viewController)
        case 1300:
            return "Группа разрешений не найдена"
//            showToast(message: "Permission group not found", viewController: viewController)
        case 1301:
            return "Пользователь существует в группе, удалить, прежде чем добавить в другие"
//            showToast(message: "User exist in group, remove before add to other", viewController: viewController)
        case 1302:
            return "Пользователь не существует в группе"
//            showToast(message: "User not exist in group", viewController: viewController)
        case 1303:
            return "Группа разрешений не активна"
//            showToast(message: "Permission group not active", viewController: viewController)
        case 1400:
            return "Автомобиль не найден"
//            showToast(message: "Car not found", viewController: viewController)
        case 1410:
            return "Класс обслуживания не найден"
//            showToast(message: "Service class not found", viewController: viewController)
        case 1411:
            return "Цена услуги не найдена"
//            showToast(message: "Service price not found", viewController: viewController)
        case 1420:
            return "У текущего пользователя нет прав на действие этой автомойки"
//            showToast(message: "Current user don't have permission to action this carwash", viewController: viewController)
        case 1421:
            return "Автомойка не найдена"
//            showToast(message: "Carwash not found", viewController: viewController)
        case 1422:
            return "Идентификатор автомойки пуст"
//            showToast(message: "Carwash id is empty", viewController: viewController)
        case 1423:
            return "У текущего пользователя нет прав на создание автомойки"
//            showToast(message: "Current user don't have permission to create carwash", viewController: viewController)
        case 1424:
            return "Текущий пользователь не имеет разрешения на действие этой службы"
//            showToast(message: "Current user don't have permission to action this service", viewController: viewController)
        case 1425:
            return "Сервис не найден"
//            showToast(message: "Service not found", viewController: viewController)
        case 1426:
            return "Сервис не выбирай"
//            showToast(message: "Service not choose", viewController: viewController)
        case 1427:
            return "Пакет не найден"
//            showToast(message: "Package not found ", viewController: viewController)
        case 1428:
            return "Автомойка не имеет этого рабочего пространства"
//            showToast(message: "CarWash don't have this working space ", viewController: viewController)
        case 1429:
            return "Идентификатор рабочего пространства равен нулю"
//            showToast(message: "Working space id is null ", viewController: viewController)
        case 1430:
            return "Недостаточно времени для создания записи, выберите другое время"
//            showToast(message: "Not enough time for create record, choose another time", viewController: viewController)
        case 1431:
            return "запись не найдена"
//            showToast(message: "Record not found", viewController: viewController)
        case 1432:
            return "Time begin is empty"
//            showToast(message: "Time begin is empty", viewController: viewController)
        case 1433:
            return "Рабочее пространство не найдено"
//            showToast(message: "Working space not found", viewController: viewController)
        case 1434:
            return "CarWash don't work this day"
//            showToast(message: "CarWash don't work this day", viewController: viewController)
        case 1435:
            return "Точка не работает в это время"
//            showToast(message: "CarWash don't work this time", viewController: viewController)
        case 1436:
            return "Time working already exist in this car wash"
//            showToast(message: "Time working already exist in this car wash", viewController: viewController)
        case 1437:
            return "Время работы не найдено"
//            showToast(message: "Time working not found", viewController: viewController)
        case 1438:
            return "Current user don't have permission to action this record"
//            showToast(message: "Current user don't have permission to action this record", viewController: viewController)
        case 1439:
            return "Вы выбираете прошедшее время"
//            showToast(message: "Try to choose past time", viewController: viewController)
        case 1440:
            return "Анонимный пользователь не может комментировать"
//            showToast(message: "Anonymous user can't comment", viewController: viewController)
        case 1441:
            return "Комментарий для текущего пользователя существует"
//            showToast(message: "Comment for current user exist", viewController: viewController)
        case 1442:
            return "Текущий пользователь не может редактировать этот комментарий"
//            showToast(message: "Current user cant't edit this comment", viewController: viewController)
        case 1443:
            return "Комментарий не найден"
//            showToast(message: "Comment not found", viewController: viewController)
        case 1450:
            return "Носитель не найден по идентификатору"
//            showToast(message: "Media not found by id", viewController: viewController)
        case 1120:
            return "Значение номера телефона пусто"
//            showToast(message: "Value phone number is empty", viewController: viewController)
        case 1121:
            return "Код значения по телефону пуст"
//            showToast(message: "Value code by phone is empty", viewController: viewController)
        case 1122:
            return "Номер телефона не найден"
//            showToast(message: "Phone number not found ", viewController: viewController)
        case 1123:
            return "Номер телефона уже существует"
//            showToast(message: "Phone number already exist", viewController: viewController)
        case 1124:
            return "Неверный номер телефона"
//            showToast(message: "Not valid phone number", viewController: viewController)
        case 1125:
            return "User already has some phone"
//            showToast(message: "User already has some phone", viewController: viewController)
        case 1126:
            return "У пользователя нет телефона"
//            showToast(message: "User doesn't any phone", viewController: viewController)
        case 1127:
            return "Вы не можете удалить телефон. У вас нет электронной почты. Телефон - единственный способ подтвердить свой аккаунт"
//            showToast(message: "You can't delete phone. You don't have email. Phone is only way to verify your account", viewController: viewController)
        case 1100:
            return "Токен доступа или обновления пуст"
//            showToast(message: "Access or Refresh token empty", viewController: viewController)
        case 1101:
            return "Токен доступа пуст"
//            showToast(message: "Access token empty", viewController: viewController)
        case 1102:
            return "Токен доступа не найден"
//            showToast(message: "Access token not found ", viewController: viewController)
        case 1103:
            return "Пара токенов доступа и обновления недействительна"
//            showToast(message: "The pair of access and refresh token not valid", viewController: viewController)
        case 1104:
            return "Срок действия маркера истек"
//            showToast(message: "Access token is expired", viewController: viewController)
        case 1105:
            return "Срок действия маркера истек"
//            showToast(message: "Refresh token is expired", viewController: viewController)
        case 1010:
            return "Пользователь не найден"
//            showToast(message: "User not found ", viewController: viewController)
        case 1011:
            return "Пользователь не аутентифицирован"
//            showToast(message: "User not authentication ", viewController: viewController)
        case 1012:
            return "Вы не можете изменить имя. Связаться с администратором"
//            showToast(message: "You can't change first name. Contact administrator", viewController: viewController)
        case 1013:
            return "Вы не можете изменить фамилию. Связаться с администратором"
//            showToast(message: "You can't change last name. Contact administrator", viewController: viewController)
        case 1014:
            return "URL аватар не действителен"
//            showToast(message: "Url avatar is not valid", viewController: viewController)
        case 1015:
            return "URL-адрес недействителен"
//            showToast(message: "Url cover is not valid", viewController: viewController)
        case 1016:
            return "Пользователь не бизнес"
//            showToast(message: "User not business ", viewController: viewController)
        case 1017:
            return "Пользователь не проверен"
//            showToast(message: "User not VERIFIED ", viewController: viewController)
        case 1018:
            return "Пользователь в бане"
//            showToast(message: "User in ban ", viewController: viewController)
        case 1451:
            return "Пакет не имеет никаких услуг"
//            <string name="error_1451">Package don\'t have any services</string>

        case 1510:
            return "Составные данные пусты"
//            <string name="error_1510">Multipart data is empty</string>

        case 1511:
            return "Составной тип данных не определен"
//            <string name="error_1511">Multipart data type undefined</string>

        case 1512:
            return "Составное имя файла не определено"
//            <string name="error_1512">Multipart file name undefined</string
        case 1513:
            return "Многочастный тип файла не совместим"
//            <string name="error_1513">Multipart file type not compatible</string
        case 1514:
            return "Превышен максимальный размер загрузки"
//            <string name="error_1514">Maximum upload size exceeded</string
        default:
            return "..."
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
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        return dateFormatter.string(from: dateVar)
    }
    
    func getImageFromSVG(name: String) -> UIImage {
        let namSvgImgVar: SVGKImage = SVGKImage(named: name)
//        let namSvgImgVyuVar = SVGKFastImageView(svgkImage: namSvgImgVar)
        let namImjVar: UIImage = namSvgImgVar.uiImage
        return namImjVar
    }
    
    func dateToMillisecond(date: Date, timeZone: Int) -> Int {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let date = dateFormatter.date(from: dateFormatter.string(from: date as Date))
        let nowDouble = date!.timeIntervalSince1970
        return Int(nowDouble*1000) + timeZone*60000
    }
    func checkResponse(response: DataResponse<Any>, vc: UIViewController) -> Bool {
        guard response.response?.statusCode != 500 else{
        
            vc.view.endEditing(true)
            
            vc.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: vc.storyboard!.instantiateViewController(withIdentifier: "mapViewController")), animated: true)
            vc.sideMenuViewController!.hideMenuViewController()
            SCLAlertView().showError("Внимание!", subTitle: "Нет связи с сервером", closeButtonTitle: "Закрыть")
//            TinyToast.shared.show(message: "Нет связи с сервером", valign: .bottom, duration: .normal)
            return false
        }
        guard response.result.error == nil else {
                 SCLAlertView().showError("Внимание!", subTitle: "Нет связи с сервером", closeButtonTitle: "Закрыть")
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
                vc.view.endEditing(true)
                SCLAlertView().showWarning("Внимание!", subTitle: checkResponseStatusCode(code: errorBody.code!), closeButtonTitle: "Закрыть")
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
    
    func refreshToken(){
        let restUrl = constants.startUrl + "account/v1/auth/refresh"
        let toDo: [String: String]  = ["refreshToken": getSharedPref(key: "refreshToken")!]
        Alamofire.request(restUrl, method: .post, parameters: toDo).responseJSON { response  in
            
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
        
        SCLAlertView().showWarning("Внимание!", subTitle: massage, closeButtonTitle: "Закрыть")
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
        SCLAlertView().showSuccess("Отлично!", subTitle: massage, closeButtonTitle: "Закрыть")
        
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
            return "В ожидании"
        case "IN_PROCESS":
            return "В процессе"
        case "COMPLETED":
            return "В ожидании"
        case "CANCELED":
            return "Отменен"
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

}

