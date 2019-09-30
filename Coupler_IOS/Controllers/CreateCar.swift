//
//  CreateCar.swift
//  Karma
//
//  Created by macbook on 26/04/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//

import UIKit
import Alamofire
import MaterialComponents

class ClassServicCell: UITableViewCell{
    @IBOutlet weak var servicesName: UILabel!
    @IBOutlet weak var servicesId: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
}


class CreateCar: UIViewController, UITextFieldDelegate, CreateCarDialogDismissDelegate, UITableViewDelegate, UITableViewDataSource{
   
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var brandsTextView: UITextField!
    @IBOutlet weak var modelTextView: UITextField!
    @IBOutlet weak var yearTextView: UITextField!
    @IBOutlet weak var interiorTextView: UITextField!
    @IBOutlet weak var carBodyTextVIew: UITextField!
    @IBOutlet weak var carColorTextView: UITextField!
    @IBOutlet weak var regNumberTextView: UITextField!
    @IBOutlet weak var otherTextView: UITextField!
//    @IBOutlet weak var selectedClassServices: UITextField!
    @IBOutlet weak var whellRadius: UITextField!
    @IBOutlet weak var addCarBrnView: MDCButton!
    @IBOutlet weak var classServicesTable: UITableView!
    @IBOutlet weak var deleteCarImage: UIButton!
    @IBOutlet weak var exitBtn: UIButton!
    
    var setFavorite : CarListViewController?
    let constants = Constants()
    let utils = Utils()
    var classServices = [CarClassService]()
    var currentTextField = UITextField()
    var selectedCar: AllCarListElement?
    var picker = UIPickerView()
    var arrayItems: [String] = []
    var arrayId: [String] = []
    var poper = Bool()
    var delegate : OrderPopDismissDelegate?
    var arrayClassServices: [String] = []
    var arrayClassServicesId: [String] = []
    var arrayInterior: [String] = []
    var arrayCarBodie: [String] = []
    var arrayRadius: [String] = []
    var arrayCarColor: [String] = []
    var arrayInteriors: [String : String] = [:]
    var arrayRadiusWheel: [String : String] = [:]
    var arrayCarBodies: [String : String] = [:]
    var arrayCarColors: [String : String] = [:]
    var brandsId, modelId, yearsId, interiorId, carBodyId, carColorId, carServiceId, whellRadiusId: String?
    var openVC: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        getCarBrands()
        getFilters()
        getClassServices()
        
