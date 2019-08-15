//
//  SiginAct.swift
//  Karma
//
//  Created by macbook on 09/11/2018.
//  Copyright © 2018 Gliesereum. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseMessaging
import UIKit


class UserPushNot: Codable{
    let notificationEnable: Bool?
    let subscribeDestination: String?
    init(notificationEnable: Bool?, subscribeDestination: String?) {
        self.notificationEnable = notificationEnable
        self.subscribeDestination = subscribeDestination
    }
}
extension UserPushNot {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(UserPushNot.self, from: data)
        self.init(notificationEnable: me.notificationEnable, subscribeDestination: me.subscribeDestination)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        notificationEnable: Bool?,
        subscribeDestination: String?
        ) -> UserPushNot {
        return UserPushNot(
            notificationEnable: notificationEnable ?? self.notificationEnable,
            subscribeDestination: subscribeDestination ?? self.subscribeDestination
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

class SiginViewController: UIViewController, NVActivityIndicatorViewable{
    
    
   
    // initialize
    var pinCodeInputView: PinCodeInputView<ItemView> = .init(
        digit: 6,
        itemSpacing: 8,
        itemFactory: {
            return ItemView()
    })

    //MARK -
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var centrLable: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logoKarma: UIImageView!
    @IBOutlet weak var mainVIew: UIView!
    let utils = Utils()
    let constants = Constants()
    let button = UIButton()
    var smsCodeText: String = ""
//    var phoneNumber: String = ""
    var phoneNumberTextField: FPNTextField!
    var poper = Bool()
    var vc = UIViewController()
    var poper1 = Bool()
    //MARK - View outlet

    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var codeLable: UILabel!
    @IBOutlet weak var sigInBtn: UIButton!
    @IBOutlet weak var getCodeBtn: UIButton!
    
    
    var frameY = CGFloat()
    
    var frameView : CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frameY = self.view.frame.origin.y
        frameView = frameY
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//        logoKarma.image = utils.getImageFromSVG(name: "KarmaClient")
        
        phoneNumberTextField = FPNTextField(frame: CGRect(x: 0, y: 0, width:  view.bounds.width  - 16, height: 56))
//        phoneNumberTextField.frame = centrLable.frame
        phoneNumberTextField.borderStyle = .roundedRect
        phoneNumberTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
        phoneNumberTextField.parentViewController = self
        phoneNumberTextField.delegate = self
        phoneNumberTextField.flagSize = CGSize(width: 35, height: 56)
        phoneNumberTextField.flagButtonEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0)
        phoneNumberTextField.hasPhoneNumberExample = true
        mainVIew.addSubview(phoneNumberTextField)
        mainVIew.addSubview(pinCodeInputView)
        
        phoneNumberTextField.center = view.center
        phoneNumberTextField.frame = CGRect(x: phoneNumberTextField.frame.minX, y: centrLable.frame.midY - 10, width: phoneNumberTextField.bounds.width, height: phoneNumberTextField.bounds.height)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        view.addGestureRecognizer(tapGesture)
        pinCodeInputView.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 56, height: 56)
        pinCodeInputView.center = view.center

        pinCodeInputView.frame = CGRect(x: pinCodeInputView.frame.minX, y: centrLable.frame.minY - 2, width: pinCodeInputView.bounds.width, height: pinCodeInputView.bounds.height)
        pinCodeInputView.set(changeTextHandler: { text in
            if text.count == 6{
                self.smsCodeText = text
                self.setCodeSignIn(phone: self.phoneNumberTextField.getFormattedPhoneNumber(format: .E164)!.replacingOccurrences(of: "+", with: ""), code: text)
            }
        })
        pinCodeInputView.set(
            appearance: .init(
                itemSize: CGSize(width: 44, height: 56
                ),
                font: .systemFont(ofSize: 28, weight: .bold),
                textColor: .black,
                backgroundColor: #colorLiteral(red: 0.9882352941, green: 0.9882352941, blue: 0.9882352941, alpha: 1),
                cursorColor: UIColor.black,
                cornerRadius: 8, borderColor: #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
            )
        )
        pinCodeInputView.isHidden = true
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(didBecameActive),
                name: UIApplication.didBecomeActiveNotification,
                object: nil
        )
        phoneNumberTextField.addDoneCancelToolbar(onDone: (target: (Any).self, action: #selector(sigInBtnAct)))
        if poper == true{
            self.definesPresentationContext = true
        }
    }
//    @objc func keyboardWillShow(notification:NSNotification){
//        var userInfo = notification.userInfo!
//        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
//        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
//
//        var contentInset:UIEdgeInsets = self.scrollView.contentInset
//        contentInset.bottom = keyboardFrame.size.height
//        scrollView.contentInset = contentInset
//    }
//    @objc func keyboardWillHide(notification:NSNotification){
//
//        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
//        scrollView.contentInset = contentInset
//    }
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
        phoneNumberTextField.addDoneCancelToolbar(onDone: (target: (Any).self, action: #selector(sigInBtnAct)))
    
    }
    
    @IBAction func onBackBtn(_ sender: Any) {
        self.phoneNumberTextField.isHidden = false
        self.getCodeBtn.isHidden = true
        self.pinCodeInputView.isHidden = true
        self.sigInBtn.isHidden = false
        self.backBtn.isHidden = true
        self.sigInBtn.isEnabled = true
        phoneNumber.isHidden = true
        codeLable.isHidden = true
    }
    
    @objc func didBecameActive() {
        
        print("did became active")
        print("string:", UIPasteboard.general.strings ?? "")
        print("url:", UIPasteboard.general.urls ?? "")
        print("color:", UIPasteboard.general.colors ?? "")
        print("image:", UIPasteboard.general.images ?? "")
        
        if let string = UIPasteboard.general.string {
            pinCodeInputView.set(text: string)
        }
    }
    
    @objc func tap() {
        pinCodeInputView.resignFirstResponder()
    }
    
    //MARK - button action
    @IBAction func getCode(_ sender: Any) {
        
        self.view.endEditing(true)
       startAnimating()
        if smsCodeText.count == 6{
            setCodeSignIn(phone: phoneNumberTextField.getFormattedPhoneNumber(format: .E164)!.replacingOccurrences(of: "+", with: ""), code: smsCodeText)
        } else {
            stopAnimating()
            utils.checkFilds(massage: "Введите код", vc: self.view)
//             TinyToast.shared.show(message: "Введите код", valign: .bottom, duration: .normal)
//            utils.showToast(message: "Введите код",viewController: self)
            
        }
    }
    @IBAction func sigIn(_ sender: Any) {
        sigInBtnAct()
    }
    @objc func sigInBtnAct() {
        startAnimating()
        
        self.view.endEditing(true)
        guard phoneNumberTextField.text != "(null)(null)" else {
            stopAnimating()
            return
        }
        if let text = phoneNumberTextField.text, !text.isEmpty
        {
            phoneNumber.text = phoneNumberTextField.getFormattedPhoneNumber(format: .E164)
            
//            sigInBtn.isEnabled = false
//            sigInBtn.isHidden = true
            phoneAutorithation(phone:  phoneNumberTextField.getFormattedPhoneNumber(format: .E164)!.replacingOccurrences(of: "+", with: ""), isNew: false)
        } else {
            stopAnimating()
            utils.checkFilds(massage: "Введите нормер телефона", vc: self.view)
            //              TinyToast.shared.show(message: "Введите нормер телефона", valign: .bottom, duration: .normal)
            //            utils.showToast(message: "Введите нормер телефона",viewController: self)
        }
    }
    //MARK - REST API request
    func phoneAutorithation(phone: String, isNew: Bool){
        let restUrl = constants.startUrl + "account/v1/phone/code"
        let toDo: [String: Any]  = ["phone": phone, "isNew": isNew]
        Alamofire.request(restUrl, method: .get, parameters: toDo, encoding: URLEncoding(destination: .queryString), headers: self.constants.appID).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            self.phoneNumberTextField.isHidden = true
            self.getCodeBtn.isHidden = false
            self.pinCodeInputView.isHidden = false
            self.sigInBtn.isHidden = true
            self.backBtn.isHidden = false
            self.phoneNumber.isHidden = false
            self.codeLable.isHidden = false
            self.pinCodeInputView.resignFirstResponder()
            self.sigInBtn.isEnabled = true
            self.stopAnimating()
        }
        
    }
    
    func setCodeSignIn(phone: String, code: String){
        startAnimating()
        let restUrl = constants.startUrl + "account/v1/auth/signin"
        let toDo: [String: Any]  = ["value": phone, "code": code, "type": "PHONE"]
        Alamofire.request(restUrl, method: .post, parameters: toDo, encoding: JSONEncoding.default, headers: self.constants.appID).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            do{
                let sigInModel = try JSONDecoder().decode(SigInModel.self, from: response.data!)
              
                self.utils.setSaredPref(key: "accessToken", value: "Bearer " + sigInModel.tokenInfo!.accessToken!)
                self.utils.setSaredPref(key: "refreshToken", value: "Bearer " +  sigInModel.tokenInfo!.refreshToken!)
                if sigInModel.user?.avatarURL != nil{
                    self.utils.setSaredPref(key: "USERAVATAR", value: (sigInModel.user?.avatarURL)!)
                }
                if sigInModel.user?.firstName != nil{
                    self.utils.setSaredPref(key: "USER", value: (sigInModel.user?.firstName)! + " " + (sigInModel.user?.lastName)!)
                }
            
                let token = Messaging.messaging().fcmToken
                self.setFireBaseToken(token: token!, userId: (sigInModel.user?.id)!, accessToken: "Bearer " + sigInModel.tokenInfo!.accessToken!)
             
                guard sigInModel.user?.firstName != nil else{
                    self.poper = false
                    self.dismiss(animated: true, completion: nil)
                    let customAlert = self.vc.storyboard?.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
                    customAlert.poper = true
                    customAlert.providesPresentationContextTransitionStyle = true
                    customAlert.definesPresentationContext = true
                    customAlert.modalPresentationStyle = UIModalPresentationStyle.popover
                    customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    //            customAlert.delegate = self
                    self.vc.present(customAlert, animated: true, completion: nil)
                    //                self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "profileStartVC")), animated: true)
                    //                    self.sideMenuViewController!.hideMenuViewController()
                    
                    return
                }
                
                guard self.poper != true else{
                    self.poper = false
                    self.dismiss(animated: true, completion: nil)
                    return
                }
                self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "selectSingleBuisnesVC")), animated: true)
                self.sideMenuViewController!.hideMenuViewController()
                
                
            }
            catch{
                
            }
            
            self.stopAnimating()
        }
    }
    
    
    func setFireBaseToken(token: String, userId: String, accessToken: String){
        startAnimating()
        print(token)
        utils.setSaredPref(key: "REGISTRATIONTOKEN", value: token)
        let restUrl = constants.startUrl + "notification/v1/user-device"
//        let userSubscribe = [String: Any]()
        var destination = [UserPushNot]()
        destination.append(UserPushNot.init(notificationEnable: true, subscribeDestination: "KARMA_USER_RECORD"))
            
        destination.append(UserPushNot.init(notificationEnable: true, subscribeDestination: "KARMA_USER_REMIND_RECORD"))
        
        let toDo: [String: Any]  = ["userId": userId,"subscribes": [["notificationEnable": true, "subscribeDestination": "KARMA_USER_RECORD"],["notificationEnable": true, "subscribeDestination": "KARMA_USER_REMIND_RECORD"] ], "firebaseRegistrationToken": token, "notificationEnable": true]
        let dooo = JSONSerialization.isValidJSONObject(toDo)
        let headers = ["Authorization" : accessToken, "Application-Id":self.constants.iosId]
        Alamofire.request(restUrl, method: .post, parameters: toDo,encoding: JSONEncoding.default, headers: headers).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            
            
            self.stopAnimating()
        }
    }
    
 
    
}




extension SiginViewController: FPNTextFieldDelegate{
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(name, dialCode, code) // Output "France", "+33", "FR"
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
}
