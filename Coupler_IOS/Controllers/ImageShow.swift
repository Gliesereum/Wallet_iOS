//
//  PacketsDialog.swift
//  Karma
//
//  Created by macbook on 29/03/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//

import UIKit

protocol ImageShowDismissDelegate: class {
    func Dismiss(filterListId: [String], filterOn: Bool)
}
class ImageShow: UIViewController, FSPagerViewDelegate, FSPagerViewDataSource, NVActivityIndicatorViewable, UIGestureRecognizerDelegate {
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let carWashMedia = imageList![index]
        cell.imageView?.downloaded(from: carWashMedia)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    @IBOutlet weak var imageScroll: FSPagerView!{
        didSet {
            self.imageScroll.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    var imageList: [String]?
    var delegate: ImageShowDismissDelegate?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        imageScroll.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageScroll.transformer = FSPagerViewTransformer(type: .zoomOut)
        // Do any additional setup after loading the view.
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(dissmis))
        
        tapGR.delegate = self
        tapGR.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGR)
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        let count = imageList!.count
        return count
    }
  
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    func pagerView(_ pagerView: FSPagerView, shouldSelectItemAt index: Int) -> Bool {
        return true
    }
    @objc func dissmis(){
        dismiss(animated: true, completion: nil)
    }
    
    
}
