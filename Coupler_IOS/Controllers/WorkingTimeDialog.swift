//
//  WorkingTimeDialog.swift
//  Karma
//
//  Created by macbook on 26/05/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//


import UIKit

protocol WorkingTimeDismissDelegate: class {
    func Dismiss(filterListId: [String], filterOn: Bool)
}
class WorkingTimeDialog: UIViewController, NVActivityIndicatorViewable, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var beginMo: UILabel!
    @IBOutlet weak var endMo: UILabel!
    @IBOutlet weak var beginTu: UILabel!
    @IBOutlet weak var endTu: UILabel!
    @IBOutlet weak var beginWe: UILabel!
    @IBOutlet weak var endWe: UILabel!
    @IBOutlet weak var beginTh: UILabel!
    @IBOutlet weak var endTh: UILabel!
    @IBOutlet weak var beginFr: UILabel!
    @IBOutlet weak var endFr: UILabel!
    @IBOutlet weak var beginSa: UILabel!
    @IBOutlet weak var endSa: UILabel!
    @IBOutlet weak var beginSu: UILabel!
    @IBOutlet weak var endSu: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    
    
    let utils = Utils()
    let constants = Constants()
    var carWashInfo: CarWashBody? = nil
    
    
    
    var delegate: WorkingTimeDismissDelegate?
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        utils.setBorder(view: headerView, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), borderWidth: 2, cornerRadius: 4)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(dissmis))
        
        tapGR.delegate = self
        tapGR.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGR)
        timeShow()
    }
    
    
    @objc func dissmis(){
        dismiss(animated: true, completion: nil)
    }
    
    func getProfTime(day: WorkTime, start: UILabel, end: UILabel){
        if day.isWork == true {
            start.text = utils.milisecondsToTime(miliseconds: day.from!, timeZone: (carWashInfo?.timeZone)!)
            end.text = utils.milisecondsToTime(miliseconds: day.to!, timeZone: (carWashInfo?.timeZone)!)
        }else {
            start.text = "-:-"
            end.text = "-:-"
        }
    }
    
    func timeShow(){
        for day in (carWashInfo?.workTimes)! {
            switch day.dayOfWeek{
            case "TUESDAY":
            getProfTime(day: day, start: self.beginTu, end: self.endTu)
            break
            case "THURSDAY":
            getProfTime(day: day, start: self.beginTh, end: self.endTh)
            break
            case "MONDAY":
            getProfTime(day: day, start: self.beginMo, end: self.endMo)
            break
            case "SATURDAY":
            getProfTime(day: day, start: self.beginSa, end: self.endSa)
            break
            case "SUNDAY":
            getProfTime(day: day, start: self.beginSu, end: self.endSu)
            break
            case "FRIDAY":
            getProfTime(day: day, start: self.beginFr, end: self.endFr)
            break
            case "WEDNESDAY":
            getProfTime(day: day, start: self.beginWe, end: self.endWe)
            break
            default:
            break
            }
        }
    }
}