        classServicesTable.tableFooterView = UIView()
        classServicesTable.rowHeight = UITableView.automaticDimension
        self.definesPresentationContext = true
        regNumberTextView.addDoneCancelToolbar()
        otherTextView.addDoneCancelToolbar()
        if selectedCar != nil{
            deleteCarImage.isHidden = false
            deleteCarImage.isEnabled = true
            brandsTextView.isEnabled = false
            addCarBrnView.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
            brandsTextView.text = selectedCar?.brand?.name
            brandsId = selectedCar?.brandID
            modelTextView.isEnabled = false
            modelTextView.text = selectedCar?.model?.name
            modelId = selectedCar?.modelID
            yearTextView.isEnabled = false
            yearTextView.text = "\((selectedCar?.year?.name)!)"
            yearsId = selectedCar?.yearID
            for atribut in (selectedCar?.attributes)!{
                let langStr = Locale.current.languageCode
                switch langStr {
                case "en":
                    if atribut.filterID == "0ef64c98-767b-42ba-a9de-171c6d455fff" {
                        
                        interiorTextView.isEnabled = true
                        interiorTextView.text = atribut.descriptions?.en?.title
                        interiorId = atribut.id
                    }
                    if atribut.filterID == "b8d3f705-6277-44cb-a5b1-0ded8e19e691" {
                        
                        carColorTextView.isEnabled = true
                        carColorTextView.text = atribut.descriptions?.en?.title
                        carColorId = atribut.id
                    }
                    if atribut.filterID == "b62b2fef-17cc-4a9b-b076-9055b26137c4" {
                        
                        carBodyTextVIew.isEnabled = true
                        carBodyTextVIew.text = atribut.descriptions?.en?.title
                        carBodyId = atribut.id
                    }
                    if atribut.filterID == "ad2d57da-b0a1-4cc8-a6be-4786589df53c" {
                        whellRadius.isEnabled = true
                        whellRadius.text = atribut.title
                        whellRadiusId = atribut.id
                    }
                case "ru":
                    if atribut.filterID == "0ef64c98-767b-42ba-a9de-171c6d455fff" {
                        
                        interiorTextView.isEnabled = true
                        interiorTextView.text = atribut.descriptions?.ru?.title
                        interiorId = atribut.id
                    }
                    if atribut.filterID == "b8d3f705-6277-44cb-a5b1-0ded8e19e691" {
                        
                        carColorTextView.isEnabled = true
                        carColorTextView.text = atribut.descriptions?.ru?.title
                        carColorId = atribut.id
                    }
                    if atribut.filterID == "b62b2fef-17cc-4a9b-b076-9055b26137c4" {
                        
                        carBodyTextVIew.isEnabled = true
                        carBodyTextVIew.text = atribut.descriptions?.ru?.title
                        carBodyId = atribut.id
                    }
                    if atribut.filterID == "ad2d57da-b0a1-4cc8-a6be-4786589df53c" {
                        whellRadius.isEnabled = true
                        whellRadius.text = atribut.title
                        whellRadiusId = atribut.id
                    }
                case "uk":
                    if atribut.filterID == "0ef64c98-767b-42ba-a9de-171c6d455fff" {
                        
                        interiorTextView.isEnabled = true
                        interiorTextView.text = atribut.descriptions?.uk?.title
                        interiorId = atribut.id
                    }
                    if atribut.filterID == "b8d3f705-6277-44cb-a5b1-0ded8e19e691" {
                        
                        carColorTextView.isEnabled = true
                        carColorTextView.text = atribut.descriptions?.uk?.title
                        carColorId = atribut.id
                    }
                    if atribut.filterID == "b62b2fef-17cc-4a9b-b076-9055b26137c4" {
                        
                        carBodyTextVIew.isEnabled = true
                        carBodyTextVIew.text = atribut.descriptions?.uk?.title
                        carBodyId = atribut.id
                    }
                    if atribut.filterID == "ad2d57da-b0a1-4cc8-a6be-4786589df53c" {
                        whellRadius.isEnabled = true
                        whellRadius.text = atribut.title
                        whellRadiusId = atribut.id
                    }
                default:
                    if atribut.filterID == "0ef64c98-767b-42ba-a9de-171c6d455fff" {
                        
                        interiorTextView.isEnabled = true
                        interiorTextView.text = atribut.descriptions?.en?.title
                        interiorId = atribut.id
                    }
                    if atribut.filterID == "b8d3f705-6277-44cb-a5b1-0ded8e19e691" {
                        
                        carColorTextView.isEnabled = true
                        carColorTextView.text = atribut.descriptions?.en?.title
                        carColorId = atribut.id
                    }
                    if atribut.filterID == "b62b2fef-17cc-4a9b-b076-9055b26137c4" {
                        
                        carBodyTextVIew.isEnabled = true
                        carBodyTextVIew.text = atribut.descriptions?.en?.title
                        carBodyId = atribut.id
                    }
                    if atribut.filterID == "ad2d57da-b0a1-4cc8-a6be-4786589df53c" {
                        whellRadius.isEnabled = true
                        whellRadius.text = atribut.title
                        whellRadiusId = atribut.id
                    }
                }
              
            }
            if let regNumber = selectedCar?.registrationNumber{
                regNumberTextView.text = regNumber
            }
            if let otherText = selectedCar?.description{
                otherTextView.text = otherText
            }
            for service in (selectedCar?.services)!{
                arrayClassServices.append(service.name!)
            }
//            self.selectedClassServices.text = self.arrayClassServices.joined(separator: ",")
            regNumberTextView.isEnabled = true
            otherTextView.isEnabled = true
            self.view.endEditing(true)
        }else{
        brandsTextView.isEnabled = true
        modelTextView.isEnabled = false
        yearTextView.isEnabled = false
        interiorTextView.isEnabled = false
        carBodyTextVIew.isEnabled = false
        carColorTextView.isEnabled = false
        regNumberTextView.isEnabled = false
        otherTextView.isEnabled = false
        }
        
        if poper == true{
            self.definesPresentationContext = true
            exitBtn.isHidden = false
        }
       
        // Do any additional setup after loading the view.
    }
    @IBAction func exit(_ sender: Any) {
        self.delegate?.OrderPopDismiss()
        dismiss(animated: true, completion: nil)
    }
    //    @objc func doneButtonTapped() { self.resignFirstResponder() }
