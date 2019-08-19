//
//  CarWashInfo.swift
//  Karma
//
//  Created by macbook on 18/02/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//

import UIKit
import Alamofire
//import SDWebImage
import EHHorizontalSelectionView
import FloatRatingView
import MaterialComponents


class CarWashInfo: UIViewController, UITableViewDataSource, FSPagerViewDelegate, FSPagerViewDataSource, NVActivityIndicatorViewable, UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate, FilterDialodDismissDelegate, ImageShowDismissDelegate, WorkingTimeDismissDelegate {
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
                let carWashMedia = carWashInfo?.media![index]
                cell.imageView?.downloaded(from: (carWashMedia?.url)!)
                cell.imageView?.contentMode = .scaleAspectFill
                cell.imageView?.clipsToBounds = true
                return cell
    }
    
  
    
   
    
    @IBOutlet weak var snTime: UILabel!
    @IBOutlet weak var stTime: UILabel!
    @IBOutlet weak var frTime: UILabel!
    @IBOutlet weak var thTime: UILabel!
    @IBOutlet weak var wnTime: UILabel!
    @IBOutlet weak var tuTime: UILabel!
    @IBOutlet weak var mnTime: UILabel!
    @IBOutlet weak var callUsBtn: UIButton!
    @IBOutlet weak var addCommentsBtn: UIButton!
    @IBOutlet weak var raiting: FloatRatingView!
    @IBOutlet weak var nameCarWash: UILabel!
    @IBOutlet weak var adressCW: UILabel!
    @IBOutlet weak var logoCarWash: UIImageView!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var goToOrders: MDCButton!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var callUsView: UIView!
    @IBOutlet weak var imageScroll: FSPagerView!{
        didSet {
    self.imageScroll.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    //    @IBOutlet weak var isWorkLable: UILabel!
    @IBOutlet weak var commentsTable: UITableView!
//    @IBOutlet weak var statusLable: UILabel!
//    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var buttonView: UIView!
    
//    @IBOutlet weak var timeImage: UIButton!
    var carWashInfo: CarWashBody? = nil
    var carWashId: String = ""
    let utils = Utils()
    let constants = Constants()
    let showComments = false
    var isComment = false
    
    override func viewDidLoad() {
        
        carWashInfo = self.utils.getCarWashBody(key: "CARWASHBODY")
        if carWashInfo?.phone == nil{
            callUsView.visiblity(gone: true)
            
            photoView.isHidden = true
            self.view.layoutIfNeeded()
        }
        commentsTable.estimatedRowHeight = 120
        utils.setBorder(view: addCommentsBtn, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), borderWidth: 1, cornerRadius: 8)
        utils.setBorder(view: callUsBtn, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), borderWidth: 1, cornerRadius: 8)
        let swImage = UITapGestureRecognizer(target: self, action: #selector(showImage))
        swImage.delegate = self
        swImage.numberOfTapsRequired = 1
        imageScroll.interitemSpacing = 20
        imageScroll.itemSize = CGSize(width: 200, height: 178)
        imageScroll.addGestureRecognizer(swImage)
        commentsTable.tableFooterView = UIView()
        commentsTable.layoutIfNeeded()
        getCarWashInfo()
        getMyComment()
        super.viewDidLoad()
        imageScroll.transformer = FSPagerViewTransformer(type: .linear)
        if carWashInfo?.media?.count == 0 {
            photoView.visiblity(gone: true)
            photoView.isHidden = true
            self.view.layoutIfNeeded()
        }
        timeShow()
        if UserDefaults.standard.object(forKey: "CARWASHINFOVC") == nil{
            
            self.utils.setSaredPref(key: "CARWASHINFOVC", value: "true")
            self.showTutorial()
        }
                // Do any additional setup after loading the view.
        
    }
    

  
//    @IBAction func showTimes(_ sender: Any) {
//        showWorkTime()
//    }
    
    @IBAction func callUs(_ sender: Any) {
        if let phoneCallURL = URL(string: "telprompt://\((carWashInfo?.phone)!)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    @IBAction func addComment(_ sender: Any) {
//        guard self.isComment != false else {
//            TinyToast.shared.show(message: "Вы уже оставляли комментарий", valign: .bottom, duration: .normal)
//            return
        //        }
    guard utils.getSharedPref(key: "accessToken") != nil else{
        self.utils.checkFilds(massage: "Что бы оставить комменатирий Вы должны авторизироватся", vc: self.view)
//        self.buttonView.visiblity(gone: true)
        stopAnimating()
        return
        
       
    }
        guard utils.getSharedPref(key: "USER") != nil else{
            let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
            customAlert.poper = true
            customAlert.providesPresentationContextTransitionStyle = true
            customAlert.definesPresentationContext = true
            customAlert.modalPresentationStyle = UIModalPresentationStyle.popover
            customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            //            customAlert.delegate = self
            self.present(customAlert, animated: true, completion: nil)
            return
        }
          showDialog(.slideLeftRight)
    }
    @IBAction func carWashOrder(_ sender: Any) {
        if carWashInfo?.workers!.count == 0 || carWashInfo?.workers == nil{
            utils.checkFilds(massage: "У этой компании нет возможности записи онлайн. Вы можете сделать заказ по телефону", vc: self.view)
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "orderWash") as! OrderWash
            vc.carWashInfo = self.carWashInfo
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        self.commentsCount.text = "(\(carWashInfo!.comments!.count))"
//        if carWashInfo!.comments!.count == 0{
//            commentsTable.visiblity(gone: true)
//        } else {
//            commentsTable.visiblity(gone: false)
//        }
        return carWashInfo!.comments!.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCommetsCell", for: indexPath) as! CustomCommetsCell
        let carwashCommets = carWashInfo?.comments?[indexPath.section]
        cell.commets.text = carwashCommets?.text
        cell.rating.rating = Double(exactly: (carwashCommets?.rating)!)!
        cell.date.text = utils.milisecondsToDateB(miliseconds: (carwashCommets?.dateCreated)!)
        cell.user.text = carwashCommets?.firstName
    
        if let userImage = carwashCommets?.avatarURL {
            cell.userImage.downloaded(from: userImage)
        }
        
        return cell
    }
    func getCarWashInfo(){
   
    //                self.logoCarWash!.sd_setImage(with: URL(string: (cWbody?.logoURL)!), placeholderImage: UIImage(named: "carWashLogo.png"))
        self.nameCarWash.text = carWashInfo?.name
        self.adressCW.text = carWashInfo?.address
        self.raiting.rating = (carWashInfo?.rating?.rating)!
        self.descriptionText.text = carWashInfo?.descriptionCWB
//        self.statusLable.text = carWashInfo.
       
        
    }
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        let count = carWashInfo?.media?.count
        return count!
    }
   
    
//    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
//        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
//        let carWashMedia = carWashInfo?.media![index]
//        cell.imageView?.downloaded(from: (carWashMedia?.url)!)
//        cell.imageView?.contentMode = .scaleAspectFill
//        cell.imageView?.clipsToBounds = true
//        return cell
//    }
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    func pagerView(_ pagerView: FSPagerView, shouldSelectItemAt index: Int) -> Bool {
        return true
    }
    
    
    func showDialog(_ animationPattern: LSAnimationPattern) {
        let dialogViewController = CommentsDialog(nibName: "AddCommentsCastom", bundle: nil)
        dialogViewController.delegate = self
        
        presentDialogViewController(dialogViewController, animationPattern: animationPattern)
    }
    
    func dismissDialog(chouse: Bool) {
        dismissDialogViewController(LSAnimationPattern.fadeInOut)
        if chouse == true {
            getCarWashInfoComments()
            self.commentsTable.isHidden = false
//            var contentSizeTemp = commentsTable.contentSize
//            contentSizeTemp.height = 449
//            self.commentsTable.contentSize = contentSizeTemp
        }
        
    }
    @objc func showImage() {
        var imagelist = [String]()
        for media in (carWashInfo?.media)!{
            imagelist.append(media.url!)
        }
        
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "imageShow") as! ImageShow
       customAlert.imageList = imagelist
    customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        self.present(customAlert, animated: true, completion: nil)
        
    }
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    func Dismiss(filterListId: [String], filterOn: Bool) {
        
//        serviceSelect = filterListId
//        checkCarInfo()
    }
    
    func getMyComment(){
        guard utils.getSharedPref(key: "accessToken") != nil else{
           
            stopAnimating()
            return
        }
        let carWashId: String = (carWashInfo?.businessID)!
        startAnimating()
        let restUrl = constants.startUrl + "karma/v1/business/\(carWashId)/comment/current-user"
        let headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]
        Alamofire.request(restUrl, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response  in
            guard response.response?.statusCode != 200 else{
                self.buttonView.visiblity(gone: true)
                self.buttonView.isHidden = true
                self.view.layoutIfNeeded()
               
                self.stopAnimating()
                return
            }
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
          
            
            
            self.stopAnimating()
        }
    }
    func getCarWashInfoComments(){
        
        let headers = ["Application-Id":self.constants.iosId]
        let restUrl = constants.startUrl + "karma/v1/business/full-model-by-id?id=\((carWashInfo?.id)!)"
        Alamofire.request(restUrl, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            do{
                let responseBody = try JSONDecoder().decode(CarWashBody.self, from: response.data!)
                self.utils.setCarWashBody(key: "CARWASHBODY", value: responseBody)
                self.viewDidLoad()
                self.commentsTable.reloadData()
                self.commentsTable.invalidateIntrinsicContentSize()
            } catch{
                
            }
            
            self.stopAnimating()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
//        guard utils.getSharedPref(key: "accessToken") != nil else{
//            self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
//            self.sideMenuViewController!.hideMenuViewController()
//
//            self.utils.checkFilds(massage: "Авторизируйтесь", vc: self.view)
//            stopAnimating()
//            return
//        }
        if carWashInfo?.comments?.count == 0 || carWashInfo?.comments == nil{
            commentsTable.isHidden = true
            
            self.view.layoutIfNeeded()
        } else{
            commentsTable.isHidden = false
            
            self.view.layoutIfNeeded()
        }
      
//
    }
    
    func showTutorial() {
        let infoDesc = InfoDescriptor(for: "Выбрав компанию, Вы можете ознакомиться информацией о ней, доступными услугами, прайсом и сделать заказ ")
        var infoTask = PassthroughTask(with: [])
        infoTask.infoDescriptor = infoDesc
        
        
//        let leftDesc = LabelDescriptor(for: "Чтобы добавить коментарий нажмите сюда")
//        leftDesc.position = .bottom
//        let leftHoleDesc = HoleViewDescriptor(view: addCommentsBtn, type: .rect(cornerRadius: 5, margin: 10))
//        leftHoleDesc.labelDescriptor = leftDesc
//        let rightLeftTask = PassthroughTask(with: [leftHoleDesc])
        
        
        let leftDesc1 = LabelDescriptor(for: "Нажав на эту кнопку, вы сможете перейти к услугам и сделать заказ")
        leftDesc1.position = .bottom
        let leftHoleDesc1 = HoleViewDescriptor(view: goToOrders, type: .rect(cornerRadius: 5, margin: 10))
        leftHoleDesc1.labelDescriptor = leftDesc1
        let rightLeftTask1 = PassthroughTask(with: [leftHoleDesc1])
        
//        let buttonItemView = addCarItem.value(forKey: "view") as? UIView
//        let leftDesc2 = LabelDescriptor(for: "Чтобы увидеть время работы нажмите сюда")
//        leftDesc2.position = .bottom
//        let leftHoleDesc2 = HoleViewDescriptor(view: timeImage, type: .circle)
//        leftHoleDesc2.labelDescriptor = leftDesc2
//        let rightLeftTask2 = PassthroughTask(with: [leftHoleDesc2])
        
        
        
        PassthroughManager.shared.display(tasks: [infoTask, rightLeftTask1]) {
            isUserSkipDemo in
            
            print("isUserSkipDemo: \(isUserSkipDemo)")
        }
    }
    @objc func showWorkTime(){
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "workingTimeDialog") as! WorkingTimeDialog
        customAlert.carWashInfo = carWashInfo
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        self.present(customAlert, animated: true, completion: nil)
    }
