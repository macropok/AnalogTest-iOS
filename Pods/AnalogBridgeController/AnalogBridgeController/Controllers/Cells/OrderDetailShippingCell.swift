//
//  OrderDetailShippingCell.swift
//  AnalogBridge
//
//  Created by PSIHPOK on 1/3/17.
//  Copyright © 2017 Marco. All rights reserved.
//

import UIKit

class OrderDetailShippingCell: UITableViewCell {

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
