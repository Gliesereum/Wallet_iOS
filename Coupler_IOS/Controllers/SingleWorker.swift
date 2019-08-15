//
//  SingleWorker.swift
//  Coupler_IOS
//
//  Created by macbook on 11/08/2019.
//  Copyright © 2019 Coupler. All rights reserved.
//

import UIKit
import FloatRatingView
import Alamofire


class SingleWorker: UIViewController, UITableViewDataSource, UITableViewDelegate, NVActivityIndicatorViewable, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var workerImage: UIImageView!
    @IBOutlet weak var workerName: UILabel!
    @IBOutlet weak var workerComments: UILabel!
    @IBOutlet weak var workerRating: FloatRatingView!
    @IBOutlet weak var workerPosition: UILabel!
    @IBOutlet weak var addCommentsView: UIView!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var addCommentsButton: UIButton!
    
    let utils = Utils()
    let constants = Constants()
    var worker : Worker?
    
    var delegate: WorkersListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMyComment()
        if worker?.comments?.count == 0 || worker?.comments == nil{
            commentsTableView.visiblity(gone: true)
        }
        utils.setBorder(view: addCommentsButton, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), borderWidth: 1, cornerRadius: 4)
        commentsTableView.rowHeight = UITableView.automaticDimension
        commentsTableView.allowsMultipleSelection = true
        commentsTableView.allowsMultipleSelectionDuringEditing = true
        workerName.text = (worker?.user?.firstName)! + " " + (worker?.user?.lastName)!
        workerPosition.text = worker?.position
        workerComments.text = "(\(( worker?.comments?.count)!))"
        workerRating.rating = (worker?.rating?.rating)!
        if let workerAvatar = worker?.user?.avatarURL{
            workerImage.downloaded(from: workerAvatar)
        }
        // Do any additional setup after loading the view.
    }
    
    func showDialog(_ animationPattern: LSAnimationPattern) {
        let dialogViewController = WorkerAddCommentsDialog(nibName: "AddCommentsByWorker", bundle: nil)
        dialogViewController.delegate = self
        
        presentDialogViewController(dialogViewController, animationPattern: animationPattern)
    }
    
    func dismissDialog(chouse: Bool) {
        dismissDialogViewController(LSAnimationPattern.fadeInOut)
        if chouse == true {
            getCarWashInfoComments()
        }
        
    }
    @IBAction func addComment(_ sender: Any) {
//        delegate?.DismissWorker(worker: worker!)
//        dismiss(animated: true, completion: nil)
         showDialog(.slideLeftRight)
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func numberOfSections(in tableView: UITableView) -> Int {
//        self.commentsCount.text = "(\(carWashInfo!.comments!.count))"
        //        if carWashInfo!.comments!.count == 0{
        //            commentsTable.visiblity(gone: true)
        //        } else {
        //            commentsTable.visiblity(gone: false)
        //        }
        if worker!.comments != nil{
            return worker!.comments!.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCommetsCellWorker", for: indexPath) as! CustomCommetsCellWorker
        let carwashCommets = worker?.comments?[indexPath.section]
        cell.commets.text = carwashCommets?.text
        cell.rating.rating = Double(exactly: (carwashCommets?.rating)!)!
        cell.date.text = utils.milisecondsToDateB(miliseconds: (carwashCommets?.dateCreated)!)
        cell.user.text = (carwashCommets?.firstName)!
        
        if let userImage = carwashCommets?.avatarURL {
            cell.userImage.downloaded(from: userImage)
        }
        
        return cell
    }
    
    func getMyComment(){
        guard utils.getSharedPref(key: "accessToken") != nil else{
            
            self.addCommentsView.visiblity(gone: true)
            stopAnimating()
            return
        }
        let carWashId: String = (worker?.id)!
        startAnimating()
        let restUrl = constants.startUrl + "karma/v1/worker/\(carWashId)/comment/current-user"
        let headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]
        Alamofire.request(restUrl, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response  in
            guard response.response?.statusCode != 200 else{
                self.addCommentsView.visiblity(gone: true)
                
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
        let restUrl = constants.startUrl + "karma/v1/worker/by-id?id=\((worker?.id)!)"
        Alamofire.request(restUrl, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            do{
                let responseBody = try JSONDecoder().decode(Worker.self, from: response.data!)
                self.worker = responseBody
                self.viewDidLoad()
                self.commentsTableView.reloadData()
                
            } catch{
                
            }
            
            self.stopAnimating()
        }
    }
}
