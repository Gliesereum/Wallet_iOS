//
//  CreateCar.swift
//  Karma
//
//  Created by macbook on 26/04/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//

import UIKit
import Alamofire
import RSSelectionMenu

class CreateCar: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable, CreateCarDialogDismissDelegate{
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var brandsTextView: UITextField!
    @IBOutlet weak var modelTextView: UITextField!
    @IBOutlet weak var yearTextView: UITextField!
    @IBOutlet weak var interiorTextView: UITextField!
    @IBOutlet weak var carBodyTextVIew: UITextField!
    @IBOutlet weak var carColorTextView: UITextField!
    @IBOutlet weak var regNumberTextView: UITextField!
    @IBOutlet weak var otherTextView: UITextField!
    @IBOutlet weak var selectedClassServices: UITextField!
    
    let constants = Constants()
    let utils = Utils()
    var currentTextField = UITextField()
    var picker = UIPickerView()
    var arrayItems: [String] = []
    var arrayId: [String] = []
    var arrayClassServices: [String] = []
    var arrayClassServicesId: [String] = []
    var arrayInterior: [String] = []
    var arrayCarBodie: [String] = []
    var arrayCarColor: [String] = []
    var arrayInteriors: [String : String] = [:]
    var arrayCarBodies: [String : String] = [:]
    var arrayCarColors: [String : String] = [:]
    var brandsId, modelId, yearsId, interiorId, carBodyId, carColorId, carServiceId: String?
    var openVC: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        getCarBrands()
        modelTextView.isEnabled = false
        yearTextView.isEnabled = false
        interiorTextView.isEnabled = false
        carBodyTextVIew.isEnabled = false
        carColorTextView.isEnabled = false
        regNumberTextView.isEnabled = false
        otherTextView.isEnabled = false
        regNumberTextView.addDoneCancelToolbar()
        otherTextView.addDoneCancelToolbar()
        getFilters()
        
       
        // Do any additional setup after loading the view.
    }
