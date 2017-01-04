//
//  OrderLastCell.swift
//  AnalogBridge
//
//  Created by PSIHPOK on 12/31/16.
//  Copyright © 2016 Marco. All rights reserved.
//

import UIKit

class OrderLastCell: UITableViewCell {

    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var telephone: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var address1: UILabel!
    @IBOutlet weak var address2: UILabel!
    @IBOutlet weak var city: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