//
//    //MARK: REST API request
    func getCarBrands(){

//        startAnimating()
        let restUrl = constants.startUrl + "karma/v1/car/brands"
        Alamofire.request(restUrl, method: .get, headers: ["Authorization": (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
//                self.stopAnimating()
                return
            }
            do{
                let carBrandsList = try JSONDecoder().decode(CarBrandsList.self, from: response.data!)

                self.arrayId.removeAll()
                self.arrayItems.removeAll()

                for carBrandsListElement in carBrandsList{
                    self.arrayItems.append(carBrandsListElement.name!)
                    self.arrayId.append(carBrandsListElement.id!)
                }
                if self.brandsTextView.text!.isEmpty{
                    self.view.endEditing(true)
                    self.showDialogItem(selectionItem: self.arrayItems, selectionCategory: "BRANDS")
                }
                
                
            }
            catch{

            }

//            self.stopAnimating()

            self.picker.reloadAllComponents()
        }
    }

    func getCwarModels(brandId: String){

//        startAnimating()
        let restUrl = constants.startUrl + "karma/v1/car/models/by-brand/" + brandId
        Alamofire.request(restUrl, method: .get, encoding: JSONEncoding.default, headers: constants.appID).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
//                self.stopAnimating()
                return
            }
            do{
                let carModelsList = try JSONDecoder().decode(CarModelsList.self, from: response.data!)
                self.arrayId.removeAll()
                self.arrayItems.removeAll()
                for carModelsListElement in carModelsList{
                    self.arrayItems.append(carModelsListElement.name!)
                    self.arrayId.append(carModelsListElement.id!)
                }
                
                self.showDialogItem(selectionItem: self.arrayItems, selectionCategory: "MODEL")


            }
            catch{

            }

//            self.stopAnimating()

            self.picker.reloadAllComponents()
        }

    }

    func getCarYears(){
//        startAnimating()
        let restUrl = constants.startUrl + "karma/v1/car/years"
        Alamofire.request(restUrl, method: .get, encoding: JSONEncoding.default, headers: constants.appID).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
//                self.stopAnimating()
                return
            }
            do{
                let carYearsList = try JSONDecoder().decode(CarYearsList.self, from: response.data!)
                self.arrayId.removeAll()
                self.arrayItems.removeAll()
                for carYearsListElement in carYearsList{
                    self.arrayItems.append(String(describing: carYearsListElement.name!))

                    self.arrayId.append(carYearsListElement.id!)
                }
                self.showDialogItem(selectionItem: self.arrayItems, selectionCategory: "YEARS")

            }
            catch{

            }

