//
//  PageView.swift
//  AnalogBridgeController
//
//  Created by PSIHPOK on 1/17/17.
//  Copyright © 2017 marco. All rights reserved.
//

import UIKit

class PageView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func layoutSubviews() {
        
        backgroundView.layer.cornerRadius = backgroundView.bounds.size.width / 2
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.borderWidth = 2
        backgroundView.layer.borderColor = UIColor(hex: "286792").cgColor
    }
    

}
