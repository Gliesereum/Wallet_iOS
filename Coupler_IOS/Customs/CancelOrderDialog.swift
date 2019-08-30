//
//  CommentsDialog.swift
//  Karma
//
//  Created by macbook on 26/03/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//

import UIKit
import Alamofire


class CancelOrderDialog: UIViewController, NVActivityIndicatorViewable{
    
    let constants = Constants()
    var id : String?
    let utils = Utils()
    var delegate: SingleOrderVC?
    
    
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
        //        view.bounds.size.height = UIScreen.main.bounds.size.height * 0.6
        //        view.bounds.size.width = UIScreen.main.bounds.size.width * 0.8
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            frameY = self.view.frame.origin.y
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
        delegate?.dismissDialog(chouse: false)
    }
    @IBAction func addComments(_ sender: Any) {
        
        self.view.endEditing(true)
        guard self.comments.text != "" else{
            utils.checkFilds(massage: "Укажите причину по которой Вы отменяете заказ", vc: self.view)
            //            TinyToast.shared.show(message: "Введите комментарий", valign: .bottom, duration: .normal)
            return
        }
        cancelRecord()
        
    }
    @objc func cancelRecord(){
        startAnimating()
        let toDo: [String: Any]  = ["idRecord": id!, "message": (comments.text)!]
        let restUrl = constants.startUrl + "karma/v1/record/canceled-record"
        Alamofire.request(restUrl, method: .put, parameters: toDo, headers: ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.stopAnimating()
                return
            }
//            self.sideMenuViewController!.setContentViewController(contentViewController: UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "ordersTableViewController")), animated: true)
//            self.sideMenuViewController!.hideMenuViewController()
            
            self.view.endEditing(true)
            self.delegate?.dismissDialog(chouse: true)
            self.stopAnimating()
        }
    }
  
}
