//
//  SendBoxCell.swift
//  AnalogBridge
//
//  Created by PSIHPOK on 12/26/16.
//  Copyright © 2016 Marco. All rights reserved.
//

import UIKit

class SendBoxCell: UITableViewCell {

    @IBOutlet weak var buttonBackgroundView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        let selectedBackgroundView:UIView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = selectedBackgroundView
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        buttonBackgroundView.layer.cornerRadius = buttonBackgroundView.frame.size.height * 0.7 / 2
        buttonBackgroundView.layer.masksToBounds = true
    }
    
}
