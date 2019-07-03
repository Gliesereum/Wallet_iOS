//
//  LeftMenuViewController.swift
//  AKSideMenuSimple
//
//  Created by Diogo Autilio on 6/7/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import UIKit
import Alamofire

public class LeftMenuViewController: UIViewController{
    @IBOutlet weak var carList: UIButton!
    @IBOutlet weak var orderList: UIButton!
//    @IBOutlet weak var profile: UIButton!
    @IBOutlet weak var sigIn: UIButton!
    @IBOutlet weak var exitBtn: UIButton!
    @IBOutlet weak var businessBtn: UIButton!
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var orderListImage: UIImageView!
    @IBOutlet weak var buisnesListImage: UIImageView!
    @IBOutlet weak var exitImage: UIImageView!
    @IBOutlet weak var aboutUsImage: UIImageView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var buisnesView: UIView!
    @IBOutlet weak var orderListView: UIView!
    @IBOutlet weak var carView: UIView!
    @IBOutlet weak var aboutUsView: UIView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    //    @IBOutlet weak var version: UILabel!
    
    
    let utils = Utils()
    
    let constants = Constants()
    var userAvatar = ""
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        
    }
    public override func viewWillAppear(_ animated: Bool) {
//        chackAvatar()
        checkAccesToken()
    }
    public override func viewDidAppear(_ animated: Bool) {
//       checkAccesToken()
       
        checkBuisnes()
        
    }
    func checkBuisnes(){
        if UserDefaults.standard.object(forKey: "BUISNESSNAME") != nil{
//            guard mapButton.titleLabel?.text == "Карта" + "(" + (UserDefaults.standard.object(forKey: "BUISNESSNAME") as! String) + ")" else{
                mapButton.setTitle("Карта" + "(" + (UserDefaults.standard.object(forKey: "BUISNESSNAME") as! String) + ")", for: .normal)
            
        }
    }
    override public func viewDidLoad() {
        super.viewDidLoad()
//        version.text = "Версия: " + ((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!)
//       checkAccesToken()
        
//        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    @IBAction func btnExit(_ sender: Any) {
        carList.isEnabled = false
        orderList.isEnabled = false
        profileBtn.isEnabled = false
//        userInfo.text = "Coupler"
//        userImage.image = UIImage(named: "logo_v1SmallLogo")
        sigIn.isHidden = false
        sigIn.isEnabled = true
        exitBtn.isHidden = true
        exitBtn.isEnabled = false
        self.sideMenuViewController!.hideMenuViewController()
        deleteToken()
        self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "mapViewController")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
        return
    }
    
    @IBAction func mapBtn(_ sender: Any) {
   
        changeButton(button: mapButton)
        self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "mapViewController")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
    @IBAction func carListBtn(_ sender: Any) {
        guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
            self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            return
        }
   
        changeButton(button: carList)
        self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "сarListViewController1")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
    
    @IBAction func orderListBtn(_ sender: Any) {
        guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
            self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            return
        }
        changeButton(button: orderList)
        self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "ordersTableViewController")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
    
    @IBAction func profileBtn(_ sender: Any) {
        guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
            self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            return
        }
        
       
        changeButton(button: profileBtn)
    self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "profileViewController")), animated: true)
    self.sideMenuViewController!.hideMenuViewController()
    }
    
    @IBAction func aboutUsBtn(_ sender: Any) {
       
        changeButton(button: aboutButton)
        self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "aboutUs")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
    @IBAction func enterBtn(_ sender: Any) {
        
        self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
        
        
    }
    
    @IBAction func businessBtn(_ sender: Any) {
       
        changeButton(button: businessBtn)
        self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "businessTableViewController")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
    func checkAccesToken(){
        if UserDefaults.standard.object(forKey: "accessToken") != nil{
//            guard userInfo.text != (UserDefaults.standard.object(forKey: "USER") as! String)else {
//                return
//            }
//            if UserDefaults.standard.object(forKey: "USER") != nil{
//                userInfo.text = (UserDefaults.standard.object(forKey: "USER") as! String)
//            }else{
//                userInfo.text = "Заполните профиль"
//            }
//            if UserDefaults.standard.object(forKey: "USERAVATAR") != nil{
//                self.userAvatar = UserDefaults.standard.object(forKey: "USERAVATAR") as! String
//                userImage.downloaded(from: UserDefaults.standard.object(forKey: "USERAVATAR") as! String)
//            }else{
//                userImage.image = UIImage(named: "IconProfile")
//            }
//
            carList.isEnabled = true
            orderList.isEnabled = true
            profileBtn.isEnabled = true
//            profile.isHidden = false
            carList.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            orderList.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            sigIn.isHidden = true
            sigIn.isEnabled = false
            exitBtn.isHidden = false
            exitBtn.isEnabled = true
        }else{
//            guard userInfo.text != (UserDefaults.standard.object(forKey: "USER") as! String) else {
//            return
//            }
//            userInfo.text = "Coupler"
//            userImage.image = UIImage(named: "logo_v1SmallLogo")
            carList.isEnabled = false
            orderList.isEnabled = false
            profileBtn.isEnabled = false
//            profile.isHidden = true
            carList.titleLabel?.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            orderList.titleLabel?.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            sigIn.isHidden = false
            sigIn.isEnabled = true
            exitBtn.isHidden = true
            exitBtn.isEnabled = false
        }
        
       
    }
    public override func viewDidDisappear(_ animated: Bool) {
//        checkAccesToken()
    }
    func changeButton(button: UIButton){
        let selectImage = UIImage(named: "bgSelectMenuItem")!
        switch button {
        case orderList:
            setDefaulButton()
            UIView.animate(withDuration: 0.4, delay: 0.0, options:[.transitionCurlDown], animations: {
                self.orderListImage.image = UIImage(named: "list_alt-24pxorange")
                self.orderListView.backgroundColor = UIColor(patternImage: selectImage)
                button.setTitleColor(#colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), for: .normal)
            }, completion:nil)
        case mapButton:
            setDefaulButton()
            UIView.animate(withDuration: 0.4, delay: 0.0, options:[.transitionCurlDown], animations: {
                self.mapImage.image = UIImage(named: "explore-24pxorange")
                self.mapView.backgroundColor = UIColor(patternImage: selectImage)
                button.setTitleColor(#colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), for: .normal)
            }, completion:nil)
        case businessBtn:
            setDefaulButton()
            UIView.animate(withDuration: 0.4, delay: 0.0, options:[.transitionCurlDown], animations: {
                self.buisnesListImage.image = UIImage(named: "store-24pxorange")
                self.buisnesView.backgroundColor = UIColor(patternImage: selectImage)
                button.setTitleColor(#colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), for: .normal)
            }, completion:nil)
        case carList:
            setDefaulButton()
            UIView.animate(withDuration: 0.4, delay: 0.0, options:[.transitionCurlDown], animations: {
                self.carImage.image = UIImage(named: "car-24pxorange")
                self.carView.backgroundColor = UIColor(patternImage: selectImage)
                button.setTitleColor(#colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), for: .normal)
            }, completion:nil)
        case aboutButton:
            setDefaulButton()
            UIView.animate(withDuration: 0.4, delay: 0.0, options:[.transitionCurlDown], animations: {
                self.aboutUsImage.image = UIImage(named: "info-24pxorange")
                self.aboutUsView.backgroundColor = UIColor(patternImage: selectImage)
                button.setTitleColor(#colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), for: .normal)
            }, completion:nil)
        case profileBtn:
                setDefaulButton()
                UIView.animate(withDuration: 0.4, delay: 0.0, options:[.transitionCurlDown], animations: {
                    self.profileImage.image = UIImage(named: "profile_Orange")
                    self.profileView.backgroundColor = UIColor(patternImage: selectImage)
                    button.setTitleColor(#colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), for: .normal)
                }, completion:nil)
            
        default:
            setDefaulButton()
        }
    }
    func setDefaulButton(){
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options:[.transitionCurlDown], animations: {
            self.orderListImage.image = UIImage(named: "list_alt-24pxblack")
            self.orderListView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.orderList.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.carImage.image = UIImage(named: "car-24pxblack")
            self.carView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.carList.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.buisnesListImage.image = UIImage(named: "store-24pxblack")
            self.buisnesView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.businessBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.mapImage.image = UIImage(named: "explore-24pxblack")
            self.mapView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.mapButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.aboutUsImage.image = UIImage(named: "info-24pxblack")
            self.aboutUsView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.aboutButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            
            self.profileImage.image = UIImage(named: "profile_Black")
            self.profileView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.profileBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            
        }, completion:nil)
    }
//    func chackAvatar(){
//        guard UserDefaults.standard.object(forKey: "USERAVATAR") != nil else{
//            return
//        }
//        if userAvatar != UserDefaults.standard.object(forKey: "USERAVATAR") as! String{
//            userImage.downloaded(from: UserDefaults.standard.object(forKey: "USERAVATAR") as! String)
//        }
//    }
    
    func deleteToken(){
        let token = utils.getSharedPref(key: "REGISTRATIONTOKEN")
        let restUrl = constants.startUrl + "notification/v1/user-device?registrationToken=\(token!)"
        Alamofire.request(restUrl, method: .delete, headers: ["Authorization": (self.utils.getSharedPref(key: "accessToken"))!]).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                return
            }
            
            UserDefaults.standard.removeObject(forKey: "accessToken")
            UserDefaults.standard.removeObject(forKey: "refreshToken")
            UserDefaults.standard.removeObject(forKey: "CARID")
            UserDefaults.standard.removeObject(forKey: "USERAVATAR")
            UserDefaults.standard.removeObject(forKey: "USER")
            UserDefaults.standard.removeObject(forKey: "REGISTRATIONTOKEN")
        
        }
    }
}
