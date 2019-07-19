//
//  PacketsDialog.swift
//  Karma
//
//  Created by macbook on 29/03/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//

import UIKit
import Alamofire

protocol FilterDialodDismissDelegate: class {
    func Dismiss(filterListId: [String], filterOn: Bool)
}
class FilterDialog: UIViewController, UITableViewDataSource, UITableViewDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var remuveChouse: UIButton!
    @IBOutlet weak var filterTable: UITableView!
    @IBOutlet weak var filterName: UILabel!
    @IBOutlet weak var filterId: UILabel!
    var filterListId = [String?]()
    
    var filterListIdOld = [String?]()
    var filterList = FilterMarkerBody()
    var index = [IndexPath]()
    
    var delegate: FilterDialodDismissDelegate?
    
   
    let constants = Constants()
    let utils = Utils()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFilterBody()
        filterTable.tableFooterView = UIView()
        filterTable.rowHeight = UITableView.automaticDimension
        self.definesPresentationContext = true
        
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return filterList.count
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.isSelected{
            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
        } else {
            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as! FilterCell
        let filterService = filterList[indexPath.section]
        utils.setBorder(view: cell, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.0417380137), borderWidth: 1, cornerRadius: 4)
        cell.serviceName.text = filterService.name!
        cell.serviceId.text = filterService.id!
        for id in filterListIdOld{
            if id == filterService.id!{
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                filterListId.append(cell.serviceId.text!)
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let cell: FilterCell = tableView.cellForRow(at: indexPath) as! FilterCell
        UIView.animate(withDuration: 0.4, delay: 0.0, options:[.transitionCurlDown], animations: {
            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
            
        }, completion:nil)
        filterListId.append(cell.serviceId.text!)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell: FilterCell = tableView.cellForRow(at: indexPath) as! FilterCell
        UIView.animate(withDuration: 0.4, delay: 0.0, options:[.transitionCurlDown], animations: {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.9882352941, blue: 0.9882352941, alpha: 1)
            
        }, completion:nil)
        filterListId.removeAll(where: { $0 == cell.serviceId.text! })
    }
    
  
    @IBAction func canselBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ramuveChouses(_ sender: Any) {
        delegate?.Dismiss(filterListId: filterListId as! [String], filterOn: false)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func addFilters(_ sender: Any) {
        guard filterListId.count != 0 else {
            self.utils.checkFilds(massage: "Выберите фильтр", vc: self.view)
            return
        }
        delegate?.Dismiss(filterListId: filterListId as! [String], filterOn: true)
        dismiss(animated: true, completion: nil)
    }
    func getFilterBody(){
        startAnimating()
        let restUrl = constants.startUrl + "karma/v1/service/by-business-category"
       
        let toDo: [String: Any]  = ["businessCategoryId": UserDefaults.standard.object(forKey: "BUISNESSID")!]
        
        Alamofire.request(restUrl, method: .get, parameters: toDo, headers: self.constants.appID).responseJSON { response  in
            
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            
            
            do{
                let carList = try JSONDecoder().decode(FilterMarkerBody.self, from: response.data!)
                
                self.filterList = carList
                
                self.filterTable.reloadData()
                self.stopAnimating()
//                self.selectedFilter()
                
            }
            catch{
                
                self.stopAnimating()
            }
            
            
        }
        
    }
    func selectedFilter(){
        do{
            for id in self.index{
                self.filterTable.selectRow(at: id, animated: true, scrollPosition: UITableView.ScrollPosition.middle)
            }
            self.filterListIdOld.removeAll()
        }catch{
            print(error)
        }
    }
    
}
