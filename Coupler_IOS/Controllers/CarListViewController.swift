//
//   CarListAct.swift
//  Karma
//
//  Created by macbook on 07/12/2018.
//  Copyright © 2018 Gliesereum. All rights reserved.
//

import UIKit
import Alamofire
import PagedHorizontalView
import MaterialComponents

struct CellCarList {
    let carBrand: String?
    let carNumber: String?
    let carModel: String?
    let carId: String?
    let carAttributes: [String?]
    let carServices: [String?]
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


class CarListViewController1: UIViewController, NVActivityIndicatorViewable{
    var carImage: String?
    var carIdLable : String?
    var carInfoLable : String?
    @IBOutlet weak var pageHorizontalView: PagedHorizontalView!
    var carListData = [CellCarList]()
    let constants = Constants()
    var selectedCar: CellCarList?
    let utils = Utils()
    var idCar = String()
    var carIndex = Int()
    var loadCar = [String : CellCarList]()
    @IBOutlet weak var addCarItem: UIBarButtonItem!
    @IBOutlet weak var delateButton: MDCButton!
    @IBOutlet weak var selectCarButton: UIButton!
    @IBOutlet weak var pageControl: CustomPageControl!
    let scale: CGFloat = 1.5
//    let mapViewController = MapViewController()
    
    @IBOutlet weak var carId: UILabel!
    @IBOutlet weak var carInfo: UILabel!
    override func viewDidLoad() {
      
        super.viewDidLoad()
        
        pageControl.transform = CGAffineTransform.init(scaleX: scale, y: scale)
        for dot in pageControl.subviews{
            dot.transform = CGAffineTransform.init(scaleX: 1/scale, y: 1/scale)
        }
//        getAllCars()
        
    }
    func getAllCars(){
        startAnimating()
        let restUrl = constants.startUrl + "karma/v1/car/user"
        guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
            self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            stopAnimating()
            return
        }
        let headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!]
        Alamofire.request(restUrl, method: .get, headers: headers).responseJSON { response  in
            guard response.response?.statusCode != 204 else{
                self.stopAnimating()
                self.openAddCarViewController()
                return
            }
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
          
            
            do{
                let carList = try JSONDecoder().decode(AllCarList.self, from: response.data!)
                
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
                    self.carListData.append(CellCarList.init(carBrand: element.brand?.name, carNumber: element.registrationNumber!, carModel: element.model?.name, carId: element.id!, carAttributes: carAttributes, carServices: servicesClasses))
                }
                self.pageHorizontalView.collectionView.reloadData()
                self.pageHorizontalView.pageControl?.numberOfPages = carList.count
            }
            catch{
                
            }
            self.stopAnimating()
            
            
        }
    }
    @objc func deleteCar(){
        startAnimating()
            let restUrl = constants.startUrl + "karma/v1/car/\(self.idCar)"
            guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
                self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
                self.sideMenuViewController!.hideMenuViewController()
                stopAnimating()
                return
            }
            let headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!]
            Alamofire.request(restUrl, method: .delete, headers: headers).responseJSON { response  in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling POST on /todos/1")
                    print(response.result.error!)
                    return
                }
                // make sure we got some JSON since that's what we expect
                guard response.result.value != nil else{
                    
                    return
                }
                self.getAllCars()
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
}
extension CarListViewController1 : UICollectionViewDataSource {
    
