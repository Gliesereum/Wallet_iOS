//
//  OrdersTableViewController.swift
//  Karma
//
//  Created by macbook on 14/03/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class OrdersVIewCell: UITableViewCell{
    
    let utils = Utils()
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var carwoshImage: UIImageView!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var carwashName: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var getRowButton: UIButton!
    @IBOutlet weak var carwoshLatitude: UILabel!
    @IBOutlet weak var carwashLongitude: UILabel!
    @IBAction func getRote(_ sender: Any) {
       
    let vc = OrdersTableViewController()
    TinyToast.shared.show(message: "Данная опция в разработке", valign: .bottom, duration: .normal)
//        utils.fetchRoute(sourceLat: utils.getSharedPref(key: "curLat")!, sourceLong: utils.getSharedPref(key: "curLon")!, destinationLt: carwoshLatitude.text!, destinationLg: carwashLongitude.text!, viewController: vc)
    }
}

struct  RecordData {
    var carwoshImage: String?
    var orderDate: Int?
    var carwashName: String?
    var orderPrice: Int?
    var carwoshLatitude: Double?
    var carwashLongitude: Double?
    var orderStatus: String?
}

class OrdersTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NVActivityIndicatorViewable{
    @IBOutlet var recordTableView: UITableView!
    
    let constants = Constants()
    let utils = Utils()
    var recordListData = [ContentRB]()
    var selectedRecord: ContentRB? = nil
    var defoultLogo = UIImage()
    var loadMore = false
    var page = 0
    var pushRecordId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordTableView.refreshControl?.addTarget(self, action: #selector(getAllCars), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(getAllCars), name: Notification.Name(rawValue: "reloadTheTable"), object: nil)

//        defoultLogo = UIImage(contentsOfFile: "logo_v1SmallLogo.png")!
        recordTableView.rowHeight = UITableView.automaticDimension
        recordTableView.tableFooterView = UIView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        getAllCars()
//        if pushRecordId != ""{
//            
//            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//            let booksTableViewController = (storyboard.instantiateViewController(withIdentifier: "singleOrderVC")) as! SingleOrderVC
//            booksTableViewController.pushRecordId = pushRecordId
//            pushRecordId = ""
//            self.navigationController?.pushViewController(booksTableViewController, animated: true)
//            
//            
//        }
    }
    @objc func reloadTableview(){
        recordTableView.reloadData()
    }
    
    @objc func getAllCars(){
        startAnimating()
        let restUrl = constants.startUrl + "karma/v1/record/by-current-user?page=\(page)&size=20"
        guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
            self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            stopAnimating()
            return
        }
//        guard UserDefaults.standard.object(forKey: "BUISNESSID") != nil else{
//
//            self.utils.checkFilds(massage: "Выберите сервис", vc: self.view)
//            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "businessTableViewController")), animated: true)
//            self.sideMenuViewController!.hideMenuViewController()
//            stopAnimating()
//            return
//        }
//        let toDo: [String: Any]  = ["businessCategoryId": UserDefaults.standard.object(forKey: "BUISNESSID")!]
        let headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]
        Alamofire.request(restUrl, method: .get, headers: headers).responseJSON { response  in
            guard response.response?.statusCode != 204 else{
                //                self.recordTableView.
                if self.page == 0 {
                let notOrder = UILabel()
                notOrder.frame = CGRect(x: 0, y: 0, width: 300, height: 40)
                notOrder.center = self.recordTableView.center
                notOrder.textColor = .black
                notOrder.font = .systemFont(ofSize: 50)
                notOrder.text = "Нет заказов"
                self.recordTableView.addSubview(notOrder)
                }
                
                self.stopAnimating()
                return
            }
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
          
            do{
                let carList = try JSONDecoder().decode(RecordsBody.self, from: response.data!)
//                self.recordListData.removeAll()
//                for element in carList{
//                    self.recordListData.append(RecordData.init(carwoshImage: element.business?.logoURL, orderDate: element.begin, carwashName: element.business?.name, orderPrice: element.price, carwoshLatitude: element.business?.latitude, carwashLongitude: element.business?.longitude, orderStatus: element.statusProcess))
//                }
                if self.loadMore == true{
                    self.recordListData = self.recordListData + carList.content!
                }else{
                    self.recordListData = carList.content!
                }
                
            }
            catch{
                print(error)
            }
            
            self.stopAnimating()
           
           
            self.recordTableView.reloadData()
            
        }
    }

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return  recordListData.count
//    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return recordListData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordsCell", for: indexPath) as! OrdersVIewCell

       utils.setBorder(view: cell, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
        let record = recordListData[indexPath.section]
        cell.carwashName.text = record.business?.name
        if record.business?.logoURL != nil{
            cell.carwoshImage.downloaded(from: (record.business?.logoURL)!)
        }else{
        
            cell.carwoshImage.image = UIImage(named: "logo_v1SmallLogo")
        }
        cell.orderDate.text = utils.milisecondsToDate(miliseconds: record.begin!)
        cell.orderPrice.text = "💵" + String(record.price!) + " грн."
        cell.carwoshLatitude.text = String(format:"%f",(record.business?.latitude)!)
        cell.carwashLongitude.text = String(format:"%f",(record.business?.longitude)!)
        switch record.statusProcess {
        case "WAITING":
             cell.orderStatus.text = "В ожидании"
            break
        case "IN_PROCESS":
            cell.orderStatus.text = "В процессе"
            break
        case "COMPLETED":
            cell.orderStatus.text = "Завершен"
            break
        case "CANCELED":
            cell.orderStatus.text = "Отменен"
            break
        default:
            cell.orderStatus.text = ""
            break
        }
       
        return cell
    }
   
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = recordListData.count - 1
        if indexPath.section == lastElement {
            loadMoreItems()
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let record = recordListData[indexPath.section]
        self.selectedRecord = record
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "singleOrderVC") as! SingleOrderVC
        vc.record = selectedRecord
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        
//        utils.checkPushNot(vc: self)
        NotificationCenter.default.removeObserver("reloadTheTable")

        if UserDefaults.standard.object(forKey: "ORDERTABLEVC") == nil{
            
            self.utils.setSaredPref(key: "ORDERTABLEVC", value: "true")
            self.showTutorial()
        }
        
        //                    self.showTutorial()
    }
    
    func showTutorial() {
        let infoDesc = InfoDescriptor(for: "В этом разделе Вы можете видеть все свои заказы")
        var infoTask = PassthroughTask(with: [])
        infoTask.infoDescriptor = infoDesc
        
        
        let cellDesc = LabelDescriptor(for: "Вы можете узнать подробности заказа нажав на него")
        cellDesc.position = .bottom
        let cellHoleDesc = CellViewDescriptor(tableView: self.recordTableView, indexPath: IndexPath(row: 0, section: 0), forOrientation: .any)
        cellHoleDesc.labelDescriptor = cellDesc
        let cellTask = PassthroughTask(with: [cellHoleDesc])
        
        
        PassthroughManager.shared.display(tasks: [infoTask, cellTask]) {
            isUserSkipDemo in
            
            print("isUserSkipDemo: \(isUserSkipDemo)")
        }
    }
    
    func loadMoreItems(){
        self.loadMore = true
        self.page = self.page + 1
        getAllCars()
    }

}
