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
   
    @IBOutlet weak var menuItem: UIBarButtonItem!
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
        
        PassthroughManager.shared.labelCommonConfigurator = {
            labelDescriptor in
            
            labelDescriptor.label.font = .systemFont(ofSize: 15)
            labelDescriptor.widthControl = .precise(300)
        }
        
        PassthroughManager.shared.infoCommonConfigurator = {
            infoDescriptor in
            
            infoDescriptor.label.font = .systemFont(ofSize: 15)
            infoDescriptor.widthControl = .precise(300)
        }
        
        PassthroughManager.shared.closeButton.setTitle("Skip", for: .normal)
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

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buisnessViewCell", for: indexPath) as! BuisnessViewCell

        let record = buisness[indexPath.section]
        cell.buisnesId.text = record.id!
        cell.buisnessName.text = record.name!
        
        
        utils.setBorder(view: cell, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
        cell.buisnesLogo.downloaded(from: record.imageURL!)

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
        self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "mapViewController")), animated: true)
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
        Alamofire.request(restUrl, method: .get, headers: constants.appID).responseJSON { response  in
            
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            
            do{
                let carList = try JSONDecoder().decode(BuisnessBody.self, from: response.data!)
                self.buisness.removeAll()
                self.buisness = carList
                
            }
            catch{
                print(error)
            }
            
            self.stopAnimating()
            
            
            self.tableBuisness.reloadData()
            if UserDefaults.standard.object(forKey: "BUISNESVC") == nil{
                
                self.utils.setSaredPref(key: "BUISNESVC", value: "true")
                self.showTutorial()
            }
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
       
        getAllBuisness()
    }
    
    func showTutorial() {
        let infoDesc = InfoDescriptor(for: "Добро пожаловать в приложение Coupler. Мы постараемся подробно объяснить функционал приложения в этом помощнике. ")
        var infoTask = PassthroughTask(with: [])
        infoTask.infoDescriptor = infoDesc

        let infoDesc2 = InfoDescriptor(for: "Coupler - сервис поиска услуг. Позволяет найти и заказать любую услугу по выбранным параметрам через интерактивную карту в каком бы городе вы не находились.")
        var infoTask2 = PassthroughTask(with: [])
        infoTask2.infoDescriptor = infoDesc2

        
        let buttonItemView = menuItem.value(forKey: "view") as? UIView
        let leftDesc2 = LabelDescriptor(for: "Кнопка вызова меню")
        leftDesc2.position = .bottom
        let leftHoleDesc2 = HoleViewDescriptor(view: buttonItemView!, type: .circle)
        leftHoleDesc2.labelDescriptor = leftDesc2
        let rightLeftTask2 = PassthroughTask(with: [leftHoleDesc2])
//        let rotationTask = createDemoTextPositionBottomTopTask()

//        let rightDesc = LabelDescriptor(for: "From right")
//        rightDesc.position = .right
//        rightDesc.label.textColor = .magenta
//        let rightHoleDesc = HoleViewDescriptor(view: leftView, type: .circle)
//        rightHoleDesc.labelDescriptor = rightDesc
//
//        let leftDesc = LabelDescriptor(for: "From left")
//        leftDesc.position = .left
//        leftDesc.label.textColor = .green
//        let leftHoleDesc = HoleViewDescriptor(view: rightView, type: .circle)
//        leftHoleDesc.labelDescriptor = leftDesc
//        let rightLeftTask = PassthroughTask(with: [leftHoleDesc, rightHoleDesc])
//
//        let handleTask = createDemoHandlersOfTask()

        let cellDesc = LabelDescriptor(for: "Вы можете выбрать один интересующий вас сервис из данного списка")
        cellDesc.position = .bottom
        let cellHoleDesc = CellViewDescriptor(tableView: self.tableBuisness, indexPath: IndexPath(row: 0, section: 0), forOrientation: .any)
        cellHoleDesc.labelDescriptor = cellDesc
        var cellTask = PassthroughTask(with: [cellHoleDesc])

        cellTask.didFinishTask = {
            guard let tabBarController = self.parent as? UITabBarController else { return }

            tabBarController.selectedIndex = 1
        }
//
//        let infoDesc3 = InfoDescriptor(for: "Thank you for attention")
//        infoDesc3.offset = CGPoint(x: 0, y: -100)
//        var infoTask3 = PassthroughTask(with: [])
//        infoTask3.infoDescriptor = infoDesc3

        PassthroughManager.shared.display(tasks: [infoTask, infoTask2, cellTask, rightLeftTask2]) {
            isUserSkipDemo in

            print("isUserSkipDemo: \(isUserSkipDemo)")
        }

    }
//    func createDemoTextPositionBottomTopTask() -> PassthroughTask {
//        let labelDesc = LabelDescriptor(for: "The text can be from bottom and center in a portrait orientation. Try to rotate.")
//        labelDesc.position = .bottom
//        let holeDesc = HoleViewDescriptor(view: self.view, paddingX: 10, paddingY: 10, type: .rect(cornerRadius: 5, margin: 0), forOrientation: .portrait)
//        holeDesc.labelDescriptor = labelDesc
//
//        let labelDesc2 = LabelDescriptor(for: "The text can be from top and left in a portrait orientation")
//        labelDesc2.position = .top
//        labelDesc2.aligment = .left
//        let holeDesc2 = HoleViewDescriptor(view: self.view, type: .rect(cornerRadius: 5, margin: 10), forOrientation: .landscape)
//        holeDesc2.labelDescriptor = labelDesc2
//
//        return PassthroughTask(with: [holeDesc, holeDesc2])
//    }
//
//    func createDemoHandlersOfTask() -> PassthroughTask {
//        let labelDesc = LabelDescriptor(for: "Handlers for turns and end of task are also available")
//        labelDesc.position = .bottom
//        let holeDesc = HoleViewDescriptor(view: self.view, type: .rect(cornerRadius: 5, margin: 10), forOrientation: .portrait)
//        holeDesc.labelDescriptor = labelDesc
//
//        let labelDesc2 = LabelDescriptor(for: "Handlers for turns and end of task are also available")
//        labelDesc2.position = .top
//        labelDesc2.aligment = .left
//        let holeDesc2 = HoleViewDescriptor(view: self.view, type: .rect(cornerRadius: 5, margin: 10), forOrientation: .landscape)
//        holeDesc2.labelDescriptor = labelDesc2
//
//        var task = PassthroughTask(with: [holeDesc, holeDesc2])
//
//        task.orientationDidChange = {
//            [unowned self] in
////            self.startButton.backgroundColor = arc4random_uniform(100) % 2 == 0 ? .red : .green
//        }
//
//        task.didFinishTask = {
//            [unowned self] in
////            self.startButton.backgroundColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
//        }
//
//        return task
//    }
    

    
}
