//
//  CarWashInfo.swift
//  Karma
//
//  Created by macbook on 18/02/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import EHHorizontalSelectionView
import FloatRatingView


class CarWashInfo: UIViewController, UITableViewDataSource, FSPagerViewDelegate, FSPagerViewDataSource, NVActivityIndicatorViewable, UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate, FilterDialodDismissDelegate, ImageShowDismissDelegate, WorkingTimeDismissDelegate {
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
                let carWashMedia = carWashInfo?.media![index]
                cell.imageView?.downloaded(from: (carWashMedia?.url)!)
                cell.imageView?.contentMode = .scaleAspectFill
                cell.imageView?.clipsToBounds = true
                return cell
    }
    
  
    
   
    
    @IBOutlet weak var addCommentsBtn: UIButton!
    @IBOutlet weak var raiting: FloatRatingView!
    @IBOutlet weak var nameCarWash: UILabel!
    @IBOutlet weak var adressCW: UILabel!
    @IBOutlet weak var logoCarWash: UIImageView!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var imageScroll: FSPagerView!{
        didSet {
    self.imageScroll.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    @IBOutlet weak var commentsTable: UITableView!
    @IBOutlet weak var statusLable: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var buttonView: UIView!
    
    var carWashInfo: CarWashBody? = nil
    var carWashId: String = ""
    let utils = Utils()
    let constants = Constants()
    let showComments = false
    var isComment = false
    
    override func viewDidLoad() {
        
        utils.setBorder(view: headerView, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
        let swImage = UITapGestureRecognizer(target: self, action: #selector(showImage))
            
        swImage.delegate = self
        swImage.numberOfTapsRequired = 1
//        let swTime = UITapGestureRecognizer(target: self, action: #selector(showWorkTime))
//
//        swTime.delegate = self
//        swTime.numberOfTapsRequired = 1
//        workingTimes.addGestureRecognizer(swTime)
        imageScroll.addGestureRecognizer(swImage)
        commentsTable.tableFooterView = UIView()
        getCarWashInfo()
        getMyComment()
        super.viewDidLoad()
        imageScroll.transformer = FSPagerViewTransformer(type: .cubic)
        if carWashInfo?.media?.count == 0 {
            imageScroll.visiblity(gone: true)
        }
                // Do any additional setup after loading the view.
        
    }
    

  
    @IBAction func showTimes(_ sender: Any) {
        showWorkTime()
    }
    
    @IBAction func addComment(_ sender: Any) {
//        guard self.isComment != false else {
//            TinyToast.shared.show(message: "Вы уже оставляли комментарий", valign: .bottom, duration: .normal)
//            return
//        }
          showDialog(.slideLeftRight)
    }
    @IBAction func carWashOrder(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "orderWash") as! OrderWash
        vc.carWashInfo = self.carWashInfo
        navigationController?.pushViewController(vc, animated: true)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
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
        cell.date.text = utils.milisecondsToDate(miliseconds: (carwashCommets?.dateCreated)!)
        cell.user.text = (carwashCommets?.firstName)!
        
        
        return cell
    }
    func getCarWashInfo(){
   
    //                self.logoCarWash!.sd_setImage(with: URL(string: (cWbody?.logoURL)!), placeholderImage: UIImage(named: "carWashLogo.png"))
        self.nameCarWash.text = carWashInfo?.name
        self.adressCW.text = carWashInfo?.address
        self.raiting.rating = (carWashInfo?.rating?.rating)!
        self.descriptionText.text = carWashInfo?.description
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
        let carWashId: String = (carWashInfo?.businessID)!
        startAnimating()
        let restUrl = constants.startUrl + "karma/v1/business/\(carWashId)/comment/current-user"
        let headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!]
        Alamofire.request(restUrl, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response  in
            guard response.response?.statusCode != 200 else{
                self.buttonView.visiblity(gone: true)
               
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
        
        let headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!]
        let restUrl = constants.startUrl + "karma/v1/business/\( String((carWashInfo?.id)!))/full-model"
        Alamofire.request(restUrl, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            do{
                let responseBody = try JSONDecoder().decode(CarWashBody.self, from: response.data!)
                self.carWashInfo = responseBody
                self.viewDidLoad()
                self.commentsTable.reloadData()
                
            } catch{
                
            }
            
            self.stopAnimating()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        guard utils.getSharedPref(key: "accessToken") != nil else{
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "siginViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
            
            self.utils.checkFilds(massage: "Авторизируйтесь", vc: self.view)
            stopAnimating()
            return
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
    
    override func viewWillAppear(_ animated: Bool) {
        
//        utils.checkPushNot(vc: self)
    }
}
