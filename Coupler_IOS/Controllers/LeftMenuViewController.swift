//
//  LeftMenuViewController.swift
//  AKSideMenuSimple
//
//  Created by Diogo Autilio on 6/7/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import UIKit

public class LeftMenuViewController: UIViewController{
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userInfo: UILabel!
    @IBOutlet weak var carList: UIButton!
    @IBOutlet weak var orderList: UIButton!
    @IBOutlet weak var profile: UIButton!
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
    @IBOutlet weak var version: UILabel!
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func viewWillDisappear(_ animated: Bool) {
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
        version.text = "Версия: " + ((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!)
//       checkAccesToken()
        
//        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    @IBAction func btnExit(_ sender: Any) {
        carList.isEnabled = false
        orderList.isEnabled = false
        profile.isEnabled = false
        userInfo.text = "Coupler"
        userImage.image = UIImage(named: "logo_v1SmallLogo")
        sigIn.isHidden = false
        sigIn.isEnabled = true
        exitBtn.isHidden = true
        exitBtn.isEnabled = false
        self.sideMenuViewController!.hideMenuViewController()
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "CARID")
        UserDefaults.standard.removeObject(forKey: "USERAVATAR")
        UserDefaults.standard.removeObject(forKey: "USER")
        
    self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "mapViewController")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
        return
    }
    
    @IBAction func mapBtn(_ sender: Any) {
   
        changeButton(button: mapButton)
    self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "mapViewController")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
    @IBAction func carListBtn(_ sender: Any) {
        guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
        self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            return
        }
   
        changeButton(button: carList)
    self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "сarListViewController")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
    
    @IBAction func orderListBtn(_ sender: Any) {
        guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
        self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            return
        }
        changeButton(button: orderList)
    self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "ordersTableViewController")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
    
    @IBAction func profileBtn(_ sender: Any) {
        guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
        self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            return
        }
        
    self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "profileViewController")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
    
    @IBAction func aboutUsBtn(_ sender: Any) {
       
        changeButton(button: aboutButton)
    self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "aboutUs")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
    @IBAction func enterBtn(_ sender: Any) {
        
    self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
        
        
    }
    
    @IBAction func businessBtn(_ sender: Any) {
       
        changeButton(button: businessBtn)
    self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "businessTableViewController")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
    func checkAccesToken(){
        if UserDefaults.standard.object(forKey: "accessToken") != nil{
//            guard userInfo.text != (UserDefaults.standard.object(forKey: "USER") as! String)else {
//                return
//            }
            if UserDefaults.standard.object(forKey: "USER") != nil{
                userInfo.text = (UserDefaults.standard.object(forKey: "USER") as! String)
            }else{
                userInfo.text = "Заполните профиль"
            }
            if UserDefaults.standard.object(forKey: "USERAVATAR") != nil{
                
                userImage.downloaded(from: UserDefaults.standard.object(forKey: "USERAVATAR") as! String)
            }else{
                userImage.image = UIImage(named: "IconProfile")
            }
            
            carList.isEnabled = true
            orderList.isEnabled = true
            profile.isEnabled = true
            profile.isHidden = false
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
            userInfo.text = "Coupler"
            userImage.image = UIImage(named: "logo_v1SmallLogo")
            carList.isEnabled = false
            orderList.isEnabled = false
            profile.isEnabled = false
            profile.isHidden = true
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
        switch button {
        case orderList:
            setDefaulButton()
            UIView.animate(withDuration: 0.4, delay: 0.0, options:[.transitionCurlDown], animations: {
                self.orderListImage.image = UIImage(named: "list_alt-24pxorange")
                self.orderListView.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
                button.setTitleColor(#colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), for: .normal)
            }, completion:nil)
        case mapButton:
            setDefaulButton()
            UIView.animate(withDuration: 0.4, delay: 0.0, options:[.transitionCurlDown], animations: {
                self.mapImage.image = UIImage(named: "explore-24pxorange")
                self.mapView.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
                button.setTitleColor(#colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), for: .normal)
            }, completion:nil)
        case businessBtn:
            setDefaulButton()
            UIView.animate(withDuration: 0.4, delay: 0.0, options:[.transitionCurlDown], animations: {
                self.buisnesListImage.image = UIImage(named: "store-24pxorange")
                self.buisnesView.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
                button.setTitleColor(#colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), for: .normal)
            }, completion:nil)
        case carList:
            setDefaulButton()
            UIView.animate(withDuration: 0.4, delay: 0.0, options:[.transitionCurlDown], animations: {
                self.carImage.image = UIImage(named: "car-24pxorange")
                self.carView.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
                button.setTitleColor(#colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), for: .normal)
            }, completion:nil)
        case aboutButton:
            setDefaulButton()
            UIView.animate(withDuration: 0.4, delay: 0.0, options:[.transitionCurlDown], animations: {
                self.aboutUsImage.image = UIImage(named: "info-24pxorange")
                self.aboutUsView.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
                button.setTitleColor(#colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), for: .normal)
            }, completion:nil)
        default:
            setDefaulButton()
        }
    }
    func setDefaulButton(){
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options:[.transitionCurlDown], animations: {
            self.orderListImage.image = UIImage(named: "list_alt-24pxblack")
            self.orderListView.backgroundColor = #colorLiteral(red: 0.9844431281, green: 0.9844661355, blue: 0.9844536185, alpha: 1)
            self.orderList.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.carImage.image = UIImage(named: "car-24pxblack")
            self.carView.backgroundColor = #colorLiteral(red: 0.9844431281, green: 0.9844661355, blue: 0.9844536185, alpha: 1)
            self.carList.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.buisnesListImage.image = UIImage(named: "store-24pxblack")
            self.buisnesView.backgroundColor = #colorLiteral(red: 0.9844431281, green: 0.9844661355, blue: 0.9844536185, alpha: 1)
            self.businessBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.mapImage.image = UIImage(named: "explore-24pxblack")
            self.mapView.backgroundColor = #colorLiteral(red: 0.9844431281, green: 0.9844661355, blue: 0.9844536185, alpha: 1)
            self.mapButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.aboutUsImage.image = UIImage(named: "info-24pxblack")
            self.aboutUsView.backgroundColor = #colorLiteral(red: 0.9844431281, green: 0.9844661355, blue: 0.9844536185, alpha: 1)
            self.aboutButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            
        }, completion:nil)
    }
}
