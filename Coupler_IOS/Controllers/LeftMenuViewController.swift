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
    

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func viewDidAppear(_ animated: Bool) {
       checkAccesToken()
    }
    override public func viewDidLoad() {
        super.viewDidLoad()
       checkAccesToken()
        
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
    self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "mapViewController")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
        return
    }
    
    @IBAction func mapBtn(_ sender: Any) {
    self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "mapViewController")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
    @IBAction func carListBtn(_ sender: Any) {
        guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
        self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            return
        }
    self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "сarListViewController")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
    
    @IBAction func orderListBtn(_ sender: Any) {
        guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
        self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            return
        }
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
        self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "aboutUs")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
    @IBAction func enterBtn(_ sender: Any) {
        
        self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
        
        
    }
    
    @IBAction func businessBtn(_ sender: Any) {
        self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "businessTableViewController")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
    func checkAccesToken(){
        if UserDefaults.standard.object(forKey: "accessToken") != nil{
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
}
