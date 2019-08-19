//
//   CarListAct.swift
//  Karma
//
//  Created by macbook on 07/12/2018.
//  Copyright © 2018 Gliesereum. All rights reserved.
//

import UIKit
import Alamofire
import MaterialComponents



struct CellCarList {
    let carBrand: String?
    let carNumber: String?
    let carModel: String?
    let carId: String?
    let carAttributes: [String?]
    let carServices: [String?]
    let favorite: Bool?
    //    let logo: String?
}
class SelectedCarInfo: NSObject, NSCoding {
    let carInfo: String?
    let carAttributes: [String?]
    let carServices: [String?]
    let carId: String?
    
    init(carId: String, carInfo: String, carAttributes: [String?], carServices: [String?]) {
        self.carId = carId
        self.carInfo = carInfo
        self.carAttributes = carAttributes
        self.carServices = carServices
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let carId = aDecoder.decodeObject(forKey: "carId") as! String
        let carInfo = aDecoder.decodeObject(forKey: "carInfo") as! String
        let carServices = aDecoder.decodeObject(forKey: "carServices") as! [String]
        let carAttributes = aDecoder.decodeObject(forKey: "carAttributes") as! [String]
        self.init(carId: carId, carInfo: carInfo, carAttributes: carAttributes, carServices: carServices)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(carId, forKey: "carId")
        aCoder.encode(carInfo, forKey: "carInfo")
        aCoder.encode(carAttributes, forKey: "carAttributes")
        aCoder.encode(carServices, forKey: "carServices")
    }
}


class CarListViewController: UIViewController, NVActivityIndicatorViewable, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate{
   
    
    
    var carImage: String?
    var carIdLable : String?
    var carInfoLable : String?
//    @IBOutlet weak var pageHorizontalView: PagedHorizontalView!
    var carListData = [CellCarList]()
    let constants = Constants()
    var selectedCar: CellCarList?
    let utils = Utils()
    var idCar = String()
    var carIndex = Int()
    var poper = Bool()
    var delegate : CreateCarDissmisDelegete?
    var vc = UIViewController()
    var allCars = AllCarList()
    var loadCar = [String : CellCarList]()
    @IBOutlet weak var addCarView: UIView!
    @IBOutlet weak var carListTable: UITableView!
    @IBOutlet weak var addCarItem: UIBarButtonItem!
//    @IBOutlet weak var delateButton: MDCButton!
//    @IBOutlet weak var selectCarButton: UIButton!
//    @IBOutlet weak var pageControl: CustomPageControl!
    let scale: CGFloat = 1.5
    //    let mapViewController = MapViewController()

//    @IBOutlet weak var carId: UILabel!
//    @IBOutlet weak var carInfo: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        carListTable.tableFooterView = UIView()
        carListTable.layoutIfNeeded()
        carListTable.invalidateIntrinsicContentSize()
        carListTable.rowHeight = UITableView.automaticDimension
//        pageControl.transform = CGAffineTransform.init(scaleX: scale, y: scale)
//        for dot in pageControl.subviews{
//            dot.transform = CGAffineTransform.init(scaleX: 1/scale, y: 1/scale)
//        }
        //        getAllCars()
       
        var yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
        yourViewBorder.lineDashPattern = [8, 3]
        yourViewBorder.frame = addCarView.bounds
        yourViewBorder.fillColor = nil
//        yourViewBorder.cornerRadius = 8
        yourViewBorder.path = UIBezierPath(roundedRect: addCarView.bounds, cornerRadius: 8).cgPath
        addCarView.layer.addSublayer(yourViewBorder)
        let swImage = UITapGestureRecognizer(target: self, action: #selector(addCar(_:)))
        
        swImage.delegate = self
        swImage.numberOfTapsRequired = 1
        addCarView.addGestureRecognizer(swImage)
    }
    func goToCreate(){
        self.poper = false
        self.dismiss(animated: true, completion: nil)
        self.delegate?.CreateCarDismiss()
        
    }
    func getAllCars(){
        startAnimating()
        let restUrl = constants.startUrl + "karma/v1/car/user"
        guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
            
            self.utils.checkAutorization(vc: self)
            stopAnimating()
            return
        }
        let headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]
        Alamofire.request(restUrl, method: .get, headers: headers).responseJSON { response  in
            guard response.response?.statusCode != 204 else{
                guard self.poper != true else{
                    self.goToCreate()
                    return
                }
                //                self.recordTableView.
                let notOrder = UILabel()
                notOrder.frame = CGRect(x: 0, y: 0, width: 300, height: 40)
                notOrder.center = self.carListTable.center
                notOrder.textColor = .black
                notOrder.font = .systemFont(ofSize: 50)
                notOrder.text = "Нет авто"
                self.carListTable.addSubview(notOrder)
                self.stopAnimating()
                return
            }
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            
            
            do{
                let carList = try JSONDecoder().decode(AllCarList.self, from: response.data!)
               
                self.allCars = carList
                self.carListData.removeAll()
                for element in carList{
                    var carAttributes = [String]()
                    for attribute in element.attributes!{
                        carAttributes.append(attribute.id!)
                    }
                    var servicesClasses = [String]()
                    for servicesClass in element.services! {
                        servicesClasses.append(servicesClass.id!)
                    }
                    self.carListData.append(CellCarList.init(carBrand: element.brand?.name, carNumber: element.registrationNumber!, carModel: element.model?.name, carId: element.id!, carAttributes: carAttributes, carServices: servicesClasses, favorite: element.favorite))
                }
//                self.pageHorizontalView.collectionView.reloadData()
//                self.pageHorizontalView.pageControl?.numberOfPages = carList.count
               
                self.carListTable.reloadData()
            }
            catch{
                
            }
            self.stopAnimating()
            
            
        }
    }
    @IBAction func addCar(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "createCar") as! CreateCar
        vc.openVC = "open"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openAddCarViewController() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "createCar") as! CreateCar
        self.navigationController?.pushViewController(vc, animated: true)
        //        self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "carViewController")), animated: true)
        //        self.sideMenuViewController!.hideMenuViewController()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
