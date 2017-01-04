//
//  OrderTotalCell.swift
//  AnalogBridge
//
//  Created by PSIHPOK on 12/31/16.
//  Copyright © 2016 Marco. All rights reserved.
//

import UIKit

class OrderTotalCell: UITableViewCell {

    @IBOutlet weak var orderSubTotal: UILabel!
    @IBOutlet weak var orderShipping: UILabel!
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
