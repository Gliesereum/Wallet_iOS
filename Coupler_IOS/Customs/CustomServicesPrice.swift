//
//  CustomServicesPrice.swift
//  Karma
//
//  Created by macbook on 22/02/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//

import Foundation
import UIKit

class CustomServicesPrice: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var minute: UILabel!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .none : .none
    }
}
