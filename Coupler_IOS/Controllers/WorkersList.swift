//
//  WorkersList.swift
//  Coupler_IOS
//
//  Created by macbook on 11/08/2019.
//  Copyright © 2019 Coupler. All rights reserved.
//

import UIKit

protocol WorkersListDelegate: class {
    func DismissWorker(worker: Worker)
}
class WorkersList: UIViewController, UITableViewDataSource, UITableViewDelegate, NVActivityIndicatorViewable {

    @IBOutlet weak var workersTable: UITableView!
    
    var workers : [Worker]?
    var businesId : String?
    let utils = Utils()
    var timeZone = Int()
    let constants = Constants()
    
    var delegate: WorkersListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    workersTable.rowHeight = UITableView.automaticDimension
        
        workersTable.tableFooterView = UIView()
        workersTable.layoutIfNeeded()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return (workers?.count)!
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "workersListCell", for: indexPath) as! WorkersListCell
        let workerForIndex = workers![indexPath.section]
        
        utils.setBorder(view: cell, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
        cell.clipsToBounds = true
     
//        if workerForIndex.user?.firstName
        cell.workerName.text = (workerForIndex.user?.firstName)! + " " + (workerForIndex.user?.lastName)!
        cell.workerId.text = workerForIndex.id
        cell.workerPosition.text = workerForIndex.position
        if workerForIndex.comments != nil{
             cell.workerCommentsCount.text = "(\(( workerForIndex.comments?.count)!))"
        } else {
             cell.workerCommentsCount.text = "(0)"
        }
       
        cell.workerRating.rating = (workerForIndex.rating?.rating)!
        if let workerAvatar = workerForIndex.user?.avatarURL{
            cell.workerImage.downloaded(from: workerAvatar)
        }
        cell.workerButton.tag = indexPath.section
        cell.workerButton.addTarget(self, action: #selector(dialogDissmis(workerIndex:)), for: .touchUpInside)
        return cell
    }
    @objc func dialogDissmis(workerIndex: UIButton) {
        let worker = workers![workerIndex.tag]
        delegate?.DismissWorker(worker: worker)
//        self.navigationController!.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: WorkersListCell = tableView.cellForRow(at: indexPath) as! WorkersListCell

        let workerForIndex = workers![cell.workerButton.tag]
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "singleWorker") as! SingleWorker
        customAlert.worker = workerForIndex
        customAlert.timeZone = timeZone
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.popover
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//        customAlert.delegate = self
        self.present(customAlert, animated: true, completion: nil)
//        let vc = storyboard?.instantiateViewController(withIdentifier: "singleWorker") as! SingleWorker
//        vc.worker = workerForIndex
////        self.present(vc, animated: true, completion: nil)
//        navigationController?.pushViewController(vc, animated: true)
        
    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        <#code#>
//    }

}
