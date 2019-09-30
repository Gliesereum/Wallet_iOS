//
//  PacketsDialog.swift
//  Karma
//
//  Created by macbook on 29/03/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//

import UIKit

protocol DialodDismissDelegate: class {
    func Dismiss(packageDuration: Int, packagePrice: Int, packageId: String, discont: Int, packageName: String)
}
class PacketsDialog: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    var package: Package? = nil
    @IBOutlet weak var serviceTable: UITableView!
    @IBOutlet weak var packageName: UILabel!
    @IBOutlet weak var durationPackage: UILabel!
    @IBOutlet weak var pricePackage: UILabel!
    var price = Int()
    var durtion = Int()
    let utils = Utils()
    var id: String = ""
    var prices = [Int]()
    var delegate: DialodDismissDelegate?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        serviceTable.tableFooterView = UIView()
        serviceTable.layoutIfNeeded()
        serviceTable.invalidateIntrinsicContentSize()
        serviceTable.rowHeight = UITableView.automaticDimension
       
        self.definesPresentationContext = true
        prices.removeAll()
        for price in (package?.services)!{
            prices.append(price.price!)
        }
        pricePackage.text = String(describing:((prices.reduce(0, +) - ((prices.reduce(0, +) * (package?.discount)!) / 100))))
        packageName.text = package?.name
        durationPackage.text = String(describing: (package?.duration)!)
        
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return (package?.services?.count)!
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "customServicesPricePackage", for: indexPath) as! CustomServicesPrice
        self.utils.setBorder(view: cell, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), borderWidth: 1, cornerRadius: 4)
        cell.name.textColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
        let carServicePrices = package?.services?[indexPath.section]
        cell.name.text = carServicePrices?.name
//        cell.price.text = String(describing: carServicePrices?.price ?? 0)
        cell.id.text = carServicePrices?.id
//        cell.time.text = String(describing: carServicePrices?.duration ?? 0)
        return cell
    }
    
    @IBAction func selectPackage(_ sender: Any) {

//
        price = prices.reduce(0, +) - ((prices.reduce(0, +) * (package?.discount)!) / 100)
        durtion = (package?.duration)!

        id = (package?.id)!
        
        delegate!.Dismiss(packageDuration: durtion, packagePrice: price, packageId: id, discont: (package?.discount)!, packageName: (package?.name)!)
        self.dismiss(animated: true, completion: nil)
   
    popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
        
        }
    @IBAction func canselBtn(_ sender: Any) {
        delegate?.Dismiss(packageDuration: 0, packagePrice: 0, packageId: "cancel", discont: 0, packageName: NSLocalizedString("not_chousen", comment: ""))
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}
