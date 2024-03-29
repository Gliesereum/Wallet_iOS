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
import SDWebImage
import Lightbox


class ProfileViewController: UIViewController, ImagePickerDelegate, UIGestureRecognizerDelegate {
    
    
    
    let constants = Constants()
    let utils = Utils()
    var frameY = CGFloat()
    var profiModel: ProfileModel?
//    var delegete : ProfileDissmisDelegete?
    var edited: Bool?
//    let mapViewController = MapViewController()
    
    @IBOutlet weak var editItem: UIBarButtonItem!
    @IBOutlet weak var firstName: MDCTextField!
    @IBOutlet weak var lastName: MDCTextField!
    @IBOutlet weak var patronymic: MDCTextField!
    @IBOutlet weak var saveBtn: MDCButton!
    @IBOutlet weak var country: MDCTextField!
    @IBOutlet weak var city: MDCTextField!
    @IBOutlet weak var adress: MDCTextField!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var addAvatarView: UIImageView!
    @IBOutlet weak var exitBtn: UIButton!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    var avatarUrl = ""
    var poper = Bool()
    
    let imagePickerController = ImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ColorOrange()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        imagePickerController.cameraController.startOnFrontCamera = true
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
        if poper == true{
            self.definesPresentationContext = true
            exitBtn.isHidden = false
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @objc func addAvatar(){
        if edited == true{
        present(imagePickerController, animated: true, completion: nil)
        }
    }
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imageAvatar.image = images.first
        getAvatar(image: images.first!)
       imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
        imagePicker.dismiss(animated: true, completion: nil)
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
//    @IBAction func backARROW(_ sender: Any) {
//        self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "profileViewController")), animated: true)
//        self.sideMenuViewController!.hideMenuViewController()
//    }
    func ColorOrange(){
        firstName.textColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
        lastName.textColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
        patronymic.textColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
        country.textColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
        city.textColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
        adress.textColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
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
        ColorOrange()
        addAvatarView.isHidden = true
        firstName.isEnabled = false
        lastName.isEnabled = false
        patronymic.isEnabled = false
        country.isEnabled = false
        city.isEnabled = false
        adress.isEnabled = false
        saveBtn.isHidden = true
        editItem.isEnabled = true
        if avatarUrl != ""{
            ragistrarion(firstName: firstName.text!, lastName: lastName.text!, middleName: patronymic.text!, country: country.text!, city: city.text!, adress: adress.text!, avatarUrl: avatarUrl)
        }else{
            ragistrarion(firstName: firstName.text!, lastName: lastName.text!, middleName: patronymic.text!, country: country.text!, city: city.text!, adress: adress.text!, avatarUrl: nil)
        }
    }
    //MARK: get carwash list
    func ragistrarion(firstName: String, lastName: String, middleName: String, country: String, city: String, adress: String, avatarUrl: String?){
        print(firstName)
        if profiModel == nil {
            profiModel = ProfileModel(id: nil, phone: nil, firstName: firstName, lastName: lastName, middleName: middleName, position: nil, country: country, city: city, address: adress, addAddress: nil, avatarURL: avatarUrl, coverURL: nil, gender: nil, banStatus: nil, verifiedStatus: nil, userType: nil)
        } else {
            profiModel?.firstName = firstName
            profiModel?.lastName = lastName
            profiModel?.middleName = middleName
            profiModel?.country = country
            profiModel?.city = city
            profiModel?.address = adress
            profiModel?.avatarURL = avatarUrl
        }
        let parameters = try! JSONEncoder().encode(profiModel)
        let params = try! JSONSerialization.jsonObject(with: parameters, options: .allowFragments)as? [String: Any]
        let restUrl = constants.startUrl + "account/v1/user"
        guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
            
            self.utils.checkAutorization(vc: self)
            return
        }
        Alamofire.request(restUrl, method: .put, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]).responseProfileModel { response  in
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
           
            }
            if self.poper == true{
                self.poper = false
                self.dismiss(animated: true, completion: nil)
                self.utils.doneMassage(massage: "Данные изменены", vc: self.view)
            } else{
                 self.utils.doneMassage(massage: "Данные изменены", vc: self.view)
            }
        
        }
        
    }
    @IBAction func editProfile(_ sender: Any) {
        
        self.view.endEditing(true)
        edited = true
        addAvatarView.isHidden = false
        country.isEnabled = true
        country.textColor = .black
        city.isEnabled = true
        city.textColor = .black
        adress.isEnabled = true
        adress.textColor = .black
        firstName.isEnabled = true
        firstName.textColor = .black
        lastName.isEnabled = true
        lastName.textColor = .black
        patronymic.isEnabled = true
        patronymic.textColor = .black
        saveBtn.isHidden = false
        editItem.isEnabled = false
        let swImage = UITapGestureRecognizer(target: self, action: #selector(addAvatar))
        
        swImage.delegate = self
        swImage.numberOfTapsRequired = 1
        addAvatarView.isUserInteractionEnabled = true
        addAvatarView.addGestureRecognizer(swImage)
    }
    func getProfile(){
        
        let restUrl = constants.startUrl + "account/v1/user/me"
        guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
            
            self.utils.checkAutorization(vc: self)
            return
        }
        let headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]
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
            if profileModel?.avatarURL != nil{
                self.avatarUrl = profileModel!.avatarURL!
                self.imageAvatar.downloaded(from: profileModel!.avatarURL!)
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
//        utils.checkPushNot(vc: self)
        guard utils.getSharedPref(key: "accessToken") != nil else{
            
            self.utils.checkAutorization(vc: self)
            
//            self.utils.checkFilds(massage: "Авторизируйтесь", vc: self.view)
            return
        }
    }
    func getAvatar(image: UIImage){
        let imgData = image.sd_imageData()!
        let restUrl = constants.startUrl + "file/v1/upload"
        self.avatarUrl = ""
      
        let parameters = ["open": "true"] //Optional for extra parameter
        let headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "file",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            } //Optional for extra parameters
        },
                         to:restUrl, headers: headers )
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseUploadImage{ response in
                    let result = response.result.value
                    self.avatarUrl = (result?.url)!
                    self.profiModel?.avatarURL = result?.url
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    func setProfile(){
        guard profiModel!.firstName != nil else{
            self.editProfile(self)
            self.utils.checkFilds(massage: "Заполните свой профиль", vc: self.view)
            return
        }
        self.firstName.text =  profiModel?.firstName
        self.lastName.text = profiModel?.lastName
        self.patronymic.text = profiModel?.middleName
        self.country.text = profiModel?.country
        self.city.text = profiModel?.city
        self.adress.text = profiModel?.address
        if profiModel?.avatarURL != nil{
            self.avatarUrl = profiModel!.avatarURL!
            self.imageAvatar.downloaded(from: profiModel!.avatarURL!)
        }
    }
    
}
