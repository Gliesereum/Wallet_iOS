//
//  BusinessListVC.swift
//  Coupler_IOS
//
//  Created by macbook on 16/07/2019.
//  Copyright © 2019 Coupler. All rights reserved.
//

import UIKit
import FloatRatingView
import Alamofire
import MaterialComponents

class BusinesListCell: UITableViewCell {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var raiting: FloatRatingView!
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var id: UILabel!
    
    
}
class BusinessListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    
    let constants = Constants()
    let utils = Utils()
    var markerList = CarWashMarker()
    let mapView = MapViewController()
    var refresh = Bool()
    
    @IBOutlet weak var businesTable: UITableView!
    
    @IBOutlet weak var searchText: MDCTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businesTable.tableFooterView = UIView()
        businesTable.invalidateIntrinsicContentSize()
        businesTable.rowHeight = UITableView.automaticDimension
        businesTable.layoutIfNeeded()
        searchText.addDoneCancelToolbar()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func search(_ sender: Any) {
        
            let root = SelectSingleBuisnesVC()
        root.search = true
        guard searchText.text!.count >= 1 else{

            root.checkCarInfo(searchText: nil, completion: { self.refreshTable()})
            //            utils.checkFilds(massage: "Введите название", vc: self.view)
            return
        }
        root.checkCarInfo(searchText: searchText.text, completion: { self.refreshTable()})
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return markerList.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "businesListCell", for: indexPath) as! BusinesListCell
        let marker = markerList[indexPath.section]
        utils.setBorder(view: cell, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
        if let logo = marker.logoURL {
            cell.logo.downloaded(from: logo)
        }
        cell.adress.text = marker.address
        cell.name.text = marker.name
        cell.id.text = marker.id
        cell.raiting.rating = marker.rating!
//        cell.raiting.rating = Double(exactly: (marker.)!)!
        
      
        //        guard utils.filterArray(savedInfos: carInfo!.carAttributes, serverInfos: carServicePrices?.attributes.) != false else {
        //            return cell
        //        }
        //        guard utils.filterArray(savedInfos: carInfo!.carServices, serverInfos: carServicePrices!.carAttributes) != false else {
        //            return cell
        //        }
        
        
        return cell
    }
    
    func refreshTable(){
        if utils.getBusinesList(key: "BUSINESSLIST") != nil {
            
            markerList = utils.getBusinesList(key: "BUSINESSLIST")!
            
           
        } else {
            markerList.removeAll()
        }
        
        self.businesTable.reloadData()
        
        self.businesTable.invalidateIntrinsicContentSize()
//        view.layoutSubviews()
//        do{
//            self.businesTable.reloadData()
//        }catch{
//            print(error)
//        }
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: BusinesListCell = tableView.cellForRow(at: indexPath) as! BusinesListCell
        self.getCarWashInfo(carWashId: cell.id.text!)
        
        
    }
    func getCarWashInfo(carWashId: String){
        showActivityIndicator()
//
        if self.utils.getSharedPref(key: "CARWASHID") != nil{
            
            UserDefaults.standard.removeObject(forKey: "CARWASHID")
        }
        let headers = ["Application-Id" : self.constants.iosId]
        
        let restUrl = self.constants.startUrl + "karma/v1/business/full-model-by-id?id=\(carWashId)"
        Alamofire.request(restUrl, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.hideActivityIndicator()
                return
            }
            
            do{
                
                let responseBody = try JSONDecoder().decode(CarWashBody.self, from: response.data!)
                
//
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "carWashInfo") as! CarWashInfo
                vc.carWashInfo = responseBody
                self.utils.setCarWashBody(key: "CARWASHBODY", value: responseBody)
                
                self.navigationController?.pushViewController(vc, animated: true)
                
                
                self.hideActivityIndicator()
            } catch{
                print(error)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshTable()
//        if utils.getBusinesList(key: "BUSINESSLIST") != nil {
//            markerList = utils.getBusinesList(key: "BUSINESSLIST")!
//        }
//        if UserDefaults.standard.object(forKey: "BUSINESSLISTVC") == nil{
//
//            self.utils.setSaredPref(key: "BUSINESSLISTVC", value: "true")
//            self.showTutorial()
//        }
    }
    func showTutorial() {
        let infoDesc = InfoDescriptor(for: NSLocalizedString("tutor_BLVC_1", comment: ""))
        var infoTask = PassthroughTask(with: [])
        infoTask.infoDescriptor = infoDesc
        
     
        PassthroughManager.shared.display(tasks: [infoTask]) {
            isUserSkipDemo in
            
            print("isUserSkipDemo: \(isUserSkipDemo)")
        }
        
    }

}
