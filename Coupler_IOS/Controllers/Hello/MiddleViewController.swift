//
//  MiddleViewController.swift
//  Coupler_IOS
//
//  Created by macbook on 16/08/2019.
//  Copyright © 2019 Coupler. All rights reserved.
//

import UIKit

protocol MiddleDismissDelegate: class {
    func MiddleDismiss(next: Bool)
}

class MiddleViewController: UIViewController {

  
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var pagerView: UIPageControl!
    
    let utils = Utils()
    var vc = UIViewController()
    var index : Int = 1
    var delegate : MiddleDismissDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        utils.setBorder(view: bottomView, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
        pagerView.currentPage = index
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func next(_ sender: Any) {
        delegate?.MiddleDismiss(next: true)
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func back(_ sender: Any) {
        delegate?.MiddleDismiss(next: false)
        dismiss(animated: true, completion: nil)
        
    }
}
