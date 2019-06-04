//
//  CustomCommentsCell.swift
//  Karma
//
//  Created by macbook on 15/03/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//

import Foundation
import FloatRatingView

class CustomCommetsCell: UITableViewCell {
    
    @IBOutlet weak var rating: FloatRatingView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var commets: UILabel!
}
