//
//  OrderDialog.swift
//  Karma
//
//  Created by macbook on 26/05/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//


import UIKit

protocol OrderDialogDismissDelegate: class {
    func DismissOrder(select: Bool)
}
class OrderDialog: UIViewController, NVActivityIndicatorViewable, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var timeLable: UILabel!
    
    let utils = Utils()
    let constants = Constants()
    var selectedTime = String()
    var delegate: OrderDialogDismissDelegate?
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLable.text = selectedTime
        // Do any additional setup after loading the view.
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(dissmis))
        
        tapGR.delegate = self
        tapGR.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGR)
    }
    
    @objc func dissmis(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        dissmis()
        delegate?.DismissOrder(select: false)
    }
    @IBAction func orderButton(_ sender: Any) {
        
        dissmis()
        delegate?.DismissOrder(select: true)
    }
//    func orderWash(){
//        startAnimating()
//        let restUrl = constants.startUrl + "karma/v1/record"
//        let carInfo = utils.getCarInfo(key: "CARID")!
//        let parameters = try! JSONEncoder().encode(OrderBodyCarWash.init(begin: currentTime, businessID: carWashInfo?.businessID, description: "IOS", packageID: self.text.text, servicesIDS: idServicePrice, targetID: carInfo.carId, workingSpaceID: self.workSpaceId))
//        let params = try! JSONSerialization.jsonObject(with: parameters, options: .allowFragments)as? [String: Any]
//        Alamofire.request(restUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization": (self.utils.getSharedPref(key: "accessToken"))!]).responseJSON { response  in
//            guard self.utils.checkResponse(response: response, vc: self) == true else{
//                self.stopAnimating()
//                return
//            }
//            
//            self.stopAnimating()
//            
//            
//            //            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "mapViewController") as! MapViewController
//            //          self.navigationController?.pushViewController(newViewController, animated: true)
//            self.utils.doneMassage(massage: "Заказ сделан", vc: self.view)
//            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "ordersTableViewController")), animated: true)
//            self.sideMenuViewController!.hideMenuViewController()
//            //            self.sideMenuViewController!.hideMenuViewController()
//            //            let newViewController = MapViewController()
//            //            self.navigationController?.pushViewController(newViewController, animated: true)
//            
//        }
//    }
}

