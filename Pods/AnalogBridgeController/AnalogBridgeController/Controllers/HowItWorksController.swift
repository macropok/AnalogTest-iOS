//
//  HowItWorksController.swift
//  AnalogBridge
//
//  Created by PSIHPOK on 12/26/16.
//  Copyright © 2016 Marco. All rights reserved.
//

import UIKit

class HowItWorksController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarItem()
        self.navigationItem.title = "Analog Bridge"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBadge(count: APIService.sharedService.cartCount)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let screenWidth = UIScreen.main.bounds.size.width
        
        for i in 0..<6 {
            let tag = 5000 + i
            let view:UIView? = self.view.viewWithTag(tag)
            if view != nil {
                view!.layer.cornerRadius = screenWidth / 8
                view!.layer.masksToBounds = true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
