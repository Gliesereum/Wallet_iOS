//
//  SetTimeDialog.swift
//  Karma
//
//  Created by macbook on 26/05/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//


import UIKit

protocol SetTimeDialogDismissDelegate: class {
    func DismissTime(currentTime: Int)
}
class SetTimeDialog: UIViewController, NVActivityIndicatorViewable, UIGestureRecognizerDelegate {
    @IBAction func fastTime(_ sender: Any) {
        
        dissmis()
        delegate?.DismissTime(currentTime: 0)
        
    }
    @IBOutlet weak var fastTimeBtn: UIButton!
    
    @IBAction func manualTime(_ sender: Any) {
        
        delegate?.DismissTime(currentTime: 1)
        dissmis()
    }
    var enable = true
    @IBOutlet weak var headerView: UIView!
    
    let utils = Utils()
    var currentTime = Int()
    let constants = Constants()
    
    var delegate: SetTimeDialogDismissDelegate?
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if enable == false{
            fastTimeBtn.isEnabled = false
            fastTimeBtn.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
      utils.setBorder(view: headerView, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1), borderWidth: 1, cornerRadius: 4)
        // Do any additional setup after loading the view.
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(dissmis))
        
        tapGR.delegate = self
        tapGR.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGR)
    }
    
    @objc func dissmis(){
        dismiss(animated: true, completion: nil)
    }

//    func getCurrentTime(setTime: Int) -> Int {
//        let restUrl = constants.startUrl + "karma/v1/record/free-time"
//        //       utils.currentTimeInMiliseconds(timeZone: (carWashInfo?.timeZone)!)
//        startAnimating()
////        let parameters = try! JSONEncoder().encode(OrderBodyCarWash.init(begin: setTime, businessID: carWashInfo?.businessID, description: "IOS", packageID: self.text.text, servicesIDS: idServicePrice, targetID: utils.getSharedPref(key: "CARID"), workingSpaceID: nil))
//        let params = try! JSONSerialization.jsonObject(with: parameters, options: .allowFragments)as? [String: Any]
//        Alamofire.request(restUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization": (self.utils.getSharedPref(key: "accessToken"))!]).responseJSON { response  in
//            do{
//
//                guard self.utils.checkResponse(response: response, vc: self) == true else{
//                    self.stopAnimating()
//                    self.currentTime = 0
//                    return
//                }
//
//
//
//                let currentFreeTime = try JSONDecoder().decode(CurrentFreeTime.self, from: response.data!)
//                guard currentFreeTime.begin != nil else{
//                    return
//                }
//                self.currentTime = currentFreeTime.begin!
//                self.workSpaceId = currentFreeTime.workingSpaceID!
//                self.time = self.utils.milisecondsToDate(miliseconds: self.currentTime)
//                self.dialogController.message = "Выбраное время \(self.time)"
//
//            }
//            catch{
//
//            }
//
//            self.stopAnimating()
//
//            //
//        }
//        //        guard self.currentTime != 0 else{
//        //            return 0
//        //        }
//        return self.currentTime
//    }
//    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
//        guard self.getCurrentTime(setTime: self.utils.dateToMillisecond(date: didSelectDate, timeZone: (self.carWashInfo?.timeZone)!)) != 0 else{
//            picker.doneButtonTitle = "Выберите другое время"
//            //             TinyToast.shared.show(message: "Мойка не работает в данное время. Выберите другое время", valign: .center, duration: 1)
//            return
//        }
//        picker.doneButtonTitle = "Выбрать это время"
//        
//        
//        
//    }
}

