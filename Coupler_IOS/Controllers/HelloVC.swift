//
//  HelloVC.swift
//  Coupler_IOS
//
//  Created by macbook on 19/08/2019.
//  Copyright © 2019 Coupler. All rights reserved.
//

import UIKit

protocol HelloDismissDelegate: class {
    func helloDismiss()
}
class HelloVC: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate  {
    
    // The UIPageViewController
    var pageContainer: UIPageViewController!
    
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    // The custom UIPageControl
    @IBOutlet weak var pageControl: UIPageControl!
    
    // The pages it contains
    var pages = [UIViewController]()
    
    // Track the current index
    var delegate : HelloDismissDelegate?
    var currentIndex: Int? = 0
    private var pendingIndex: Int? = 0
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.firstIndex(of: viewController)
        if currentIndex == 0 {
            return nil
        }
        let previousIndex = abs((currentIndex! - 1) % pages.count)
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.firstIndex(of: viewController)
        if currentIndex == pages.count-1 {
            return nil
        }
        let nextIndex = abs((currentIndex! + 1) % pages.count)
        return pages[nextIndex]
    }
    
    @IBAction func next(_ sender: Any) {
        pendingIndex = pendingIndex! + 1
        let arr: [UIViewController] = [pages[pendingIndex!]]
        pageContainer.setViewControllers(arr, direction:.forward, animated: true, completion: nil)
        pageContainer.delegate?.pageViewController?(pageContainer, didFinishAnimating: true, previousViewControllers: [pages[pendingIndex!]], transitionCompleted: true)
    }
    @IBAction func end(_ sender: Any) {
        self.delegate?.helloDismiss()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func back(_ sender: Any) {
        pendingIndex = pendingIndex! - 1
        let arr: [UIViewController] = [pages[pendingIndex!]]
        pageContainer.setViewControllers(arr, direction:.reverse, animated: true, completion: nil)
        pageContainer.delegate?.pageViewController?(pageContainer, didFinishAnimating: true, previousViewControllers: [pages[pendingIndex!]], transitionCompleted: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let page1: UIViewController! = storyboard.instantiateViewController(withIdentifier: "page1")
        let page2: UIViewController! = storyboard.instantiateViewController(withIdentifier: "page2")
        let page3: UIViewController! = storyboard.instantiateViewController(withIdentifier: "page3")
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        // Create the page container
        pageContainer = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageContainer.delegate = self
        pageContainer.dataSource = self
        pageContainer.setViewControllers([page1], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        
        // Add it to the view
        contentView.addSubview(pageContainer.view)
        //        contentView = pageContainer.view
        // Configure our custom pageControl
        view.bringSubviewToFront(pageControl)
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = pages.firstIndex(of: pendingViewControllers.first!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            if let index = currentIndex {
                pageControl.currentPage = index
            }
            switch currentIndex{
            case 0:
                backButton.isHidden = true
                endButton.isHidden = true
                nextButton.isHidden = false
                break
            case 1:
                backButton.isHidden = false
                endButton.isHidden = true
                nextButton.isHidden = false
                break
            case 2:
                backButton.isHidden = false
                endButton.isHidden = false
                nextButton.isHidden = true
                break
            default:
                break
            }
        }
    }
    
}

