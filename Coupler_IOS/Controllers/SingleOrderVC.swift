//
//  SingleOrderVC.swift
//  Karma
//
//  Created by macbook on 05/04/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//

import UIKit
import Alamofire
import MaterialComponents

class SingleOrdersServiceCell: UITableViewCell{
    
    @IBOutlet weak var service: UILabel!
}
class SingleOrdersPackegeServiceCell: UITableViewCell{
    
    @IBOutlet weak var service: UILabel!
}

class SingleOrderVC: UIViewController, UITableViewDataSource, NVActivityIndicatorViewable, UIPopoverPresentationControllerDelegate {
    
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
    @IBOutlet weak var showRoate: MDCButton!
    @IBOutlet weak var autoLable: UILabel!
    @IBOutlet weak var autoView: UIView!
    
    var currentTable = UITableView()
    var record: ContentRB? = nil
    var cancelMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       NotificationCenter.default.addObserver(self, selector: #selector(getPushNatRecord), name: Notification.Name(rawValue: "reloadTheTable"), object: nil)
//        utils.checkPushNot(vc: self)
        if record != nil{
        utils.setBorder(view: headerView, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
        packetServiceTable.rowHeight = UITableView.automaticDimension
        packetServiceTable.allowsMultipleSelection = true
        packetServiceTable.allowsMultipleSelectionDuringEditing = true
            
//            packetServiceTable.bottomAnchor.constraint(equalTo:self.view.centerYAnchor, constant:-7).isActive=true
        
        serviceTable.rowHeight = UITableView.automaticDimension
        serviceTable.allowsMultipleSelection = true
        serviceTable.allowsMultipleSelectionDuringEditing = true
//            serviceTable.bottomAnchor.constraint(equalTo:self.view.centerYAnchor, constant:-7).isActive=true
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
        utils.setBorder(view: canselBtn, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), borderWidth: 1, cornerRadius: 8)
        }
        if (self.utils.getSharedPref(key: "OBJECTID")) != nil{
            
            let pushRecordId = (self.utils.getSharedPref(key: "OBJECTID"))!
            getPushRecord(pushRecordId: pushRecordId)
        }
        chackTarget()
        
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
        
        showDialog(.slideLeftRight)
        
    }
    func showDialog(_ animationPattern: LSAnimationPattern) {
        let dialogViewController = CancelOrderDialog(nibName: "CancelOrderDialog", bundle: nil)
        dialogViewController.delegate = self
        dialogViewController.id = record?.id
        presentDialogViewController(dialogViewController, animationPattern: animationPattern)
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
        guard carId != nil else{
            self.stopAnimating()
            return
        }
        let restUrl = constants.startUrl + "karma/v1/car/\(carId!)"
        var carInfo = ""
        Alamofire.request(restUrl, method: .get, encoding: JSONEncoding.default, headers: ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]).responseJSON { response  in
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
    func dismissDialog(chouse: Bool) {
        dismissDialogViewController(LSAnimationPattern.fadeInOut)
        if chouse == true {
//            getCarWashInfoComments()
            self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "ordersTableViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
//        utils.checkPushNot(vc: self)
        guard utils.getSharedPref(key: "accessToken") != nil else{
           
            self.utils.checkAutorization(vc: self)
            
            self.utils.checkFilds(massage: "Авторизируйтесь", vc: self.view)
            stopAnimating()
            return
        }
        if UserDefaults.standard.object(forKey: "SINGLEORDERVC") == nil{
            
            self.utils.setSaredPref(key: "SINGLEORDERVC", value: "true")
            self.showTutorial()
        }
        
    }
    
    func showTutorial() {
        let infoDesc = InfoDescriptor(for: "Тут вы можете увидеть разширенную информацию о вашем заказе")
        var infoTask = PassthroughTask(with: [])
        infoTask.infoDescriptor = infoDesc
        
        
        let leftDesc = LabelDescriptor(for: "Чтобы проложить маршрут нажмите сюда")
        leftDesc.position = .bottom
        let leftHoleDesc = HoleViewDescriptor(view: showRoate, type: .rect(cornerRadius: 5, margin: 10))
        leftHoleDesc.labelDescriptor = leftDesc
        let rightLeftTask = PassthroughTask(with: [leftHoleDesc])
        
        
        let leftDesc1 = LabelDescriptor(for: "Чтобы отменить заказ нажмите сюда")
        leftDesc1.position = .bottom
        let leftHoleDesc1 = HoleViewDescriptor(view: canselBtn, type: .rect(cornerRadius: 5, margin: 10))
        leftHoleDesc1.labelDescriptor = leftDesc1
        let rightLeftTask1 = PassthroughTask(with: [leftHoleDesc1])
        
//        let buttonItemView = addCarItem.value(forKey: "view") as? UIView
//        let leftDesc2 = LabelDescriptor(for: "Чтобы добавить машину нажмите сюда")
//        leftDesc2.position = .left
//        let leftHoleDesc2 = HoleViewDescriptor(view: buttonItemView!, type: .circle)
//        leftHoleDesc2.labelDescriptor = leftDesc2
//        let rightLeftTask2 = PassthroughTask(with: [leftHoleDesc2])
//
        
        
        PassthroughManager.shared.display(tasks: [infoTask, rightLeftTask, rightLeftTask1]) {
            isUserSkipDemo in
            
            print("isUserSkipDemo: \(isUserSkipDemo)")
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
           
                self.utils.checkAutorization(vc: self)
                stopAnimating()
                return
            }
            let headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]
            Alamofire.request(restUrl, method: .get, headers: headers).responseJSON { response  in
                
                guard self.utils.checkResponse(response: response, vc: self) == true else{
                    self.stopAnimating()
                    return
                }
                
                do{
                    let carList = try JSONDecoder().decode(ContentRB.self, from: response.data!)
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

    func chackTarget(){
        if record?.targetID == nil {
            
            self.autoView.visiblity(gone: true)
        }
    }
    
}
