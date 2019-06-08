//
//  BusinessTableViewController.swift
//  Karma
//
//  Created by macbook on 25/04/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//

import UIKit
import Alamofire

class BuisnessViewCell: UITableViewCell{
    @IBOutlet weak var buisnessName: UILabel!
    @IBOutlet weak var buisnesId: UILabel!
    
    @IBOutlet weak var buisnesLogo: UIImageView!
}
struct BuisnesList {
    let name: String?
    let id: String?
}

class BusinessTableViewController: UIViewController, NVActivityIndicatorViewable, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet var tableBuisness: UITableView!
    let constants = Constants()
    let utils = Utils()
    var buisness = BuisnessBody()
    var selectedRecord: BuisnessBodyElement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableBuisness.rowHeight = UITableView.automaticDimension
        tableBuisness.allowsMultipleSelection = true
        tableBuisness.allowsMultipleSelectionDuringEditing = true
        utils.checkPushNot(vc: self)
        let logo = UIImage(named: "logo_appbar_v1")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
//        tableBuisness.rowHeight = UITableView.automaticDimension
//        tableBuisness.tableFooterView = UIView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return buisness.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
        
    }
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buisnessViewCell", for: indexPath) as! BuisnessViewCell

        let record = buisness[indexPath.section]
        cell.buisnesId.text = record.id!
        cell.buisnessName.text = record.name!
        
        
        utils.setBorder(view: cell, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
        cell.buisnesLogo.downloaded(from: record.imageURL!)
//        switch record.id {
//        case "0c1ca141-fb7d-414c-999f-ed8a8af69b1c":
//             cell.buisnesLogo.image =  UIImage(named: "icons8-car-cleaning-48")
//        case "6a7d64fd-1538-430d-be52-c92ef28d2d3a":
//            cell.buisnesLogo.image =  UIImage(named: "icons8-car-service-48")
//        case "607b10e5-fc65-463d-a116-5fae6019c782":
//            cell.buisnesLogo.image =  UIImage(named: "icons8-tire-filled-48")
//        default:
//            cell.buisnesLogo.image =  UIImage(named: "logo_v1SmallLogo")
//        }
        // Configure the cell...

        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.isSelected{
            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
        } else {
            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buisnessViewCell", for: indexPath) as! BuisnessViewCell

        let record = buisness[indexPath.section]
        self.selectedRecord = record
       
        guard record.active == true else{
            utils.checkFilds(massage: "Скоро будет доступно", vc: self.view)
            return
        }
        UIView.animate(withDuration: 0.4, delay: 0.0, options:[.transitionCurlDown], animations: {
            
            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
            
        }, completion:nil)
        self.utils.setSaredPref(key: "BUISNESSTYPE", value: record.businessType!)
        self.utils.setSaredPref(key: "BUISNESSID", value: record.id!)
        self.utils.setSaredPref(key: "BUISNESSNAME", value: record.name!)
    self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "mapViewController")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buisnessViewCell", for: indexPath) as! BuisnessViewCell

        UIView.animate(withDuration: 0.2, delay: 0.0, options:[.curveEaseInOut], animations: {
            cell.contentView.backgroundColor = .white
            
        }, completion:nil)
    }

    
    func getAllBuisness(){
        startAnimating()
        let restUrl = constants.startUrl + "karma/v1/business-category"
        Alamofire.request(restUrl, method: .get).responseJSON { response  in
            
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            
            do{
                let carList = try JSONDecoder().decode(BuisnessBody.self, from: response.data!)
                self.buisness.removeAll()
                //                for element in carList{
                //                    self.recordListData.append(RecordData.init(carwoshImage: element.business?.logoURL, orderDate: element.begin, carwashName: element.business?.name, orderPrice: element.price, carwoshLatitude: element.business?.latitude, carwashLongitude: element.business?.longitude, orderStatus: element.statusProcess))
                //                }
                self.buisness = carList
                
            }
            catch{
                print(error)
            }
            
            self.stopAnimating()
            
            
            self.tableBuisness.reloadData()
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
       
        getAllBuisness()
    }

}
