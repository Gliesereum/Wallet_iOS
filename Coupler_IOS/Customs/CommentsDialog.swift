//
//  CommentsDialog.swift
//  Karma
//
//  Created by macbook on 26/03/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//

import UIKit
import FloatRatingView
import Alamofire


class CommentsDialog: UIViewController, NVActivityIndicatorViewable, FloatRatingViewDelegate{
    
    var ratingText: Int = 12
    let constants = Constants()
    var delegate: CarWashInfo?
    let utils = Utils()


    @IBOutlet weak var rating: FloatRatingView!
    @IBOutlet weak var comments: UITextField!
    @IBOutlet weak var canselBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var frameY = CGFloat()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        comments.addDoneCancelToolbar()
        rating.type = .wholeRatings
        rating.delegate = self
//        view.bounds.size.height = UIScreen.main.bounds.size.height * 0.6
//        view.bounds.size.width = UIScreen.main.bounds.size.width * 0.8
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            frameY = self.view.frame.origin.y
//            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2
//            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != frameY {
            self.view.frame.origin.y = frameY
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func clouse(_ sender: Any) {
        
        self.view.endEditing(true)
        let carInfo: CarWashBody?
        delegate?.dismissDialog(chouse: false)
    }
    @IBAction func addComments(_ sender: Any) {
        
        self.view.endEditing(true)
        guard self.comments.text != "" else{
            utils.checkFilds(massage: "Введите комментарий", vc: self.view)
//            TinyToast.shared.show(message: "Введите комментарий", valign: .bottom, duration: .normal)
            return
        }
        guard ratingText != 12 else{
            utils.checkFilds(massage: "Выберите рейтинг", vc: self.view)
//            TinyToast.shared.show(message: "Выберите рейтинг", valign: .bottom, duration: .normal)
            return
        }
        addComments()
        
    }
    
    func addComments(){
        let carWashId: String = (delegate?.carWashInfo?.businessID)!
        startAnimating()
        let restUrl = constants.startUrl + "karma/v1/business/\(carWashId)/comment"
        let headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]
        let params: [String: Any]  = ["rating": ratingText, "text": comments.text]
       Alamofire.request(restUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response  in
        guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
            
        }
        stopAnimating()
        delegate?.dismissDialog(chouse: true)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        ratingText = Int(self.rating.rating)
    }
}
