
var delegate: CarWashInfo?//
//  CustomClassServicesTableViewCell.swift
//  Karma
//
//  Created by macbook on 14/01/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//

import Foundation
import UIKit
import RSSelectionMenu


class ClassServicesCell: UITableViewCell{
    @IBOutlet weak var classServicesNamesView: UILabel!
    @IBOutlet weak var idView: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // set data
    func setData(_ person: ClassServices) {
        
        idView.text = person.id.description
        classServicesNamesView.text = person.classServiceName
    }
}

class ClassServices: NSObject{
    
    var id: String
    var classServiceName: String
    
    init(id: String, classServiceName: String) {
        self.id = id
        self.classServiceName = classServiceName
    }
    
    // MARK: - UniquePropertyDelegate
    // Here id has the unique value for each person
    
    func uniquePropertyName() -> String {
        return "id"
    }
}
