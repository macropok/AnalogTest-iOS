//
//  HowPageController.swift
//  AnalogBridgeController
//
//  Created by PSIHPOK on 1/17/17.
//  Copyright © 2017 marco. All rights reserved.
//

import UIKit

class HowPageController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var titleArray = [
        "Receive analog transfer box 2-5 business days after purchase",
        "Add your analog media to the box",
        "Ready package with included materials and pre-paid FedEx label",
        "Call FedEx for free pick-up or drop-off at a local FedEx Location",
        "In 2-3 weeks all media is digitized and available in this app",
        "Receive your precious originals back just as they were"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarItem()
        self.navigationItem.title = "Analog Bridge"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBadge(count: APIService.sharedService.cartCount)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let scrollSize = scrollView.bounds.size
        
        let podBundle = Bundle(for: self.classForCoder)
        let bundleURL = podBundle.url(forResource: "AnalogBridgeController", withExtension: "bundle", subdirectory: nil)
        
        for i in 0..<6 {
            let nib = UINib(nibName: "PageView", bundle: Bundle(url:bundleURL!))
            let contentView:PageView = nib.instantiate(withOwner: nil, options: nil)[0] as! PageView
            var imageName:String = String(format: "%d", i + 1)
            
            if i == 5 {
                imageName = "1"
            }
            
            contentView.bodyLabel.text = titleArray[i]
            contentView.imageView.image = UIImage(named: imageName, in: Bundle(url: bundleURL!), compatibleWith: nil)
            let frame = CGRect(x: CGFloat(i) * scrollSize.width, y: 0, width: scrollSize.width, height: scrollSize.height)
            contentView.frame = frame
            scrollView.addSubview(contentView)
        }
        
        scrollView.contentSize = CGSize(width: 6 * scrollSize.width, height: scrollSize.height)
        pageControl.currentPage = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let width = scrollView.bounds.size.width
        
        if offset.x < width / 2 {
            pageControl.currentPage = 0
        }
        else {
            pageControl.currentPage = Int((offset.x - width / 2) / width) + 1
        }
    }
}
