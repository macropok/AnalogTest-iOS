//
//  OrderSuccessController.swift
//  AnalogBridge
//
//  Created by PSIHPOK on 12/31/16.
//  Copyright © 2016 Marco. All rights reserved.
//

import UIKit

class OrderSuccessController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var orderTableView: UITableView!
    var prodCount:Int = 0
    var order:JSON? = nil
    var products:[AnyObject] = []
    var bSuccess:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prodCount = getProductCount()
        order = APIService.sharedService.order
        products = order!["products"].arrayObject as! [AnyObject]
        
        setNavigationBarItem()
        self.navigationItem.title = "Analog Bridge"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIService.sharedService.clearData()
        setBadge(count: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func getProductCount() -> Int {
        if APIService.sharedService.order == nil {
            return 0
        }
        
        let productArray = APIService.sharedService.order!["products"].arrayObject as! [AnyObject]
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell:OrderOverviewCell = tableView.dequeueReusableCell(withIdentifier: "orderOverviewCell", for: indexPath) as! OrderOverviewCell
         
            cell.orderNumber.text = "\(order!["order_id"].intValue)"
            cell.orderDate.text = order!["order_date"].stringValue
            cell.orderTotalPaid.text = APIService.getCurrencyString(fromD: order!["paymentTotal"].doubleValue)
            
            return cell
        }
        else if indexPath.row <= prodCount {
            let cell:OrderDetailCell = tableView.dequeueReusableCell(withIdentifier: "orderDetailCell", for: indexPath) as! OrderDetailCell
            
            let product:JSON = JSON(products[indexPath.row - 1])
            
            cell.orderItem.text = product["description"].stringValue
            cell.orderQuantity.text = "\(product["quantity"].intValue)"
            cell.orderPrice.text = "$" + product["bridge_price"].stringValue + " per " + product["unit_name"].stringValue
            cell.orderTotal.text = APIService.getCurrencyString(fromS: product["total"].stringValue)
            
            return cell
        }
        else if indexPath.row == prodCount + 1 {
            let cell:OrderTotalCell = tableView.dequeueReusableCell(withIdentifier: "orderTotalCell", for: indexPath) as! OrderTotalCell
            
            cell.orderSubTotal.text = APIService.getCurrencyString(fromS: order!["total_no_shipping"].stringValue)
            cell.orderShipping.text = APIService.getCurrencyString(fromS: order!["shipping_amount"].stringValue)
            cell.orderTotal.text = APIService.getCurrencyString(fromS: order!["total_amount"].stringValue)
            
            return cell
        }
        else if indexPath.row == prodCount + 2 {
            let cell:OrderLastCell = tableView.dequeueReusableCell(withIdentifier: "orderLastCell", for: indexPath) as! OrderLastCell
            
            let ship:JSON = order!["ship"] as JSON
            
            cell.email.text = ship["ship_email"].stringValue
            cell.telephone.text = ship["ship_phone"].stringValue
            cell.name.text = ship["ship_first_name"].stringValue + " " + ship["ship_last_name"].stringValue
         
            var array:[UILabel] = []
            array.append(cell.company)
            array.append(cell.address1)
            array.append(cell.address2)
            array.append(cell.city)
            
            var lastIndex = 0
            
            if ship["ship_company"] == nil || ship["ship_company"].stringValue == "" {
                lastIndex = 0
            }
            else {
                cell.company.text = ship["ship_company"].stringValue
                lastIndex += 1
            }
            
            let address1:UILabel = array[lastIndex]
            address1.text = ship["ship_address1"].stringValue
            lastIndex += 1
            
            if ship["ship_address2"] == nil || ship["ship_address2"].stringValue == "" {
                
            }
            else {
                let address2:UILabel = array[lastIndex]
                address2.text = ship["ship_address2"].stringValue
                lastIndex += 1
            }
            
            let city:UILabel = array[lastIndex]
            city.text = ship["ship_city"].stringValue + ", " + ship["ship_state"].stringValue + " " + ship["ship_zip"].stringValue
            
            if lastIndex == 1 {
                cell.address2.isHidden = true
                cell.city.isHidden = true
            }
            else if lastIndex == 2 {
                cell.city.isHidden = true
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prodCount + 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 180
        }
        else if indexPath.row <= prodCount {
            return 108
        }
        else if indexPath.row == prodCount + 1 {
            return 86
        }
        else {
            return 715
        }
    }
}
