//
//  SetMarkerDialog.swift
//  Coupler_IOS
//
//  Created by macbook on 28/08/2019.
//  Copyright © 2019 Coupler. All rights reserved.
//

import UIKit
import MaterialComponents
import Alamofire

import CoreLocation


struct NewMarker: Codable {
    let businessCategoryID: String
    let latitude, longitude: Double
    let name, phone: String
    
    enum CodingKeys: String, CodingKey {
        case businessCategoryID = "businessCategoryId"
        case latitude, longitude, name, phone
    }
}


class SetMarkerDialog: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var categotyTable: UITableView!
    @IBOutlet weak var markerName: MDCTextField!
    @IBOutlet weak var markerPhone: MDCTextField!
    
    
    let constants = Constants()
    let utils = Utils()
    var selectedId = ""
    var buisness = BuisnessBody()
    var currentCoordinate: CLLocationCoordinate2D?
    var frameY = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        markerName.addDoneCancelToolbar()
        markerPhone.addDoneCancelToolbar()
        categotyTable.tableFooterView = UIView()
        categotyTable.layoutIfNeeded()
        categotyTable.invalidateIntrinsicContentSize()
        categotyTable.rowHeight = UITableView.automaticDimension
        getAllBuisness()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            frameY = self.view.frame.origin.y
            //            if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardSize.height / 2
            //            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != frameY {
            self.view.frame.origin.y = frameY
        }
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func add(_ sender: Any) {
        guard selectedId != "" else{
            utils.checkFilds(massage: NSLocalizedString("enter_busines_cat", comment: ""), vc: self.view)
            return
        }
        guard markerName.text!.count >= 2 else{
            utils.checkFilds(massage: NSLocalizedString("enter_name_of", comment: ""), vc: self.view)
            return
        }
        guard markerPhone.text!.count >= 7 else{
            utils.checkFilds(massage: NSLocalizedString("Enter_phone", comment: ""), vc: self.view)
            return
        }
        orderWash(param: NewMarker(businessCategoryID: selectedId, latitude: currentCoordinate!.latitude, longitude: currentCoordinate!.longitude, name: markerName.text!, phone: markerPhone.text!))
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return buisness.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryBisunes", for: indexPath) as! CategoryBuisnesCell
        
        let record = buisness[indexPath.section]
      self.utils.setBorder(view: cell, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.0417380137), borderWidth: 1, cornerRadius: 4)
        cell.id.text = record.id!
        cell.name.text = record.name!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellForIndex = cell as! CategoryBuisnesCell
        if cellForIndex.isSelected{
            
            self.utils.setBorder(view: cellForIndex, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), borderWidth: 1, cornerRadius: 4)
            cellForIndex.name.textColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
        } else {
            self.utils.setBorder(view: cellForIndex, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.0417380137), borderWidth: 1, cornerRadius: 4)
            
            cellForIndex.name.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let cell = tableView.cellForRow(at: indexPath) as! CategoryBuisnesCell
        UIView.animate(withDuration: 0.4, delay: 0.0, options:[.transitionCurlDown], animations: {
            
            self.utils.setBorder(view: cell, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), borderWidth: 1, cornerRadius: 4)
            cell.name.textColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
            
        }, completion:nil)
        selectedId = cell.id.text!
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell: CategoryBuisnesCell = tableView.cellForRow(at: indexPath) as! CategoryBuisnesCell
        UIView.animate(withDuration: 0.4, delay: 0.0, options:[.transitionCurlDown], animations: {
            self.utils.setBorder(view: cell, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.0417380137), borderWidth: 1, cornerRadius: 4)
            
            cell.name.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
        }, completion:nil)
    }
    
    func getAllBuisness(){
        showActivityIndicator()
        let restUrl = constants.startUrl + "karma/v1/business-category"
        Alamofire.request(restUrl, method: .get, headers: constants.appID).responseJSON { response  in
            
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.hideActivityIndicator()
                return
            }
            
            do{
                let carList = try JSONDecoder().decode(BuisnessBody.self, from: response.data!)
                self.buisness.removeAll()
                for record in carList{
                    
                    if record.active == true{
                        self.buisness.append(record)
                    }
                }
                
            }
            catch{
                print(error)
            }
            
            self.hideActivityIndicator()
            
            
            self.categotyTable.reloadData()
            
            self.categotyTable.invalidateIntrinsicContentSize()
            
            
        }
    }
    
    func orderWash(param : NewMarker){
        showActivityIndicator()
        
        var parameters = try! JSONEncoder().encode(param)
       
        let restUrl = constants.startUrl + "karma/v1/business/create-empty"
        //        self.worker = Worker.init(userID: nil, position: nil, businessID: nil, id: workerId, corporationID: nil, workTimes: nil, workingSpaceID: nil, user: nil)
        //
        
        let params = try! JSONSerialization.jsonObject(with: parameters, options: .allowFragments)as? [String: Any]
        Alamofire.request(restUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.hideActivityIndicator()
                return
            }
            self.utils.doneMassage(massage: NSLocalizedString("new_marker_done", comment: ""), vc: self.view)
            self.dismiss(animated: true, completion: nil)
            self.hideActivityIndicator()
            
            
            
        }
    }

}
