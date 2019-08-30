//
//  CheckServer.swift
//  Coupler_IOS
//
//  Created by macbook on 15/08/2019.
//  Copyright © 2019 Coupler. All rights reserved.
//

import UIKit
import Alamofire

struct CheckServerBody: Codable {
    let proxyService, fileService, notificationService, permissionService: String?
    let lendingGalleryService, karmaService, accountService, mailService: String?
    
    enum CodingKeys: String, CodingKey {
        case proxyService = "PROXY-SERVICE"
        case fileService = "FILE-SERVICE"
        case notificationService = "NOTIFICATION-SERVICE"
        case permissionService = "PERMISSION-SERVICE"
        case lendingGalleryService = "LENDING-GALLERY-SERVICE"
        case karmaService = "KARMA-SERVICE"
        case accountService = "ACCOUNT-SERVICE"
        case mailService = "MAIL-SERVICE"
    }
}

class CheckServer: UIViewController, NVActivityIndicatorViewable {

    
    let constants = Constants()
    let utils = Utils()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func checkButton(_ sender: Any) {
        getAllBuisness()
    }
    func getAllBuisness(){
        startAnimating()
        let restUrl = constants.startUrl + "status"
        Alamofire.request(restUrl, method: .get, headers: constants.appID).responseJSON { response  in
            
            guard response.response?.statusCode != 500 else{
               
                self.stopAnimating()
                return
            }
            guard response.result.error == nil else {
              
                self.stopAnimating()
                return 
            }
            do{
                let carList = try JSONDecoder().decode(CheckServerBody.self, from: response.data!)
                
                if carList.accountService == "UP" && carList.karmaService == "UP" && carList.mailService == "UP"{
                    
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
            catch{
                print(error)
            }
            self.stopAnimating()
            
        }
    }


}
