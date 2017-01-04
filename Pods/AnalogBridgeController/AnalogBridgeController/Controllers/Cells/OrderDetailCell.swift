//
//  OrderDetailCell.swift
//  AnalogBridge
//
//  Created by PSIHPOK on 12/31/16.
//  Copyright © 2016 Marco. All rights reserved.
//

import UIKit

class OrderDetailCell: UITableViewCell {

    @IBOutlet weak var orderItem: UILabel!
    @IBOutlet weak var orderQuantity: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var orderTotal: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
