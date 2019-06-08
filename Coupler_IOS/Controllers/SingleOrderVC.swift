//
//  SingleOrderVC.swift
//  Karma
//
//  Created by macbook on 05/04/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//

import UIKit
import Alamofire

class SingleOrdersServiceCell: UITableViewCell{
    
    @IBOutlet weak var service: UILabel!
}
class SingleOrdersPackegeServiceCell: UITableViewCell{
    
    @IBOutlet weak var service: UILabel!
}

class SingleOrderVC: UIViewController, UITableViewDataSource, NVActivityIndicatorViewable {
    
    let constants = Constants()
    let utils = Utils()
    var pushRecordId = ""
    
    
   
    

    @IBOutlet weak var packetServiceTable: UITableView!
    @IBOutlet weak var serviceTable: UITableView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var carInfo: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var packageLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var canselBtn: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var viewPackege: UIView!
    @IBOutlet weak var viewService: UIView!
    @IBOutlet weak var viewCansel: UIView!
    
    var currentTable = UITableView()
    var record: RecordsBodyElement? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
       NotificationCenter.default.addObserver(self, selector: #selector(getPushNatRecord), name: Notification.Name(rawValue: "reloadTheTable"), object: nil)
//        utils.checkPushNot(vc: self)
        if record != nil{
        utils.setBorder(view: headerView, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
        packetServiceTable.rowHeight = UITableView.automaticDimension
        packetServiceTable.allowsMultipleSelection = true
        packetServiceTable.allowsMultipleSelectionDuringEditing = true
        
        serviceTable.rowHeight = UITableView.automaticDimension
        serviceTable.allowsMultipleSelection = true
        serviceTable.allowsMultipleSelectionDuringEditing = true
        print(packetServiceTable.contentSize.height )
        
        status.text = utils.checkStatus(status: (record?.statusProcess)!)
        date.text = utils.milisecondsToDateB(miliseconds: (record?.begin)!)
        time.text = utils.milisecondsToTime(miliseconds: (record?.begin)!, timeZone: (record?.business?.timeZone)!)
        price.text = String((record?.price)!) + " грн"
        duration.text = String(((record?.finish)! - (record?.begin)!)/60000) + " мин"
        getCarInfo()
        name.text = record?.business?.name
        checkNil()
        status.text = utils.checkStatus(status: (record?.statusProcess)!) 
        utils.setBorder(view: canselBtn, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), borderWidth: 1, cornerRadius: 4)
        }
        if (self.utils.getSharedPref(key: "OBJECTID")) != nil{
            
            let pushRecordId = (self.utils.getSharedPref(key: "OBJECTID"))!
            getPushRecord(pushRecordId: pushRecordId)
        }
        
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    @objc func getPushNatRecord(){
        getPushRecord(pushRecordId: (record?.id)!)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func showDirection(_ sender: Any) {
        guard self.utils.getSharedPref(key: "curLat") != nil else {
            SCLAlertView().showInfo("Нет данных о вашем местоположении", closeButtonTitle: "Закрыть")
            return
        }
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "drawRouteVC") as! DrawRouteVC
        vc.destinationLt = String(format:"%f", (record?.business?.latitude)! )
        vc.destinationLg = String(format:"%f", (record?.business?.longitude)!)
        vc.destinationTitle = record?.business?.name
        self.navigationController?.pushViewController(vc, animated: true)
//        self.utils.fetchRoute(sourceLat: self.utils.getSharedPref(key: "curLat")!, sourceLong: self.utils.getSharedPref(key: "curLon")!, destinationLt: String(format:"%f", (record?.business?.latitude)! ), destinationLg: String(format:"%f", (record?.business?.longitude)!), viewController: self)
//        DrawRouteVC
//        SCLAlertView().showInfo("В разработке...", closeButtonTitle: "Закрыть")
    }
    
    @IBAction func cancelOrder(_ sender: Any) {
            let aler = SCLAlertView()
        aler.addButton("Да"){
            self.cancelRecord()
        }
        aler.showNotice("Внимание!", subTitle: "Вы уверены что хотите отменить заказ?", closeButtonTitle: "Закрыть")
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        currentTable = tableView
        if currentTable == packetServiceTable{
            guard record?.packageDto != nil else {
                return 0
            }
            print(record?.packageDto?.services!.count)
            return (record?.packageDto?.services!.count)!
        }else if currentTable == serviceTable{
            guard record?.services != nil else {
                return 0
            }
            print(record?.services!.count)
            return (record?.services!.count)!
        }else {
            return 0    }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        currentTable = tableView
        
        
        currentTable.rowHeight = UITableView.automaticDimension
        currentTable.tableFooterView = UIView()
        if currentTable == packetServiceTable{
            guard record?.packageDto != nil else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "singleOrdersServiceCell", for: indexPath) as! SingleOrdersServiceCell
                currentTable.visiblity(gone: true)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "singleOrdersPackegeServiceCell", for: indexPath) as! SingleOrdersPackegeServiceCell
            
            utils.setBorder(view: cell, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
            let packegeService = record?.packageDto?.services?[indexPath.section]
            cell.service.text = packegeService?.name
            return cell
        } else if currentTable == serviceTable{
            guard record?.services != nil else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "singleOrdersServiceCell", for: indexPath) as! SingleOrdersServiceCell
                
                currentTable.visiblity(gone: true)
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "singleOrdersServiceCell", for: indexPath) as! SingleOrdersServiceCell
            let service = record?.services?[indexPath.section]
            
