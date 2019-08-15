//
//  CheckServer.swift
//  Coupler_IOS
//
//  Created by macbook on 15/08/2019.
//  Copyright © 2019 Coupler. All rights reserved.
//

import UIKit
import Alamofire

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
               
                return
            }
            guard response.result.error == nil else {
              
                return 
            }
            self.dismiss(animated: true, completion: nil)
            self.stopAnimating()
            
        }
    }


}
