//
//  OrderDetailDateCell.swift
//  AnalogBridge
//
//  Created by PSIHPOK on 1/3/17.
//  Copyright © 2017 Marco. All rights reserved.
//

import UIKit

class OrderDetailDateCell: UITableViewCell {

    @IBOutlet weak var detailDate: UILabel!
    @IBOutlet weak var detailStatus: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
