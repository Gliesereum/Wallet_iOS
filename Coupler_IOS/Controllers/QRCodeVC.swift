//
//  QRCodeVC.swift
//  Coupler_IOS
//
//  Created by macbook on 25/07/2019.
//  Copyright © 2019 Coupler. All rights reserved.
//

import UIKit

class QRCodeVC: UIViewController {

    @IBOutlet weak var imageQR: UIImageView!
    var url: String?
    override func viewDidLoad() {
        super.viewDidLoad()

//        let qrcode = DCQRCode(info: url!, size: CGSize(width: 340, height: 340))
//        imageQR.image = qrcode.image()
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
    @IBAction func shareButtonClicked(sender: AnyObject)
    {
        //Set the default sharing message.
        let message = "Coupler"
        //Set the link to share.
        if let link = NSURL(string: url!)
        {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }

}
