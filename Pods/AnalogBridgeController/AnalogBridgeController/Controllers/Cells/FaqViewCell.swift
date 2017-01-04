//
//  FaqViewCell.swift
//  AnalogBridge
//
//  Created by PSIHPOK on 12/28/16.
//  Copyright © 2016 Marco. All rights reserved.
//

import UIKit

class FaqViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
