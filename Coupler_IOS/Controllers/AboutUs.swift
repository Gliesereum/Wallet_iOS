//
//  AboutUs.swift
//  Coupler
//
//  Created by macbook on 26/04/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//

import UIKit
import MessageUI
import MaterialComponents

class AboutUs: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var versionLable: UILabel!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var webButton: UIButton!
    @IBOutlet weak var polityButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var apleButton: UIButton!
    
    let utils = Utils()
    override func viewDidLoad() {
        super.viewDidLoad()
        versionLable.text = "Версия: " + ((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!)
         utils.setBorder(view: mailButton, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
        utils.setBorder(view: termsButton, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
        utils.setBorder(view: webButton, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
        utils.setBorder(view: polityButton, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
        utils.setBorder(view: apleButton, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

   
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillAppear(_ animated: Bool) {
        
//        utils.checkPushNot(vc: self)
    }
    @IBAction func mail(_ sender: Any) {
        guard MFMailComposeViewController.canSendMail() else {
            utils.checkFilds(massage: "Почтовые сервисы не работают", vc: self.view)
            print("Mail services are not available")
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(["support@gliesereum.com"])
        composeVC.setSubject("Введите тему письма")
        composeVC.setMessageBody("Введите тело письма", isHTML: false)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
//        "support@gliesereum.com"
    }
    @IBAction func web(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://coupler.app/")!)
    }
    @IBAction func polity(_ sender: Any) { UIApplication.shared.open(URL(string: "https://coupler.app/policy")!)
        
    }
    @IBAction func terms(_ sender: Any) { UIApplication.shared.open(URL(string: "https://coupler.app/terms")!)
        
    }
    @IBAction func appStore(_ sender: Any) { UIApplication.shared.open(URL(string: "https://coupler.app/")!)
        
    }
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }

}
