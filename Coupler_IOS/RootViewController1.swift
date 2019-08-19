//
//  RootViewController.swift
//  AKSideMenuStoryboard
//
//  Created by Diogo Autilio on 6/9/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import UIKit
//import AKSideMenu

//public class RootViewController: AKSideMenu, AKSideMenuDelegate {

public class RootViewController: SideMenu, SideMenuDelegate {

    override public func awakeFromNib() {
//        super.awakeFromNib()
//        self.menuPreferredStatusBarStyle = .lightContent
//        self.contentViewShadowColor = .black
//        self.contentViewShadowOffset = CGSize(width: 0, height: 0)
//        self.contentViewShadowOpacity = 0.6
//        self.contentViewShadowRadius = 12
//        self.contentViewShadowEnabled = true
        self.menuPreferredStatusBarStyle = UIStatusBarStyle.lightContent
        self.contentViewShadowEnabled = true
        self.scaleMenuView = false
        self.scaleContentView = false
        self.scaleBackgroundImageView = false
        self.contentViewInPortraitOffsetCenterX = 120
        self.contentViewInLandscapeOffsetCenterX = 240

        self.delegate = self

//        if let storyboard = self.storyboard {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
            self.contentViewController = storyboard.instantiateViewController(withIdentifier: "contentViewController")
            self.leftMenuViewController = storyboard.instantiateViewController(withIdentifier: "leftMenuViewController")
//        }
//        let mainSB = UIStoryboard(name: "Main", bundle: nil);
//        self.contentViewController = mainSB.instantiateInitialViewController()
//
//        // Side Menu
//        let sideMenuSB = UIStoryboard(name: "SideMenu", bundle: nil);
//        self.leftMenuViewController = sideMenuSB.instantiateViewController(withIdentifier: "LeftTableNavigationController")
        self.rightMenuViewController = nil;
    }

    // MARK: - <AKSideMenuDelegate>

    public func sideMenu(sideMenu: SideMenu, willShowMenuViewController menuViewController: UIViewController) {
        print("willShowMenuViewController")
    }

    public func sideMenu(sideMenu: SideMenu, didShowMenuViewController menuViewController: UIViewController) {
        print("didShowMenuViewController")
    }

    public func sideMenu(sideMenu: SideMenu, willHideMenuViewController menuViewController: UIViewController) {
        print("willHideMenuViewController")
    }

    public func sideMenu(sideMenu: SideMenu, didHideMenuViewController menuViewController: UIViewController) {
        print("didHideMenuViewController")
    }
}
extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
       let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.tintColor = .black
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
   @objc func doneButtonTapped() { self.resignFirstResponder() }
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
extension UIView {
    
    func visiblity(gone: Bool, dimension: CGFloat = 0.0, attribute: NSLayoutConstraint.Attribute = .height) -> Void {
        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
            constraint.constant = gone ? 0.0 : dimension
//            self.layoutIfNeeded()
            self.isHidden = gone
        }
    }
}
extension UIViewController {
    func transitionVc(vc: UIViewController, duration: CFTimeInterval, type: CATransitionSubtype) {
        let customVcTransition = vc
        let transition = CATransition()
        transition.duration = duration
        transition.type = CATransitionType.push
        transition.subtype = type
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(customVcTransition, animated: false, completion: nil)
    }
    
}
extension Array where Element: AnyObject {
    mutating func remove2(_ object: AnyObject) {
        if let index = index(where: { $0 === object }) {
            remove(at: index)
        }
    }
}
extension UIImageView {
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
extension UITableView{
    override open var intrinsicContentSize: CGSize {
        return contentSize
    }
}


