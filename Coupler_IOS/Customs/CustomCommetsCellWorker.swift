//
//  CustomCommetsCell.swift
//  Coupler_IOS
//
//  Created by macbook on 12/08/2019.
//  Copyright © 2019 Coupler. All rights reserved.
//

import Foundation
import UIKit
import FloatRatingView

class CustomCommetsCellWorker: UITableViewCell {
    
    @IBOutlet weak var rating: FloatRatingView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var commets: UILabel!
    @IBOutlet weak var userImage: UIImageView!
}
