//
//  FeaturesController.swift
//  AnalogBridge
//
//  Created by PSIHPOK on 12/27/16.
//  Copyright © 2016 Marco. All rights reserved.
//

import UIKit

class FeaturesController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarItem()
        self.navigationItem.title = "Analog Bridge"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBadge(count: APIService.sharedService.cartCount)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
