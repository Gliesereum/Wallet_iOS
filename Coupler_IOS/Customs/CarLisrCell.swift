//
//  CarLisrCell.swift
//  Coupler_IOS
//
//  Created by macbook on 01/07/2019.
//  Copyright © 2019 Coupler. All rights reserved.
//

import Foundation


import UIKit
import MaterialComponents

class CarLisrCell: UITableViewCell {
    
    @IBOutlet weak var carId: UILabel!
    @IBOutlet weak var carInfoLable: UILabel!
    @IBOutlet weak var informationBtn: MDCButton!
    @IBOutlet weak var selectBtn: MDCButton!
    @IBOutlet weak var selectedLable: UILabel!
    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var carImage: UIImageView!
}
