//
//  CustomMarker.swift
//  Karma
//
//  Created by macbook on 24/01/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//

import Foundation
import UIKit

class CustomMarkers: UIView{
    @IBOutlet weak var infoMarkerImage: UIImageView!
    @IBOutlet weak var infoMarkerTitle: UILabel!
    @IBOutlet weak var infoMarkerSnipper: UILabel!
    @IBOutlet weak var viewSelf: UIView!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CustomMarker", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
protocol UIViewLoading {}
extension UIView : UIViewLoading {}

extension UIViewLoading where Self : UIView {
    
    // note that this method returns an instance of type `Self`, rather than UIView
    static func loadFromNib() -> Self {
        let nibName = "\(self)".split{$0 == "."}.map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
}
