//
//  ProfileStartVC.swift
//  Coupler_IOS
//
//  Created by macbook on 23/07/2019.
//  Copyright © 2019 Coupler. All rights reserved.
//

import UIKit
import Alamofire

class ProfileStartVC: UIViewController, UIGestureRecognizerDelegate, NVActivityIndicatorViewable {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userNumber: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userPoints: UILabel!
    @IBOutlet weak var userMassage: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var pointsView: UIView!
    @IBOutlet weak var massageView: UIView!
    @IBOutlet weak var carListView: UIView!
    @IBOutlet weak var shareView: UIView!
    
    
    var profiModel: ProfileModel?
    var referralCode: String?
    var poper = Bool()
    
    let constants = Constants()
    let utils = Utils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getReferralCode()
        let showQR = UITapGestureRecognizer(target: self, action: #selector(goQRCode))
        showQR.delegate = self
        showQR.numberOfTapsRequired = 1
        shareView.addGestureRecognizer(showQR)
        let showProfile = UITapGestureRecognizer(target: self, action: #selector(goToProfile))
        showProfile.delegate = self
        showProfile.numberOfTapsRequired = 1
        profileView.addGestureRecognizer(showProfile)
        let showCarList = UITapGestureRecognizer(target: self, action: #selector(carListBtn))
        showCarList.delegate = self
        showCarList.numberOfTapsRequired = 1
        carListView.addGestureRecognizer(showCarList)
        // Do any additional setup after loading the view.
    }
    @objc func goQRCode(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "qRCodeVC") as! QRCodeVC
        vc.url = "https://coupler.app/r/?ref=\(referralCode!)"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func goToProfile(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
        vc.profiModel = profiModel
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func carListBtn() {
        guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
           
            self.utils.checkAutorization(vc: self)
            return
        }
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "сarListViewController") as! CarListViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func getProfile(){
        self.startAnimating()
        let restUrl = constants.startUrl + "account/v1/user/me"
        guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
            
            self.utils.checkAutorization(vc: self)
            self.stopAnimating()
            return
        }
        let headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]
        Alamofire.request(restUrl, method: .get, headers: headers).responseProfileModel { response in
            
            let profileModel = response.result.value
            guard profileModel?.firstName != nil else{
                self.goToProfile()
                self.stopAnimating()
                return
            }
            self.userName.text = (profileModel?.firstName)! + " " + (profileModel?.lastName)!
            self.userNumber.text = "+" + (profileModel?.phone)!
            if profileModel?.avatarURL != nil{
                self.userImage.downloaded(from: (profileModel?.avatarURL)!)
            }
            self.profiModel = profileModel
           self.stopAnimating()
        }
    }
    
    func getScore(){
        self.startAnimating()
        let restUrl = constants.startUrl + "karma/v1/bonus-score/me"
        guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
            
            self.utils.checkAutorization(vc: self)
            self.stopAnimating()
            return
        }
        let headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]
        Alamofire.request(restUrl, method: .get, headers: headers).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            
            do{
                
                let responseBody = try JSONDecoder().decode(ScoreBody.self, from: response.data!)
                self.userPoints.text = responseBody.score
            }
            catch{
                print(error)
            }
            self.stopAnimating()
        }
    }
    func getReferralCode(){
        self.startAnimating()
        let restUrl = constants.startUrl + "account/v1/user/referral-code/me"
        guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
            
            self.utils.checkAutorization(vc: self)
            self.stopAnimating()
            return
        }
        let headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]
        Alamofire.request(restUrl, method: .get, headers: headers).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            
            do{
                
                let responseBody = try JSONDecoder().decode(ReferralCode.self, from: response.data!)
                self.referralCode = responseBody.code
            }
            catch{
                print(error)
            }
            self.stopAnimating()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
        getProfile()
        getScore()
        
    }
}