//    @objc func doneButtonTapped() { self.resignFirstResponder() }
//
//    //MARK: REST API request
    func getCarBrands(){

//        startAnimating()
        let restUrl = constants.startUrl + "karma/v1/car/brands"
        Alamofire.request(restUrl, method: .get, headers: ["Authorization": (self.utils.getSharedPref(key: "accessToken"))!]).responseJSON { response  in
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
                if self.brandsTextView.text != ""{
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
        Alamofire.request(restUrl, method: .get, encoding: JSONEncoding.default).responseJSON { response  in
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
        Alamofire.request(restUrl, method: .get, encoding: JSONEncoding.default).responseJSON { response  in
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
        let restUrl = constants.startUrl + "karma/v1/filter/by-business-category"
        guard UserDefaults.standard.object(forKey: "BUISNESSID") != nil else{
            self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "businessTableViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            self.utils.checkFilds(massage: "Выберите сервис", vc: self.view)
//            stopAnimating()
            return
        }
        let toDo: [String: Any]  = ["businessCategoryId": UserDefaults.standard.object(forKey: "BUISNESSID")!]
        Alamofire.request(restUrl, method: .get, parameters: toDo, encoding: URLEncoding(destination: .queryString)).responseJSON { response  in
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
                    switch(filterBodyElement.value){
                    case "CAR_INTERIOR":

                        for title in filterBodyElement.attributes!{
                            self.arrayInteriors.updateValue(title.id!, forKey: title.title!)
                            self.arrayInterior.append(title.title!)
                        }

                        break
                    case "CAR_COLOR":

                        for title in filterBodyElement.attributes!{
                            self.arrayCarColors.updateValue(title.id!, forKey: title.title!)
                            self.arrayCarColor.append(title.title!)
                        }
                        break
                    case "CAR_BODY":

                        for title in filterBodyElement.attributes!{
                            self.arrayCarBodies.updateValue(title.id!, forKey: title.title!)
                            self.arrayCarBodie.append(title.title!)
                        }
                        break
                    default:
                        break
                    }
                }


            }
            catch{

            }

            self.stopAnimating()


        }
    }



    func getClassServices(){
        startAnimating()
        let restUrl = constants.startUrl + "karma/v1/class"
        Alamofire.request(restUrl, method: .get, encoding: JSONEncoding.default).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            do{
                let carClassServices = try JSONDecoder().decode(CarClassServices.self, from: response.data!)
                var carServicesClass:[String: String] = [:]
                var carServicesClassNames:[String] = []

                //
                //            var listClassServices = [ClassServices]()
                //            var selectedClassServices = [ClassServices]()
                //            listClassServices.removeAll()
                //            selectedClassServices.removeAll()
                carServicesClassNames.removeAll()
                carServicesClass.removeAll()
                self.arrayClassServicesId.removeAll()
                self.arrayClassServices.removeAll()
                for element in carClassServices{
                    //

                    carServicesClass.updateValue(element.id!, forKey: element.name!)
                    carServicesClassNames.append(element.name!)
                    //
                    //                let classServices = ClassServices(id: element.id!, classServiceName: element.name!)
                    //                listClassServices.append(classServices)
                }
                let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: carServicesClassNames) { (cell, name, indexPath) in

                    cell.textLabel?.text = name


                    cell.tintColor =  _ColorLiteralType(red: 0, green: 0, blue: 0, alpha: 1)
                }
                selectionMenu.setSelectedItems(items: self.arrayClassServices) { [weak self] (item, index, isSelected, selectedItems) in
                    self?.arrayClassServices = selectedItems
                    for selected in selectedItems{
                        self!.arrayClassServicesId.append(carServicesClass[selected]!)
                    }
                    self!.selectedClassServices.text = self!.arrayClassServices.joined(separator: ",")

                }
                selectionMenu.show(style: .alert(title: "Select", action: "Done", height: nil), from: self)

            }
            catch{

            }

            self.stopAnimating()





        }
        self.view.endEditing(true)

    }


    func addCar(idService : String, carId: String){

        startAnimating()
        let restUrl = constants.startUrl + "karma/v1/car/service/" + carId + "/" + idService
        Alamofire.request(restUrl, method: .post, encoding: JSONEncoding.default, headers: ["Authorization": (self.utils.getSharedPref(key: "accessToken"))!]).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }

            self.stopAnimating()
            self.picker.reloadAllComponents()
        }

    }

    func addCarInfo(brandId : String , modelId : String, yearId : String, registrationNumber : String, description : String, interior : String, carBody : String, colour : String){
        startAnimating()
        let restUrl = constants.startUrl + "karma/v1/car"

        let toDo: [String: Any]  = ["brandId": brandId, "modelId": modelId, "yearId": yearId, "registrationNumber": registrationNumber, "description": description, "interior": interior, "carBody": carBody, "colour": colour]
        Alamofire.request(restUrl, method: .post, parameters: toDo, encoding: JSONEncoding.default, headers: ["Authorization": (self.utils.getSharedPref(key: "accessToken"))!]).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
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


                self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "сarListViewController")), animated: true)
                self.sideMenuViewController!.hideMenuViewController()

            }
            catch{

            }

            self.stopAnimating()

        }

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
            interiorId = arrayInterior[index]
            break
        case "CARBODY":
            carBodyTextVIew.text = arrayCarBodie[index]
            carBodyId = arrayCarBodie[index]
            break
        case "CARCOLOR":
            carColorTextView.text = arrayCarColor[index]
            carColorId = arrayCarColor[index]
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
            if brandsTextView.text?.count == 0{
                self.showDialogItem(selectionItem: self.arrayItems, selectionCategory: "BRANDS")
            }
            self.modelTextView.isEnabled = true
            self.yearTextView.isEnabled = false
            self.interiorTextView.isEnabled = false
            self.carBodyTextVIew.isEnabled = false
            self.carColorTextView.isEnabled = false
            self.regNumberTextView.isEnabled = false
            self.otherTextView.isEnabled = false
            
            self.modelTextView.text?.removeAll()
            self.yearTextView.text?.removeAll()
            self.interiorTextView.text?.removeAll()
            self.carBodyTextVIew.text?.removeAll()
            self.carColorTextView.text?.removeAll()
            self.regNumberTextView.text?.removeAll()
            self.otherTextView.text?.removeAll()
        }else if currentTextField == modelTextView{
            guard self.brandsId != nil else{
                 self.brandsTextView.becomeFirstResponder()
                return
            }
            getCwarModels(brandId: self.brandsId!)
           
//            currentTextField.inputView = picker
            
            self.modelTextView.isEnabled = true
            self.yearTextView.isEnabled = true
            self.interiorTextView.isEnabled = false
            self.carBodyTextVIew.isEnabled = false
            self.carColorTextView.isEnabled = false
            self.regNumberTextView.isEnabled = false
            self.otherTextView.isEnabled = false
            
            self.yearTextView.text?.removeAll()
            self.interiorTextView.text?.removeAll()
            self.carBodyTextVIew.text?.removeAll()
            self.carColorTextView.text?.removeAll()
            self.regNumberTextView.text?.removeAll()
            self.otherTextView.text?.removeAll()
        }else if currentTextField == yearTextView{
            getCarYears()
            if arrayInteriors.count == 0{
                getFilters()
            }
//            currentTextField.inputView = picker
            
            
            self.modelTextView.isEnabled = true
            self.yearTextView.isEnabled = true
            self.interiorTextView.isEnabled = true
            self.carBodyTextVIew.isEnabled = false
            self.carColorTextView.isEnabled = false
            self.regNumberTextView.isEnabled = false
            self.otherTextView.isEnabled = false
            
            self.interiorTextView.text?.removeAll()
            self.carBodyTextVIew.text?.removeAll()
            self.carColorTextView.text?.removeAll()
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
            self.regNumberTextView.isEnabled = false
            self.otherTextView.isEnabled = false
            
            self.carBodyTextVIew.text?.removeAll()
            self.carColorTextView.text?.removeAll()
            self.regNumberTextView.text?.removeAll()
            self.otherTextView.text?.removeAll()
        }else if currentTextField == carBodyTextVIew{
//            currentTextField.inputView = picker
            
            showDialogItem(selectionItem: arrayCarBodie, selectionCategory: "CARBODY")
            self.modelTextView.isEnabled = true
            self.yearTextView.isEnabled = true
            self.interiorTextView.isEnabled = true
            self.carBodyTextVIew.isEnabled = true
            self.carColorTextView.isEnabled = true
            self.regNumberTextView.isEnabled = false
            self.otherTextView.isEnabled = false
            
            self.carColorTextView.text?.removeAll()
            self.regNumberTextView.text?.removeAll()
            self.otherTextView.text?.removeAll()
        }else if currentTextField == carColorTextView{
//            currentTextField.inputView = picker
            
            showDialogItem(selectionItem: arrayCarColor, selectionCategory: "CARCOLOR")
            self.modelTextView.isEnabled = true
            self.yearTextView.isEnabled = true
            self.interiorTextView.isEnabled = true
            self.carBodyTextVIew.isEnabled = true
            self.carColorTextView.isEnabled = true
            self.regNumberTextView.isEnabled = true
            self.otherTextView.isEnabled = true
            
            self.otherTextView.text?.removeAll()
        }else if currentTextField == regNumberTextView{
            self.modelTextView.isEnabled = true
            self.yearTextView.isEnabled = true
            self.interiorTextView.isEnabled = true
            self.carBodyTextVIew.isEnabled = true
            self.carColorTextView.isEnabled = true
            self.regNumberTextView.isEnabled = true
            self.otherTextView.isEnabled = true
        }else if currentTextField == otherTextView{

        }else if currentTextField == selectedClassServices{
            getClassServices()
        }
    }
    @IBAction func addCarBtn(_ sender: Any) {
        
        self.view.endEditing(true)
        let carInterior = arrayInteriors[self.interiorTextView.text!]
        let carBody = arrayCarBodies[self.carBodyTextVIew.text!]
        let carColor = arrayCarColors[self.carColorTextView.text!]

        guard brandsId != nil else {
            //            utils.showToast(message: "Выберите марку машины",viewController: self)
            TinyToast.shared.show(message: "Выберите марку машины", valign: .bottom, duration: .normal)
            return
        }
        guard modelId != nil else {
            //            utils.showToast(message: "Выберите модель машины",viewController: self)
            TinyToast.shared.show(message: "Выберите модель машины", valign: .bottom, duration: .normal)
            return
        }
        guard yearsId != nil else {
            //            utils.showToast(message: "Выберите год машины",viewController: self)
            TinyToast.shared.show(message: "Выберите год машины", valign: .bottom, duration: .normal)
            return
        }

        guard carBody != nil else {
            //            utils.showToast(message: "Выберите кузов машины",viewController: self)
            TinyToast.shared.show(message: "Выберите кузов машины", valign: .bottom, duration: .normal)
            return
        }
        guard carInterior != nil else {
            //            utils.showToast(message: "Выберите салон машины",viewController: self)
            TinyToast.shared.show(message: "Выберите салон машины", valign: .bottom, duration: .normal)
            return
        }
        guard carColor != nil else {
            //            utils.showToast(message: "Выберите цвет машины",viewController: self)
            TinyToast.shared.show(message: "Выберите цвет машины", valign: .bottom, duration: .normal)
            return
        }
        addCarInfo(brandId: brandsId!, modelId: modelId!, yearId: yearsId!, registrationNumber: self.regNumberTextView.text!, description: self.otherTextView.text!, interior: carInterior!, carBody: carBody!, colour: carColor!)
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
        Alamofire.request(restUrl, method: .post, encoding: JSONEncoding.default, headers: ["Authorization": (self.utils.getSharedPref(key: "accessToken"))!]).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }

            self.stopAnimating()
            self.picker.reloadAllComponents()
        }
    }
    func Dismiss(index: Int, selectionCategory: String) {
        setSelectedItem(index: index, selectedCategory: selectionCategory)
    }
    
   
}
