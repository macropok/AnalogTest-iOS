//
//  CheckOutCell.swift
//  AnalogBridge
//
//  Created by PSIHPOK on 12/29/16.
//  Copyright © 2016 Marco. All rights reserved.
//

import UIKit

class CheckOutCell: UITableViewCell {

    
    @IBOutlet weak var checkOutButton: UIButton!
    @IBOutlet weak var sumLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        checkOutButton.layer.cornerRadius = 4
        checkOutButton.layer.masksToBounds = true
    }
}
