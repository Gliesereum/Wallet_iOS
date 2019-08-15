//
//  WorkersListCell.swift
//  Coupler_IOS
//
//  Created by macbook on 11/08/2019.
//  Copyright © 2019 Coupler. All rights reserved.
//

import Foundation
import UIKit
import FloatRatingView
import MaterialComponents


class WorkersListCell: UITableViewCell{
    @IBOutlet weak var workerName: UILabel!
    @IBOutlet weak var workerRating: FloatRatingView!
    @IBOutlet weak var workerPosition: UILabel!
    @IBOutlet weak var workerButton: MDCButton!
    @IBOutlet weak var workerId: UILabel!
    @IBOutlet weak var workerCommentsCount: UILabel!
    @IBOutlet weak var workerImage: UIImageView!
    
}