//    func timeShow(){
//            var nowDay = ""
//            let timeDate = Date().dayNumberOfWeek()
//            switch timeDate{
//            case 3:
//                nowDay = "TUESDAY"
//                break
//            case 5:
//                nowDay = "THURSDAY"
//                break
//            case 2:
//                nowDay = "MONDAY"
//                break
//            case 7:
//                nowDay = "SATURDAY"
//                break
//            case 1:
//                nowDay = "SUNDAY"
//                break
//            case 6:
//                nowDay = "FRIDAY"
//                break
//            case 4:
//                nowDay = "WEDNESDAY"
//                break
//            default:
//                break
//            }
//        
//        for day in (carWashInfo?.workTimes)! {
//            if day.isWork! == true , day.dayOfWeek! == nowDay{
//                let timeNow = self.utils.currentTimeInMiliseconds(timeZone: (self.carWashInfo?.timeZone)!)
//                if timeNow > day.from!, timeNow < day.to!{
//                    isWorkLable.text = "работает"
//                    isWorkLable.textColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
//                }else{
//                    isWorkLable.text = "закрыто"
//                    isWorkLable.textColor = .red
//                }
//                
//            }
//        }
//    }
    
    func getProfTime(day: WorkTime, start: UILabel){
        if day.isWork == true {
            start.text = utils.milisecondsToTime(miliseconds: day.from!, timeZone: (carWashInfo?.timeZone)!) + " - " + utils.milisecondsToTime(miliseconds: day.to!, timeZone: (carWashInfo?.timeZone)!)
//            end.text = utils.milisecondsToTime(miliseconds: day.to!, timeZone: (carWashInfo?.timeZone)!)
        }else {
            start.text = "Выходной"
        }
    }
    
    func timeShow(){
        for day in (carWashInfo?.workTimes)! {
            switch day.dayOfWeek{
            case "TUESDAY":
                getProfTime(day: day, start: self.tuTime)
                break
            case "THURSDAY":
                getProfTime(day: day, start: self.thTime)
                break
            case "MONDAY":
                getProfTime(day: day, start: self.mnTime)
                break
            case "SATURDAY":
                getProfTime(day: day, start: self.stTime)
                break
            case "SUNDAY":
                getProfTime(day: day, start: self.snTime)
                break
            case "FRIDAY":
                getProfTime(day: day, start: self.frTime)
                break
            case "WEDNESDAY":
                getProfTime(day: day, start: self.wnTime)
                break
            default:
                break
            }
        }
    }
    
   
}
