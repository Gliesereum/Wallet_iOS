//
//  RegistrationAct.swift
//  Karma
//
//  Created by macbook on 06/12/2018.
//  Copyright © 2018 Gliesereum. All rights reserved.
//

import UIKit
import Alamofire
import MaterialComponents


class ProfileViewController: UIViewController {
    
    let constants = Constants()
    let utils = Utils()
    var frameY = CGFloat()
    var profiModel: ProfileModel?
//    let mapViewController = MapViewController()
    
    @IBOutlet weak var firstName: MDCTextField!
    @IBOutlet weak var lastName: MDCTextField!
    @IBOutlet weak var patronymic: MDCTextField!
    @IBOutlet weak var saveBtn: MDCButton!
    @IBOutlet weak var editBtn: MDCButton!
    @IBOutlet weak var country: MDCTextField!
    @IBOutlet weak var city: MDCTextField!
    @IBOutlet weak var adress: MDCTextField!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frameY = self.view.frame.origin.y
        firstName.addDoneCancelToolbar()
        lastName.addDoneCancelToolbar()
        patronymic.addDoneCancelToolbar()
        country.addDoneCancelToolbar()
        city.addDoneCancelToolbar()
        adress.addDoneCancelToolbar()
    
        getProfile()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    @IBAction func regBtn(_ sender: Any) {
        
        self.view.endEditing(true)
        guard firstName.text!.count >= 2 else{
            utils.checkFilds(massage: "Введите ваше имя", vc: self.view)
            return
        }
        guard lastName.text!.count >= 2 else{
            
            utils.checkFilds(massage: "Введите вашу фамилию", vc: self.view)
            return
        }
        guard patronymic.text!.count >= 3 else{
            
            utils.checkFilds(massage: "Введите ваше отчество", vc: self.view)
            return
        }
        guard country.text!.count >= 2 else{
            
            utils.checkFilds(massage: "Введите название вашей страны", vc: self.view)
            return
        }
        guard city.text!.count >= 2 else{
            
            utils.checkFilds(massage: "Введите название вашего города", vc: self.view)
            return
        }
        guard adress.text!.count >= 6 else{
            
            utils.checkFilds(massage: "Введите ваш адрес", vc: self.view)
            return
        }
        firstName.isEnabled = false
        lastName.isEnabled = false
        patronymic.isEnabled = false
        country.isEnabled = false
        city.isEnabled = false
        adress.isEnabled = false
        saveBtn.isHidden = true
        editBtn.isHidden = false
        ragistrarion(firstName: firstName.text!, lastName: lastName.text!, middleName: patronymic.text!, country: country.text!, city: city.text!, adress: adress.text!)
    }
    //MARK: get carwash list
    func ragistrarion(firstName: String, lastName: String, middleName: String, country: String, city: String, adress: String){
        print(firstName)
        if profiModel == nil {
            profiModel = ProfileModel(id: nil, firstName: firstName, lastName: lastName, middleName: middleName, position: nil, country: country, city: city, address: adress, addAddress: nil, avatarURL: nil, coverURL: nil, gender: nil, banStatus: nil, verifiedStatus: nil, userType: nil)
        } else {
            profiModel?.firstName = firstName
            profiModel?.lastName = lastName
            profiModel?.middleName = middleName
            profiModel?.country = country
            profiModel?.city = city
            profiModel?.address = adress
        }
        let parameters = try! JSONEncoder().encode(profiModel)
        let params = try! JSONSerialization.jsonObject(with: parameters, options: .allowFragments)as? [String: Any]
        let restUrl = constants.startUrl + "account/v1/user"
        guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            return
        }
        Alamofire.request(restUrl, method: .put, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization": (self.utils.getSharedPref(key: "accessToken"))!]).responseProfileModel { response  in
            guard response.result.error == nil else {
                // got an error in getting the data, need to handle it
                print("error calling POST on /todos/1")
                print(response.result.error!)
                return
            }
            // make sure we got some JSON since that's what we expect
            guard response.result.value != nil else{
                
                return
            }
            let profileModel = response.result.value
            if profileModel!.avatarURL != nil{
                self.utils.setSaredPref(key: "USERAVATAR", value: (profileModel!.avatarURL)!)
            }
            if profileModel!.firstName != nil{
                self.utils.setSaredPref(key: "USER", value: (profileModel!.firstName)! + " " + (profileModel!.lastName)!)
            self.utils.doneMassage(massage: "Данные изменены", vc: self.view)
            }
        
        }
        
    }
    @IBAction func editProfile(_ sender: Any) {
        
        self.view.endEditing(true)
        country.isEnabled = true
        city.isEnabled = true
        adress.isEnabled = true
        firstName.isEnabled = true
        lastName.isEnabled = true
        patronymic.isEnabled = true
        saveBtn.isHidden = false
        editBtn.isHidden = true
    }
    func getProfile(){
        
        let restUrl = constants.startUrl + "account/v1/user/me"
        guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            return
        }
        let headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!]
        Alamofire.request(restUrl, method: .get, headers: headers).responseProfileModel { response in
            
            let profileModel = response.result.value
            guard profileModel!.firstName != nil else{
                self.editProfile(self)
                self.utils.checkFilds(massage: "Заполните свой профиль", vc: self.view)
                return
            }
            self.firstName.text =  profileModel?.firstName
            self.lastName.text = profileModel?.lastName
            self.patronymic.text = profileModel?.middleName
            self.country.text = profileModel?.country
            self.city.text = profileModel?.city
            self.adress.text = profileModel?.address
            self.profiModel = profileModel
        }
    }
    override func viewDidAppear(_ animated: Bool) {
//        utils.checkPushNot(vc: self)
        guard utils.getSharedPref(key: "accessToken") != nil else{
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
            self.utils.checkFilds(massage: "Авторизируйтесь", vc: self.view)
            return
        }
    }
    
    
}
