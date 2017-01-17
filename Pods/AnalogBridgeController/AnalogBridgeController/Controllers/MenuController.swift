//
//  MenuController.swift
//  AnalogBridge
//
//  Created by PSIHPOK on 12/26/16.
//  Copyright © 2016 Marco. All rights reserved.
//

import UIKit

class MenuController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var menuTableView: UITableView!
    
    var formatController:UINavigationController!
    var faqViewController:UINavigationController!
    var featuresController:UINavigationController!
    var howItWorksController:UINavigationController!
    var cartController:UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setControllers()
    }

    func registerCells() {
        let podBundle = Bundle(for: self.classForCoder)
        let bundleURL = podBundle.url(forResource: "AnalogBridgeController", withExtension: "bundle", subdirectory: nil)
        menuTableView.register(UINib(nibName: "FormatCell", bundle: Bundle(url:bundleURL!)), forCellReuseIdentifier: "formatCell")
        menuTableView.register(UINib(nibName: "OtherCell", bundle: Bundle(url:bundleURL!)), forCellReuseIdentifier: "otherCell")
        menuTableView.register(UINib(nibName: "SendBoxCell", bundle: Bundle(url:bundleURL!)), forCellReuseIdentifier: "sendBoxCell")
    }
    
    func setControllers() {
        let podBundle = Bundle(for: self.classForCoder)
        let bundleURL = podBundle.url(forResource: "AnalogBridgeController", withExtension: "bundle", subdirectory: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(url:bundleURL!))
        let format = storyboard.instantiateViewController(withIdentifier: "formatController")
        formatController = UINavigationController(rootViewController: format)
        
        //let faq = storyboard.instantiateViewController(withIdentifier: "faqViewController")
        let faq = ExpandableTableViewController()
        faqViewController = UINavigationController(rootViewController: faq)
        
        let features = storyboard.instantiateViewController(withIdentifier: "featuresController")
        featuresController = UINavigationController(rootViewController: features)
        
        //let how = storyboard.instantiateViewController(withIdentifier: "howItWorksController")
        let how = storyboard.instantiateViewController(withIdentifier: "howPageController")
        howItWorksController = UINavigationController(rootViewController: how)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 3
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            let cell:OtherCell = tableView.dequeueReusableCell(withIdentifier: "otherCell", for: indexPath) as! OtherCell
            cell.menuName.text = "FORMATS"
            return cell
        }
        else if section == 1 {
            let cell:FormatCell = tableView.dequeueReusableCell(withIdentifier: "formatCell", for: indexPath) as! FormatCell
            switch row {
            case 0:
                cell.menuName.text = "PHOTOS/SLIDES/NEGATIVES"
                break
            case 1:
                cell.menuName.text = "8MM/SUPER8/16MM"
                break
            default:
                cell.menuName.text = "BETAMAX/VHS/HI-8/MINIDV"
                break
            }
            return cell
        }
        else if section == 2 {
            let cell:OtherCell = tableView.dequeueReusableCell(withIdentifier: "otherCell", for: indexPath) as! OtherCell
            switch row {
            case 0:
                cell.menuName.text = "HOW IT WORKS"
                break
            case 1:
                cell.menuName.text = "FEATURES"
                break
            default:
                cell.menuName.text = "FAQ'S"
                break
            }
            return cell
        }
        else {
            //let cell:SendBoxCell = tableView.dequeueReusableCell(withIdentifier: "sendBoxCell", for: indexPath) as! SendBoxCell
            let cell:OtherCell = tableView.dequeueReusableCell(withIdentifier: "otherCell", for: indexPath) as! OtherCell
            cell.menuName.text = "SEND BOX"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            self.slideMenuController()?.changeMainViewController(self.formatController, close: true)
        }
        else if section == 1 {
            let topController:FormatController = self.formatController.topViewController as! FormatController
            switch row {
            case 0:
                topController.formatType = .image
                self.slideMenuController()?.changeMainViewController(self.formatController, close: true)
                break
            case 1:
                topController.formatType = .film
                self.slideMenuController()?.changeMainViewController(self.formatController, close: true)
                break
            default:
                topController.formatType = .video
                self.slideMenuController()?.changeMainViewController(self.formatController, close: true)
                break
            }
        }
        else if section == 2 {
            switch row {
            case 0:
                self.slideMenuController()?.changeMainViewController(self.howItWorksController, close: true)
                break
            case 1:
                self.slideMenuController()?.changeMainViewController(self.featuresController, close: true)
                break
            default:
                self.slideMenuController()?.changeMainViewController(self.faqViewController, close: true)
                break
            }
        }
        else {
            if APIService.sharedService.estimateBox != nil {
                APIService.sharedService.estimateBox!.qty = APIService.sharedService.estimateBox!.qty + 1
            }
            
            let podBundle = Bundle(for: self.classForCoder)
            let bundleURL = podBundle.url(forResource: "AnalogBridgeController", withExtension: "bundle", subdirectory: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle(url:bundleURL!))
            
            let cart = storyboard.instantiateViewController(withIdentifier: "shoppingCartController")
            cartController = UINavigationController(rootViewController: cart)
            self.slideMenuController()?.changeMainViewController(self.cartController, close: true)
        }
    }
}