    @objc func selectCar() {
        let index = self.pageHorizontalView.collectionView.indexPathsForVisibleItems
            selectedCar = carListData[(index.first?.row)!]
//        selectedCar = loadCar[]
        let carInfo = SelectedCarInfo.init(carId: (selectedCar?.carId)!, carInfo: (selectedCar?.carBrand)! + " " + (selectedCar?.carModel)!, carAttributes: (selectedCar?.carAttributes)!, carServices: selectedCar!.carServices)
        setFavoriteCar(carId: (selectedCar?.carId)!)
        utils.setCarInfo(key: "CARID", value: carInfo)
        self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "mapViewController")), animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }

   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carListData.count
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return false
    }
   
    
    func updateNextSet(){
        print("On Completetion")
        //requests another set of data (20 more items) from the server.
        DispatchQueue.main.async(execute: self.pageHorizontalView.collectionView.reloadData)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        let item = carListData[indexPath.item]
//        cell.imageView.image = UIImage(named: item.image)
        
//        loadCar.updateValue(item, forKey: item.carId!)
        utils.setBorder(view: cell.imageView, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), borderWidth: 1, cornerRadius: 4)
//        cell.imageView.image = utils.getImageFromSVG(name: "MustCarCardVector")
        cell.label.text = item.carBrand! + " " + item.carModel! + " " + item.carNumber!
        cell.carId.text = item.carId
        self.idCar = item.carId!
        carImage = "MustCarCardVector"
        carIdLable = item.carId!
        self.carIndex = (indexPath as NSIndexPath).item
        carInfoLable = item.carBrand! + " " + item.carModel! + " " + item.carNumber!
//        cell.addCarButton.addTarget(self, action: #selector(openAddCarViewController), for: .touchUpInside)
        cell.removeCarButton.addTarget(self, action: #selector(deleteCar), for: .touchUpInside)
        cell.selectCar.addTarget(self, action: #selector(selectCar), for: .touchUpInside)
        return cell
    }
    
    func setFavoriteCar(carId: String) {
        
        let restUrl = constants.startUrl + "karma/v1/car/set-favorite/" + carId
        Alamofire.request(restUrl, method: .post, encoding: JSONEncoding.default, headers: ["Authorization": (self.utils.getSharedPref(key: "accessToken"))!]).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            
            self.stopAnimating()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAllCars()
        
//        utils.checkPushNot(vc: self)
        guard utils.getSharedPref(key: "accessToken") != nil else{
            self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
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
        
//                    self.showTutorial()
    }
    
    func showTutorial() {
        let infoDesc = InfoDescriptor(for: "Тут будут показаны ваши машины, если вы их внесете в приложение")
        var infoTask = PassthroughTask(with: [])
        infoTask.infoDescriptor = infoDesc
       
        
        let leftDesc = LabelDescriptor(for: "Чтобы удалить машину нажмите сюда")
        leftDesc.position = .bottom
        let leftHoleDesc = HoleViewDescriptor(view: delateButton, type: .rect(cornerRadius: 5, margin: 10))
        leftHoleDesc.labelDescriptor = leftDesc
        let rightLeftTask = PassthroughTask(with: [leftHoleDesc])
        
        
        let leftDesc1 = LabelDescriptor(for: "Чтобы выбрать машину нажмите сюда")
        leftDesc1.position = .bottom
        let leftHoleDesc1 = HoleViewDescriptor(view: selectCarButton, type: .rect(cornerRadius: 5, margin: 10))
        leftHoleDesc1.labelDescriptor = leftDesc1
        let rightLeftTask1 = PassthroughTask(with: [leftHoleDesc1])
        
        let buttonItemView = addCarItem.value(forKey: "view") as? UIView
        let leftDesc2 = LabelDescriptor(for: "Чтобы добавить машину нажмите сюда")
        leftDesc2.position = .left
        let leftHoleDesc2 = HoleViewDescriptor(view: buttonItemView!, type: .circle)
        leftHoleDesc2.labelDescriptor = leftDesc2
        let rightLeftTask2 = PassthroughTask(with: [leftHoleDesc2])
        
      
        
        PassthroughManager.shared.display(tasks: [infoTask, rightLeftTask, rightLeftTask1, rightLeftTask2]) {
            isUserSkipDemo in
            
            print("isUserSkipDemo: \(isUserSkipDemo)")
        }
    }
        
    
        
    
}

