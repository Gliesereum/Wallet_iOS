//
//  OneNewsViewController.swift
//  Coupler_IOS
//
//  Created by macbook on 16/08/2019.
//  Copyright © 2019 Coupler. All rights reserved.
//

import UIKit

protocol ZeroDismissDelegate: class {
    func zeroDismiss()
}
class ZeroViewController: UIViewController {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var pagerView: UIPageControl!
    
    let utils = Utils()
    var index : Int = 0
    
    var vc = UIViewController()
    var delegate : ZeroDismissDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        utils.setBorder(view: bottomView, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
        pagerView.currentPage = index
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func next(_ sender: Any) {
        
        delegate?.zeroDismiss()
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

}
