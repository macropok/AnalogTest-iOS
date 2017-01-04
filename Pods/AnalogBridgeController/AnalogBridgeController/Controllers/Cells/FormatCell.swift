//
//  FormatCell.swift
//  AnalogBridge
//
//  Created by PSIHPOK on 12/26/16.
//  Copyright © 2016 Marco. All rights reserved.
//

import UIKit

class FormatCell: UITableViewCell {

    @IBOutlet weak var menuName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let selectedBackgroundView:UIView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = selectedBackgroundView
    }

}