            utils.setBorder(view: cell, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
            cell.service.text = service?.name
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "singleOrdersServiceCell", for: indexPath) as! SingleOrdersServiceCell
            return cell
        }
    }
    private func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    private func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
        
    }
    
    func getCarInfo(){
        startAnimating()
        let carId = record?.targetID
        let restUrl = constants.startUrl + "karma/v1/car/\(carId!)"
        var carInfo = ""
        Alamofire.request(restUrl, method: .get, encoding: JSONEncoding.default, headers: ["Authorization": (self.utils.getSharedPref(key: "accessToken"))!]).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            do{
                let carList = try JSONDecoder().decode(AllCarListElement.self, from: response.data!)
                carInfo = (carList.brand?.name)! + " " + (carList.model?.name)!
                
                self.carInfo.text = carInfo
             
            }
            catch{
                
            }
            
            self.stopAnimating()
            
          
            
       
            
        }
    }
    
    @objc func cancelRecord(){
        startAnimating()
        let toDo: [String: Any]  = ["idRecord": (record?.id)!]
        let restUrl = constants.startUrl + "karma/v1/record/record/canceled"
        Alamofire.request(restUrl, method: .put, parameters: toDo, headers: ["Authorization": (self.utils.getSharedPref(key: "accessToken"))!]).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "ordersTableViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
            self.stopAnimating()
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        currentTable = tableView
//
//        if currentTable == packetServiceTable{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "singleOrdersPackegeServiceCell", for: indexPath) as! SingleOrdersPackegeServiceCell
//            let packegeService = record?.packageDto?.services?[indexPath.row]
//            cell.service.text = packegeService?.name
//            return cell
//        } else if currentTable == serviceTable{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "singleOrdersServiceCell", for: indexPath) as! SingleOrdersServiceCell
//            let service = record?.services?[indexPath.row]
//            cell.service.text = service?.name
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "singleOrdersServiceCell", for: indexPath) as! SingleOrdersServiceCell
//        return cell
//        }
//    }
    override func viewDidAppear(_ animated: Bool) {
        
//        utils.checkPushNot(vc: self)
        guard utils.getSharedPref(key: "accessToken") != nil else{
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
            self.utils.checkFilds(massage: "Авторизируйтесь", vc: self.view)
            stopAnimating()
            return
        }
    }
    func checkNil(){
        if record?.packageDto == nil {
        self.viewPackege.visiblity(gone: true)
        self.packageLabel.visiblity(gone: true)
        self.packetServiceTable.visiblity(gone: true)
        }
        if record?.services == nil {
        self.viewService.visiblity(gone: true)
        self.serviceLabel.visiblity(gone: true)
        self.serviceTable.visiblity(gone: true)
        }
        
        
        switch record?.statusProcess {
        case "CANCELED":
            self.canselBtn.visiblity(gone: true)
            self.viewCansel.visiblity(gone: true)
        case "IN_PROCESS":
            self.canselBtn.visiblity(gone: true)
            self.viewCansel.visiblity(gone: true)
        case "COMPLETED":
            self.canselBtn.visiblity(gone: true)
            self.viewCansel.visiblity(gone: true)
        default:
            break
        
        }
    }
    func getPushRecord(pushRecordId: String){
            startAnimating()
            UserDefaults.standard.removeObject(forKey: "OBJECTID")
        let restUrl = constants.startUrl + "karma/v1/record/\(pushRecordId)"
            guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
                self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
                self.sideMenuViewController!.hideMenuViewController()
                stopAnimating()
                return
            }
            let headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!]
            Alamofire.request(restUrl, method: .get, headers: headers).responseJSON { response  in
                
                guard self.utils.checkResponse(response: response, vc: self) == true else{
                    self.stopAnimating()
                    return
                }
                
                do{
                    let carList = try JSONDecoder().decode(RecordsBodyElement.self, from: response.data!)
                    self.record = carList
                    self.packetServiceTable.reloadData()
                    self.serviceTable.reloadData()
                    self.viewDidLoad()
                    
                }
                catch{
                    print(error)
                }
                
                self.stopAnimating()
                
                
            }
        }

    
}
