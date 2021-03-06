//
//  OrderHistoryController.swift
//  AnalogBridge
//
//  Created by PSIHPOK on 12/31/16.
//  Copyright © 2016 Marco. All rights reserved.
//

import UIKit
import JGProgressHUD

class OrderHistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var historyTableView: UITableView!
    var hud:JGProgressHUD!
    var orders:[AnyObject]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        self.navigationItem.title = "Analog Bridge"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        
        historyTableView.delaysContentTouches = false
        
        APIService.sharedService.getCustomer(completion: {
            bSuccess in
            
            if bSuccess == true {
                DispatchQueue.main.async {
                    self.setBadge(count: APIService.sharedService.cartCount)
                    self.hud.dismiss()
                    self.historyTableView.reloadData()
                }
            }
            else {
                self.showAlert(message: "Get Customer Information Failed.")
            }
        })
    }
    
    func showAlert(message:String) {
        DispatchQueue.main.async {
            self.hud.dismiss()
            
            let alertController:UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okAction:UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return APIService.sharedService.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OrderHistoryCell = tableView.dequeueReusableCell(withIdentifier: "orderHistoryCell", for: indexPath) as! OrderHistoryCell
        
        let order:JSON = APIService.sharedService.orders[indexPath.row]
        
        cell.orderID.text = "#" + order["order_id"].stringValue
        cell.orderDate.text = order["order_date"].stringValue
        cell.orderTotal.text = APIService.getCurrencyString(fromS: order["total_amount"].stringValue)
        cell.orderStatus.text = order["status_name"].stringValue
        
        if order["pending"].intValue != 0 {
            cell.viewButton.backgroundColor = UIColor(hex: "FFCF05")
        }
        else {
            cell.viewButton.backgroundColor = UIColor(hex: "90C4F0")
        }
        
        cell.viewButton.addTarget(self, action: #selector(self.viewOrderDetail(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func viewOrderDetail(sender:UIButton) {
        let cell:UITableViewCell = (sender.superview)?.superview as! UITableViewCell
        let indexPath = historyTableView.indexPath(for: cell)
        if indexPath != nil {
            let podBundle = Bundle(for: self.classForCoder)
            let bundleURL = podBundle.url(forResource: "AnalogBridgeController", withExtension: "bundle", subdirectory: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle(url:bundleURL!))
            
            let detailController:OrderDetailController = storyboard.instantiateViewController(withIdentifier: "orderDetailController") as! OrderDetailController
            detailController.order = APIService.sharedService.orders[indexPath!.row]
            detailController.index = indexPath!.row
            let navController:UINavigationController = UINavigationController(rootViewController: detailController)
            self.slideMenuController()?.changeMainViewController(navController, close: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 151
    }
}