//}
//extension CarListViewController1 : UICollectionViewDataSource {
    
    @objc func selectCar(sender: UIButton) {
//        let index = self.pageHorizontalView.collectionView.indexPathsForVisibleItems

        let index = sender.tag
        selectedCar = carListData[index]
        //        selectedCar = loadCar[]
        let carInfo = SelectedCarInfo.init(carId: (selectedCar?.carId)!, carInfo: (selectedCar?.carBrand)! + " " + (selectedCar?.carModel)!, carAttributes: (selectedCar?.carAttributes)!, carServices: selectedCar!.carServices)
        setFavoriteCar(carId: (selectedCar?.carId)!)
        utils.setCarInfo(key: "CARID", value: carInfo)
        guard self.poper != true else{
            self.poper = false
            self.dismiss(animated: true, completion: nil)
            return
        }
        self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "selectSingleBuisnesVC")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
    @objc func infoCar(sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "createCar") as! CreateCar
        let index = sender.tag
        vc.selectedCar = allCars[index]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return carListData.count
//    }
//    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
//        return false
//    }
//
//
//    func updateNextSet(){
//        print("On Completetion")
//        //requests another set of data (20 more items) from the server.
//        DispatchQueue.main.async(execute: self.pageHorizontalView.collectionView.reloadData)
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return carListData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cells = cell as! CarLisrCell
        utils.setBorder(view: cells, backgroundColor: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 0.07973030822), borderColor: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 0.07973030822), borderWidth: 2, cornerRadius: 8)
        let item = carListData[indexPath.section]
        utils.setBorder(view: cells.informationBtn, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderWidth: 2, cornerRadius: 4)
        if item.favorite == true{
            utils.setBorder(view: cells.selectBtn, backgroundColor: #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), borderColor: #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), borderWidth: 2, cornerRadius: 4)
            cells.selectBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            cells.carImage.image = UIImage(named: "selectAuto")
            cells.selectedLable.isHidden = false
            cells.favoriteImage.isHidden = false
        }else{
            utils.setBorder(view: cells.selectBtn, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderWidth: 2, cornerRadius: 4)
            cells.carImage.image = UIImage(named: "defoultAuto")
            cells.selectBtn.setTitleColor(#colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), for: .normal)
            cells.selectedLable.isHidden = true
            cells.favoriteImage.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "carLisrCell", for: indexPath) as! CarLisrCell
        let item = carListData[indexPath.section]
        //        cell.imageView.image = UIImage(named: item.image)
//        cell.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 0.1492936644)
        //        loadCar.updateValue(item, forKey: item.carId!)
        utils.setBorder(view: cell, backgroundColor: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 0.07973030822), borderColor: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 0.07973030822), borderWidth: 2, cornerRadius: 8)
        utils.setBorder(view: cell.informationBtn, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderWidth: 2, cornerRadius: 4)
        if item.favorite == true{
            utils.setBorder(view: cell.selectBtn, backgroundColor: #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), borderColor: #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), borderWidth: 2, cornerRadius: 4)
            cell.selectBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            cell.selectedLable.isHidden = false
            cell.favoriteImage.isHidden = false
            cell.carImage.image = UIImage(named: "selectAuto")
        }else{
         utils.setBorder(view: cell.selectBtn, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderWidth: 2, cornerRadius: 4)
            
            cell.selectBtn.setTitleColor(#colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), for: .normal)
            cell.selectedLable.isHidden = true
            cell.favoriteImage.isHidden = true
            cell.carImage.image = UIImage(named: "defoultAuto")
        }
        //        cell.imageView.image = utils.getImageFromSVG(name: "MustCarCardVector")
        cell.carInfoLable.text = item.carBrand! + " " + item.carModel! + " " + item.carNumber!
        cell.carId.text = item.carId
        cell.selectBtn.tag = indexPath.section
        cell.informationBtn.tag = indexPath.section
       
//        self.idCar = item.carId!
//        carImage = "MustCarCardVector"
//        carIdLable = item.carId!
//        self.carIndex = (indexPath as NSIndexPath).item
//        carInfoLable = item.carBrand! + " " + item.carModel! + " " + item.carNumber!
        //        cell.addCarButton.addTarget(self, action: #selector(openAddCarViewController), for: .touchUpInside)
//        cell.removeCarButton.addTarget(self, action: #selector(deleteCar), for: .touchUpInside)
        cell.selectBtn.addTarget(self, action: #selector(selectCar(sender:)), for: .touchUpInside)
        cell.informationBtn.addTarget(self, action: #selector(infoCar(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        carIndex = indexPath.row
        return indexPath
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
        
    }
    
    func setFavoriteCar(carId: String) {
        
        let restUrl = constants.startUrl + "karma/v1/car/set-favorite/" + carId
        Alamofire.request(restUrl, method: .post, encoding: JSONEncoding.default, headers: ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            
            self.stopAnimating()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllCars()
        
        //        utils.checkPushNot(vc: self)
        guard utils.getSharedPref(key: "accessToken") != nil else{
//            self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
//            self.sideMenuViewController!.hideMenuViewController()
            
            self.utils.checkAutorization(vc: self)
            
            self.utils.checkFilds(massage: "Авторизируйтесь", vc: self.view)
            stopAnimating()
            return
        }
        //        guard utils.getCarInfo(key: "CARID") != nil else{
        //            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "сarListViewController")), animated: true)
        //            self.sideMenuViewController!.hideMenuViewController()
        //
        //            self.utils.checkFilds(massage: "Выберите машину", vc: self.view)
        //            stopAnimating()
        //            return
        //        }
        if UserDefaults.standard.object(forKey: "CARLISTVC") == nil{
            
            self.utils.setSaredPref(key: "CARLISTVC", value: "true")
            self.showTutorial()
        }
        
    }
    
    func showTutorial() {
        let infoDesc = InfoDescriptor(for: "Тут будут показаны ваши машины, если вы их внесете в приложение")
        var infoTask = PassthroughTask(with: [])
        infoTask.infoDescriptor = infoDesc
        
        
//        let leftDesc = LabelDescriptor(for: "Чтобы удалить машину нажмите сюда")
//        leftDesc.position = .bottom
//        let leftHoleDesc = HoleViewDescriptor(view: delateButton, type: .rect(cornerRadius: 5, margin: 10))
//        leftHoleDesc.labelDescriptor = leftDesc
//        let rightLeftTask = PassthroughTask(with: [leftHoleDesc])
        
        
//        let leftDesc1 = LabelDescriptor(for: "Чтобы выбрать машину нажмите сюда")
//        leftDesc1.position = .bottom
//        let leftHoleDesc1 = HoleViewDescriptor(view: selectCarButton, type: .rect(cornerRadius: 5, margin: 10))
//        leftHoleDesc1.labelDescriptor = leftDesc1
//        let rightLeftTask1 = PassthroughTask(with: [leftHoleDesc1])
//
//        let buttonItemView = addCarItem.value(forKey: "view") as? UIView
//        let leftDesc2 = LabelDescriptor(for: "Чтобы добавить машину нажмите сюда")
//        leftDesc2.position = .left
//        let leftHoleDesc2 = HoleViewDescriptor(view: buttonItemView!, type: .circle)
//        leftHoleDesc2.labelDescriptor = leftDesc2
//        let rightLeftTask2 = PassthroughTask(with: [leftHoleDesc2])
        
        
        let cellDesc = LabelDescriptor(for: "Тут Вы можите просмотреть информацию, или выбрать автомобиль")
        cellDesc.position = .bottom
        let cellHoleDesc = CellViewDescriptor(tableView: self.carListTable, indexPath: IndexPath(row: 0, section: 0), forOrientation: .any)
        cellHoleDesc.labelDescriptor = cellDesc
        var cellTask = PassthroughTask(with: [cellHoleDesc])
        
        cellTask.didFinishTask = {
            guard let tabBarController = self.parent as? UITabBarController else { return }
            
            tabBarController.selectedIndex = 1
        }
        
        
        
        PassthroughManager.shared.display(tasks: [infoTask, cellTask]) {
            isUserSkipDemo in
            
            print("isUserSkipDemo: \(isUserSkipDemo)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
}