//            self.stopAnimating()

            self.picker.reloadAllComponents()
        }

    }



    func getFilters(){
//        startAnimating()
        let restUrl = constants.startUrl + "karma/v1/filter/by-business-type"
//        guard UserDefaults.standard.object(forKey: "BUISNESSID") != nil else{
//            self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "businessTableViewController")), animated: true)
//            self.sideMenuViewController!.hideMenuViewController()
//            self.utils.checkFilds(massage: "Выберите сервис", vc: self.view)
////            stopAnimating()
//            return
//        }
        let toDo: [String: Any]  = ["businessType":"CAR"]
        Alamofire.request(restUrl, method: .get, parameters: toDo, encoding: URLEncoding(destination: .queryString), headers: constants.appID).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
//                self.stopAnimating()
                return
            }
            do{
                let filterBody = try JSONDecoder().decode(FiltersBody.self, from: response.data!)
                self.arrayInteriors.removeAll()
                self.arrayCarColors.removeAll()
                self.arrayCarBodies.removeAll()
                self.arrayInterior.removeAll()
                self.arrayCarColor.removeAll()
                self.arrayCarBodie.removeAll()
                for filterBodyElement in filterBody{
                    let langStr = Locale.current.languageCode
                    switch langStr {
                    case "en":
                        switch(filterBodyElement.value){
                        case "CAR_INTERIOR":
                            
                            for title in filterBodyElement.attributes!{
                                self.arrayInteriors.updateValue(title.id!, forKey: (title.descriptions?.en?.title)!)
                                self.arrayInterior.append((title.descriptions?.en?.title)!)
                            }
                            
                            break
                        case "CAR_COLOR":
                            
                            for title in filterBodyElement.attributes!{
                                self.arrayCarColors.updateValue(title.id!, forKey: (title.descriptions?.en?.title)!)
                                self.arrayCarColor.append((title.descriptions?.en?.title)!)
                            }
                            break
                        case "CAR_BODY":
                            
                            for title in filterBodyElement.attributes!{
                                self.arrayCarBodies.updateValue(title.id!, forKey: (title.descriptions?.en?.title)!)
                                self.arrayCarBodie.append((title.descriptions?.en?.title)!)
                            }
                            break
                        case "CAR_WHEEL_RADIUS":
                            
                            for title in filterBodyElement.attributes!{
                                self.arrayRadiusWheel.updateValue(title.id!, forKey: title.title!)
                                self.arrayRadius.append(title.title!)
                            }
                            break
                        default:
                            break
                        }
                    case "ru":
                        switch(filterBodyElement.value){
                        case "CAR_INTERIOR":
                            
                            for title in filterBodyElement.attributes!{
                                self.arrayInteriors.updateValue(title.id!, forKey: (title.descriptions?.ru?.title)!)
                                self.arrayInterior.append((title.descriptions?.ru?.title)!)
                            }
                            
                            break
                        case "CAR_COLOR":
                            
                            for title in filterBodyElement.attributes!{
                                self.arrayCarColors.updateValue(title.id!, forKey: (title.descriptions?.ru?.title)!)
                                self.arrayCarColor.append((title.descriptions?.ru?.title)!)
                            }
                            break
                        case "CAR_BODY":
                            
                            for title in filterBodyElement.attributes!{
                                self.arrayCarBodies.updateValue(title.id!, forKey: (title.descriptions?.ru?.title)!)
                                self.arrayCarBodie.append((title.descriptions?.ru?.title)!)
                            }
                            break
                        case "CAR_WHEEL_RADIUS":
                            
                            for title in filterBodyElement.attributes!{
                                self.arrayRadiusWheel.updateValue(title.id!, forKey: title.title!)
                                self.arrayRadius.append(title.title!)
                            }
                            break
                        default:
                            break
                        }
                    case "uk":
                        switch(filterBodyElement.value){
                        case "CAR_INTERIOR":
                            
                            for title in filterBodyElement.attributes!{
                                self.arrayInteriors.updateValue(title.id!, forKey: (title.descriptions?.uk?.title)!)
                                self.arrayInterior.append((title.descriptions?.uk?.title)!)
                            }
                            
                            break
                        case "CAR_COLOR":
                            
                            for title in filterBodyElement.attributes!{
                                self.arrayCarColors.updateValue(title.id!, forKey: (title.descriptions?.uk?.title)!)
                                self.arrayCarColor.append((title.descriptions?.uk?.title)!)
                            }
                            break
                        case "CAR_BODY":
                            
                            for title in filterBodyElement.attributes!{
                                self.arrayCarBodies.updateValue(title.id!, forKey: (title.descriptions?.uk?.title)!)
                                self.arrayCarBodie.append((title.descriptions?.uk?.title)!)
                            }
                            break
                        case "CAR_WHEEL_RADIUS":
                            
                            for title in filterBodyElement.attributes!{
                                self.arrayRadiusWheel.updateValue(title.id!, forKey: title.title!)
                                self.arrayRadius.append(title.title!)
                            }
                            break
                        default:
                            break
                        }
                    default:
                        break
                    }
                    
                }


            }
            catch{

            }



        }
    }



    func getClassServices(){
        showActivityIndicator()
        let restUrl = constants.startUrl + "karma/v1/class"
        Alamofire.request(restUrl, method: .get, encoding: JSONEncoding.default, headers: constants.appID).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.hideActivityIndicator()
                return
            }
            do{
                let carClassServices = try JSONDecoder().decode(CarClassServices.self, from: response.data!)
                self.classServices = carClassServices
                self.classServicesTable.reloadData()
//                var carServicesClass:[String: String] = [:]
//                var carServicesClassNames:[String] = []

                //
                //            var listClassServices = [ClassServices]()
                //            var selectedClassServices = [ClassServices]()
                //            listClassServices.removeAll()
                //            selectedClassServices.removeAll()
//                carServicesClassNames.removeAll()
//                carServicesClass.removeAll()
//                self.arrayClassServicesId.removeAll()
//                self.arrayClassServices.removeAll()
//                for element in carClassServices{
//                    //
//
//                    carServicesClass.updateValue(element.id!, forKey: element.name!)
//                    carServicesClassNames.append(element.name!)
//                    //
//                    //                let classServices = ClassServices(id: element.id!, classServiceName: element.name!)
//                    //                listClassServices.append(classServices)
//                }
//                let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: carServicesClassNames) { (cell, name, indexPath) in
//
//                    cell.textLabel?.text = name
//
//
//                    cell.tintColor =  _ColorLiteralType(red: 0, green: 0, blue: 0, alpha: 1)
//                }
//                selectionMenu.setSelectedItems(items: self.arrayClassServices) { [weak self] (item, index, isSelected, selectedItems) in
//                    self?.arrayClassServices = selectedItems
//                    for selected in selectedItems{
//                        self!.arrayClassServicesId.append(carServicesClass[selected]!)
//                    }
//                    self!.selectedClassServices.text = self!.arrayClassServices.joined(separator: ",")
//
//                }
//                selectionMenu.show(style: .alert(title: "Select", action: "Done", height: nil), from: self)

            }
            catch{

            }

            self.hideActivityIndicator()





        }
        self.view.endEditing(true)

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classServices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "classServicCell", for: indexPath) as! ClassServicCell
        let carService = classServices[indexPath.row]
        let langStr = Locale.current.languageCode
        switch langStr {
        case "en":
            cell.servicesName.text = carService.descriptions?.en?.name!
        case "ru":
            cell.servicesName.text = carService.descriptions?.ru?.name!
        case "uk":
            cell.servicesName.text = carService.descriptions?.uk?.name!
        default:
            cell.servicesName.text = carService.descriptions?.en?.name!
        }
        cell.servicesId.text = carService.id
        if selectedCar != nil {
            for service in (selectedCar?.services)!{
                if service.id == carService.id{
                     tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    arrayClassServices.append(cell.servicesName.text!)
                    arrayClassServicesId.append(cell.servicesId.text!)
                    cell.checkImage.isHidden = false
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: ClassServicCell = tableView.cellForRow(at: indexPath) as! ClassServicCell
        arrayClassServices.append(cell.servicesName.text!)
        arrayClassServicesId.append(cell.servicesId.text!)
        cell.checkImage.isHidden = false
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell: ClassServicCell = tableView.cellForRow(at: indexPath) as! ClassServicCell
        
        cell.checkImage.isHidden = true
        arrayClassServices.removeAll(where: { $0 == cell.servicesName.text! })
        
        arrayClassServicesId.removeAll(where: { $0 == cell.servicesId.text! })
    }

    func addCar(idService : String, carId: String){

        showActivityIndicator()
        let restUrl = constants.startUrl + "karma/v1/car/service/" + carId + "/" + idService
        Alamofire.request(restUrl, method: .post, encoding: JSONEncoding.default, headers: ["Authorization": (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.hideActivityIndicator()
                return
            }

            self.hideActivityIndicator()
            self.picker.reloadAllComponents()
        }

    }

    func addCarInfo(brandId : String , modelId : String, yearId : String, registrationNumber : String, description : String, interior : String, carBody : String, colour : String, whellRadius: String){
        showActivityIndicator()
        let restUrl = constants.startUrl + "karma/v1/car"

        
        if selectedCar != nil{
            let toDo: [String: String]  = ["brandId": brandId, "modelId": modelId, "yearId": yearId, "registrationNumber": registrationNumber, "description": description, "id": (selectedCar?.id)!]
            Alamofire.request(restUrl, method: .put, parameters: toDo, encoding: JSONEncoding.default, headers: ["Authorization": (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]).responseJSON { response  in
                guard self.utils.checkResponse(response: response, vc: self) == true else{
                    self.hideActivityIndicator()
                    return
                }
                do{
                    let responsebody = try JSONDecoder().decode(AddCarInfo.self, from: response.data!)
                    
                    for servId in self.arrayClassServicesId{
                        
                        self.addCar(idService: servId, carId: (responsebody.id)!)
                    }
                    self.setCarAttributes(carId: (responsebody.id)!, attributeId: interior)
                    self.setCarAttributes(carId: (responsebody.id)!, attributeId: carBody)
                    self.setCarAttributes(carId: (responsebody.id)!, attributeId: colour)
                    self.setCarAttributes(carId: (responsebody.id)!, attributeId: whellRadius)
                    
                    guard self.poper != true else{
                        self.poper = false
                        self.dismiss(animated: true, completion: nil)
                        
                        self.setFavorite?.setFavoriteCar(carId: responsebody.id!)
                        let carInfo = SelectedCarInfo.init(carId: (responsebody.id)!, carInfo: (responsebody.brand?.name)! + " " + (responsebody.model?.name)!, carAttributes: [interior, carBody, colour, whellRadius], carServices: self.arrayClassServicesId)
                        
                        self.utils.setCarInfo(key: "CARID", value: carInfo)
                        return
                    }
                    self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "сarListViewController")), animated: true)
                    self.sideMenuViewController!.hideMenuViewController()
                    
                }
                catch{
                    
                }
                
                self.hideActivityIndicator()
                
            }
        }else {
            let toDo: [String: Any]  = ["brandId": brandId, "modelId": modelId, "yearId": yearId, "registrationNumber": registrationNumber, "description": description]
        Alamofire.request(restUrl, method: .post, parameters: toDo, encoding: JSONEncoding.default, headers: ["Authorization": (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.hideActivityIndicator()
                return
            }
            do{
                let responsebody = try JSONDecoder().decode(AddCarInfo.self, from: response.data!)

                for servId in self.arrayClassServicesId{

                    self.addCar(idService: servId, carId: (responsebody.id)!)
                }
                self.setCarAttributes(carId: (responsebody.id)!, attributeId: interior)
                self.setCarAttributes(carId: (responsebody.id)!, attributeId: carBody)
                self.setCarAttributes(carId: (responsebody.id)!, attributeId: colour)
                self.setCarAttributes(carId: (responsebody.id)!, attributeId: whellRadius)

                guard self.poper != true else{
                    self.poper = false
                    self.dismiss(animated: true, completion: nil)
                    self.setFavorite?.setFavoriteCar(carId: responsebody.id!)
                    let carInfo = SelectedCarInfo.init(carId: (responsebody.id)!, carInfo: (responsebody.brand?.name)! + " " + (responsebody.model?.name)!, carAttributes: [interior, carBody, colour, whellRadius], carServices: self.arrayClassServicesId)
                    
                    self.utils.setCarInfo(key: "CARID", value: carInfo)
                    return
                }
                self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "сarListViewController")), animated: true)
                self.sideMenuViewController!.hideMenuViewController()

            }
            catch{
                print(error)

            }

            self.hideActivityIndicator()

        }
        }

    }
    @IBAction func deleteCarButton(_ sender: Any) {
        deleteCar()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if currentTextField == interiorTextView{
//            return arrayInteriors.count
//        }else if currentTextField == carBodyTextVIew{
//            return arrayCarBodies.count
//        }else if currentTextField == carColorTextView{
//            return arrayCarColors.count
//        }
//        return arrayItems.count
//    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if currentTextField == interiorTextView{
//            return arrayInterior[row]
//        }else if currentTextField == carBodyTextVIew{
//            return arrayCarBodie[row]
//        }else if currentTextField == carColorTextView{
//            return arrayCarColor[row]
//        }
//        return arrayItems[row]
//    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if currentTextField == brandsTextView{
//
//            brandsTextView.text = arrayItems[row]
//            brandsId = arrayId[row]
//        }else if currentTextField == modelTextView{
//            modelTextView.text = arrayItems[row]
//            modelId = arrayId[row]
//        }else if currentTextField == yearTextView{
//            yearTextView.text = arrayItems[row]
//            yearsId = arrayId[row]
//        }else if currentTextField == interiorTextView{
//            interiorTextView.text = arrayInterior[row]
//            interiorId = arrayInterior[row]
//        }else if currentTextField == carBodyTextVIew{
//            carBodyTextVIew.text = arrayCarBodie[row]
//            carBodyId = arrayCarBodie[row]
//        }else if currentTextField == carColorTextView{
//            carColorTextView.text = arrayCarColor[row]
//            carColorId = arrayCarColor[row]
//        }
//    }
    func setSelectedItem(index: Int, selectedCategory: String){
        switch selectedCategory {
        case "BRANDS":
            brandsTextView.text = arrayItems[index]
            brandsId = arrayId[index]
            
            self.modelTextView.isEnabled = true
            break
        case "MODEL":
            modelTextView.text = arrayItems[index]
            modelId = arrayId[index]
            break
        case "YEARS":
            yearTextView.text = arrayItems[index]
            yearsId = arrayId[index]
            break
        case "INTERIOR":
            interiorTextView.text = arrayInterior[index]
            interiorId = arrayInteriors[arrayInterior[index]]
            break
        case "CARBODY":
            carBodyTextVIew.text = arrayCarBodie[index]
            carBodyId = arrayCarBodies[arrayCarBodie[index]]
            break
        case "CARCOLOR":
            carColorTextView.text = arrayCarColor[index]
            carColorId = arrayCarColors[arrayCarColor[index]]
            break
        case "CAR_WHEEL_RADIUS":
            whellRadius.text = arrayRadius[index]
            carColorId = arrayRadiusWheel[arrayRadius[index]]
            break
        default:
            break
        }
    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if currentTextField == brandsTextView{
//
//            getCwarModels(brandId: brandsId!)
//        }else if currentTextField == modelTextView{
//            getCarYears()
//        }else if currentTextField == yearTextView{
//        }else if currentTextField == interiorTextView{
//        }else if currentTextField == carBodyTextVIew{
//        }else if currentTextField == carColorTextView{
//        }
//    }
    func showDialogItem(selectionItem: [String?], selectionCategory: String) {
       
        
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "createCarDialog") as! CreateCarDialog
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        customAlert.selectonItem = selectionItem
        customAlert.selectionCategory = selectionCategory
//        transitionVc(vc: customAlert, duration: 0.1, type: .fromTop)
                self.present(customAlert, animated: true, completion: nil)
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {


//        self.picker.delegate = self
//        self.picker.dataSource = self
//        self.picker.backgroundColor = .white
////        self.currentTextField.inputAccessoryView = toolBar
        currentTextField = textField
//        currentTextField.addDoneCancelToolbar()
        if currentTextField == brandsTextView{
            if brandsTextView.text != ""{
                getCarBrands()
            }
//            currentTextField.inputView = picker
            if brandsTextView.text!.isEmpty{
                self.showDialogItem(selectionItem: self.arrayItems, selectionCategory: "BRANDS")
            }
            self.view.endEditing(true)
            self.modelTextView.isEnabled = true
            self.yearTextView.isEnabled = false
            self.interiorTextView.isEnabled = false
            self.carBodyTextVIew.isEnabled = false
            self.carColorTextView.isEnabled = false
            self.whellRadius.isEnabled = false
            self.regNumberTextView.isEnabled = false
            self.otherTextView.isEnabled = false
            
            self.modelTextView.text?.removeAll()
            self.yearTextView.text?.removeAll()
            self.interiorTextView.text?.removeAll()
            self.carBodyTextVIew.text?.removeAll()
            self.carColorTextView.text?.removeAll()
            self.whellRadius.text?.removeAll()
            self.regNumberTextView.text?.removeAll()
            self.otherTextView.text?.removeAll()
        }else if currentTextField == modelTextView{
            guard self.brandsId != nil else{
                 self.brandsTextView.becomeFirstResponder()
                return
            }
            getCwarModels(brandId: self.brandsId!)
           
//            currentTextField.inputView = picker
            
            self.view.endEditing(true)
            self.modelTextView.isEnabled = true
            self.yearTextView.isEnabled = true
            self.interiorTextView.isEnabled = false
            self.carBodyTextVIew.isEnabled = false
            self.carColorTextView.isEnabled = false
            self.whellRadius.isEnabled = false
            self.regNumberTextView.isEnabled = false
            self.otherTextView.isEnabled = false
            
            self.yearTextView.text?.removeAll()
            self.interiorTextView.text?.removeAll()
            self.carBodyTextVIew.text?.removeAll()
            self.carColorTextView.text?.removeAll()
            self.whellRadius.text?.removeAll()
            self.regNumberTextView.text?.removeAll()
            self.otherTextView.text?.removeAll()
        }else if currentTextField == yearTextView{
            getCarYears()
            if arrayInteriors.count == 0{
                getFilters()
            }
//            currentTextField.inputView = picker
            
            
            self.view.endEditing(true)
            self.modelTextView.isEnabled = true
            self.yearTextView.isEnabled = true
            self.interiorTextView.isEnabled = true
            self.carBodyTextVIew.isEnabled = false
            self.carColorTextView.isEnabled = false
            self.whellRadius.isEnabled = false
            self.regNumberTextView.isEnabled = false
            self.otherTextView.isEnabled = false
            
            self.interiorTextView.text?.removeAll()
            self.carBodyTextVIew.text?.removeAll()
            self.carColorTextView.text?.removeAll()
            self.whellRadius.text?.removeAll()
            self.regNumberTextView.text?.removeAll()
            self.otherTextView.text?.removeAll()
        }else if currentTextField == interiorTextView{
           
//            currentTextField.inputView = picker
            
            showDialogItem(selectionItem: arrayInterior, selectionCategory: "INTERIOR")
            self.modelTextView.isEnabled = true
            self.yearTextView.isEnabled = true
            self.interiorTextView.isEnabled = true
            self.carBodyTextVIew.isEnabled = true
            self.carColorTextView.isEnabled = false
            self.whellRadius.isEnabled = false
            self.regNumberTextView.isEnabled = false
            self.otherTextView.isEnabled = false
            
            self.view.endEditing(true)
//            self.carBodyTextVIew.text?.removeAll()
//            self.carColorTextView.text?.removeAll()
//            self.whellRadius.text?.removeAll()
//            self.regNumberTextView.text?.removeAll()
//            self.otherTextView.text?.removeAll()
        }else if currentTextField == carBodyTextVIew{
//            currentTextField.inputView = picker
            
            showDialogItem(selectionItem: arrayCarBodie, selectionCategory: "CARBODY")
            self.view.endEditing(true)
            self.modelTextView.isEnabled = true
            self.yearTextView.isEnabled = true
            self.interiorTextView.isEnabled = true
            self.carBodyTextVIew.isEnabled = true
            self.carColorTextView.isEnabled = true
            self.whellRadius.isEnabled = false
            self.regNumberTextView.isEnabled = false
            self.otherTextView.isEnabled = false
            
//            self.carColorTextView.text?.removeAll()
//            self.whellRadius.text?.removeAll()
//            self.regNumberTextView.text?.removeAll()
//            self.otherTextView.text?.removeAll()
        }else if currentTextField == carColorTextView{
//            currentTextField.inputView = picker
            
            showDialogItem(selectionItem: arrayCarColor, selectionCategory: "CARCOLOR")
            self.view.endEditing(true)
            self.modelTextView.isEnabled = true
            self.yearTextView.isEnabled = true
            self.interiorTextView.isEnabled = true
            self.carBodyTextVIew.isEnabled = true
            self.carColorTextView.isEnabled = true
            self.whellRadius.isEnabled = true
            self.regNumberTextView.isEnabled = false
            self.otherTextView.isEnabled = false
//
//            self.regNumberTextView.text?.removeAll()
//            self.otherTextView.text?.removeAll()
//            self.whellRadius.text?.removeAll()
        }else if currentTextField == whellRadius{
            //            currentTextField.inputView = picker
            
            showDialogItem(selectionItem: arrayRadius, selectionCategory: "CAR_WHEEL_RADIUS")
            self.view.endEditing(true)
            self.modelTextView.isEnabled = true
            self.yearTextView.isEnabled = true
            self.interiorTextView.isEnabled = true
            self.carBodyTextVIew.isEnabled = true
            self.carColorTextView.isEnabled = true
            self.whellRadius.isEnabled = true
            self.regNumberTextView.isEnabled = true
            self.otherTextView.isEnabled = true
            
        }else if currentTextField == regNumberTextView{
            self.modelTextView.isEnabled = true
            self.yearTextView.isEnabled = true
            self.interiorTextView.isEnabled = true
            self.carBodyTextVIew.isEnabled = true
            self.carColorTextView.isEnabled = true
            self.whellRadius.isEnabled = true
            self.regNumberTextView.isEnabled = true
            self.otherTextView.isEnabled = true
        }else if currentTextField == otherTextView{

        }
//        else if currentTextField == selectedClassServices{
//            getClassServices()
//        }
    }
    @IBAction func addCarBtn(_ sender: Any) {
        
        self.view.endEditing(true)
        let carInterior = arrayInteriors[self.interiorTextView.text!]
        let carBody = arrayCarBodies[self.carBodyTextVIew.text!]
        let carColor = arrayCarColors[self.carColorTextView.text!]
        let carRadius = arrayRadiusWheel[self.whellRadius.text!]

        guard brandsId != nil else {
            //            utils.showToast(message: "Выберите марку машины",viewController: self)
            TinyToast.shared.show(message: NSLocalizedString("Enter_brand", comment: ""), valign: .bottom, duration: .normal)
            return
        }
        guard modelId != nil else {
            //            utils.showToast(message: "Выберите модель машины",viewController: self)
            TinyToast.shared.show(message: NSLocalizedString("Enter_model", comment: ""), valign: .bottom, duration: .normal)
            return
        }
        guard yearsId != nil else {
            //            utils.showToast(message: "Выберите год машины",viewController: self)
            TinyToast.shared.show(message: NSLocalizedString("Enter_year", comment: ""), valign: .bottom, duration: .normal)
            return
        }

        guard carBody != nil else {
            //            utils.showToast(message: "Выберите кузов машины",viewController: self)
            TinyToast.shared.show(message: NSLocalizedString("Enter_carBody", comment: ""), valign: .bottom, duration: .normal)
            return
        }
        guard carInterior != nil else {
            //            utils.showToast(message: "Выберите салон машины",viewController: self)
            TinyToast.shared.show(message: NSLocalizedString("Enter_carInterior", comment: ""), valign: .bottom, duration: .normal)
            return
        }
        guard carColor != nil else {
            //            utils.showToast(message: "Выберите цвет машины",viewController: self)
            TinyToast.shared.show(message: NSLocalizedString("Enter_carColor", comment: ""), valign: .bottom, duration: .normal)
            return
        }
        guard carRadius != nil else {
            //            utils.showToast(message: "Выберите цвет машины",viewController: self)
            TinyToast.shared.show(message: NSLocalizedString("Enter_carRadius", comment: ""), valign: .bottom, duration: .normal)
            return
        }
        addCarInfo(brandId: brandsId!, modelId: modelId!, yearId: yearsId!, registrationNumber: self.regNumberTextView.text!, description: self.otherTextView.text!, interior: carInterior!, carBody: carBody!, colour: carColor!, whellRadius: carRadius!)
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//
    func setCarAttributes(carId: String, attributeId: String) {

        let restUrl = constants.startUrl + "karma/v1/car/filter-attribute/" + carId + "/" + attributeId
        Alamofire.request(restUrl, method: .post, encoding: JSONEncoding.default, headers: ["Authorization": (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.hideActivityIndicator()
                return
            }

            self.hideActivityIndicator()
            self.picker.reloadAllComponents()
        }
    }
    func Dismiss(index: Int, selectionCategory: String) {
        setSelectedItem(index: index, selectedCategory: selectionCategory)
    }
    
   
    @objc func deleteCar(){
        showActivityIndicator()
        let restUrl = constants.startUrl + "karma/v1/car/\((selectedCar?.id)!)"
        guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
            self.utils.checkAutorization(vc: self)
            hideActivityIndicator()
            return
        }
        let headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]
        Alamofire.request(restUrl, method: .delete, headers: headers).responseJSON { response  in
            guard response.result.error == nil else {
                // got an error in getting the data, need to handle it
                print("error calling POST on /todos/1")
                print(response.result.error!)
                self.hideActivityIndicator()
                return
            }
            // make sure we got some JSON since that's what we expect
            guard response.result.value != nil else{
                self.hideActivityIndicator()
                return
            }
            if self.selectedCar?.favorite == true{
                
                UserDefaults.standard.removeObject(forKey: "CARID")
            }
        self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "сarListViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            self.hideActivityIndicator()
        }
    }
}
