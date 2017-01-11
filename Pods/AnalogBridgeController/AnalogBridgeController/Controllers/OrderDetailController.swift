//
//  OrderDetailController.swift
//  AnalogBridge
//
//  Created by PSIHPOK on 1/3/17.
//  Copyright © 2017 Marco. All rights reserved.
//

import UIKit
import JGProgressHUD

class OrderDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var orderDetailLabel: UILabel!
    @IBOutlet weak var orderDetailTableView: UITableView!
    var order:JSON!
    var hud:JGProgressHUD!
    var index:Int!
    var approveRejectMessage:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarItem()
        self.navigationItem.title = "Analog Bridge"
        order = APIService.sharedService.orders[index]
        orderDetailLabel.text = "Order Detail #" + order["order_id"].stringValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return getRowsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let quoteIndex = getQuoteStatusCellIndex()
        let pendingIndex = getPendingCellIndex()
        let approveIndex = getApproveIndex()
        let lastIndex = getLastIndex()
        let count = getRowsCount()
        
        if indexPath.row == 0 {
            let cell:OrderDetailDateCell = tableView.dequeueReusableCell(withIdentifier: "orderDetailDateCell", for: indexPath) as! OrderDetailDateCell
            
            cell.detailDate.text = order["order_date"].stringValue
            cell.detailStatus.text = order["status_name"].stringValue
            
            return cell
        }
        else {
            if indexPath.row == quoteIndex {
                let cell:OrderDetailQuoteStatusCell = tableView.dequeueReusableCell(withIdentifier: "orderDetailQuoteStatusCell", for: indexPath) as! OrderDetailQuoteStatusCell
                
                cell.quoteStatus.text = order["estimate_title"].stringValue
                
                return cell
            }
            else if indexPath.row == pendingIndex {
                let cell:OrderDetailEstimateAmountCell = tableView.dequeueReusableCell(withIdentifier: "orderDetailEstimateAmountCell", for: indexPath) as! OrderDetailEstimateAmountCell
                
                cell.estimateAmount.text = APIService.getCurrencyString(fromS: order["total_amount"].stringValue)
                cell.approveButton.addTarget(self, action: #selector(self.approveOrder(sender:)), for: .touchUpInside)
                cell.rejectButton.addTarget(self, action: #selector(self.rejectOrder(sender:)), for: .touchUpInside)
                
                return cell
            }
            else if indexPath.row == approveIndex {
                let cell:OrderDetailQuoteAmountCell = tableView.dequeueReusableCell(withIdentifier: "orderDetailQuoteAmountCell", for: indexPath) as! OrderDetailQuoteAmountCell
                cell.quoteAmount.text = APIService.getCurrencyString(fromS: order["total_amount"].stringValue)
                cell.approveRejectMessage.text = approveRejectMessage
                
                return cell
            }
            else if indexPath.row == lastIndex {
                let cell:OrderDetailTotalPaidCell = tableView.dequeueReusableCell(withIdentifier: "orderDetailTotalPaidCell", for: indexPath) as! OrderDetailTotalPaidCell
                
                cell.totalPaid.text = APIService.getCurrencyString(fromD: order["paymentTotal"].doubleValue)
                
                return cell
            }
            else if indexPath.row == count - 1 {
                let cell:OrderDetailShippingCell = tableView.dequeueReusableCell(withIdentifier: "orderDetailShippingCell", for: indexPath) as! OrderDetailShippingCell
                
                cell.name.text = order["ship_first_name"].stringValue + " " + order["ship_last_name"].stringValue
                
                var array:[UILabel] = []
                array.append(cell.company)
                array.append(cell.address1)
                array.append(cell.address2)
                array.append(cell.city)
                
                var lastIndex = 0
                
                if order["ship_company"] == nil || order["ship_company"].stringValue == "" {
                    lastIndex = 0
                }
                else {
                    cell.company.text = order["ship_company"].stringValue
                    lastIndex += 1
                }
                
                let address1:UILabel = array[lastIndex]
                address1.text = order["ship_address1"].stringValue
                lastIndex += 1
                
                if order["ship_address2"] == nil || order["ship_address2"].stringValue == "" {
                    
                }
                else {
                    let address2:UILabel = array[lastIndex]
                    address2.text = order["ship_address2"].stringValue
                    lastIndex += 1
                }
                
                let city:UILabel = array[lastIndex]
                city.text = order["ship_city"].stringValue + ", " + order["ship_state"].stringValue + " " + order["ship_zip"].stringValue
                
                if lastIndex == 1 {
                    cell.address2.isHidden = true
                    cell.city.isHidden = true
                }
                else if lastIndex == 2 {
                    cell.city.isHidden = true
                }
                
                return cell
            }
            else if indexPath.row == count - 2 {
                let cell:OrderDetailCustomerDetailCell = tableView.dequeueReusableCell(withIdentifier: "orderDetailCustomerDetailCell", for: indexPath) as! OrderDetailCustomerDetailCell
                
                cell.email.text = order["ship_email"].stringValue
                cell.telephone.text = order["ship_phone"].stringValue
                
                return cell
            }
            else if indexPath.row == count - 3 {
                let cell:OrderDetailTotalCell = tableView.dequeueReusableCell(withIdentifier: "orderDetailTotalCell", for: indexPath) as! OrderDetailTotalCell
                
                cell.subTotal.text = APIService.getCurrencyString(fromS: order["total_no_shipping"].stringValue)
                cell.shipping.text = APIService.getCurrencyString(fromS: order["shipping_amount"].stringValue)
                cell.total.text = APIService.getCurrencyString(fromS: order["total_amount"].stringValue)
                
                return cell
            }
            else {
                let product:JSON = getProduct(index: indexPath.row - getLastIndex() - 1)
                let cell:OrderDetailItemCell = tableView.dequeueReusableCell(withIdentifier: "orderDetailItemCell", for: indexPath) as! OrderDetailItemCell
                
                cell.item.text = product["description"].stringValue
                cell.quantity.text = "\(product["quantity"].stringValue)"
                cell.price.text = product["price_per_unit"].stringValue
                cell.total.text = APIService.getCurrencyString(fromS: product["total"].stringValue)
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let quoteIndex = getQuoteStatusCellIndex()
        let pendingIndex = getPendingCellIndex()
        let approveIndex = getApproveIndex()
        let lastIndex = getLastIndex()
        let count = getRowsCount()
        
        if indexPath.row == 0 {
            return 66
        }
        else {
            if indexPath.row == quoteIndex {
                return 33
            }
            else if indexPath.row == pendingIndex {
                return 115
            }
            else if indexPath.row == approveIndex {
                if approveRejectMessage == "" {
                    return 33
                }
                
                return 66
            }
            else if indexPath.row == lastIndex {
                return 33
            }
            else if indexPath.row == count - 1 {
                return 154
            }
            else if indexPath.row == count - 2 {
                return 95
            }
            else if indexPath.row == count - 3 {
                return 91
            }
            else {
                return 116
            }
        }
    }
    
    func getRowsCount() -> Int {
        var number = 2
        
        if order["order_estimate_status_id"].boolValue == true {
            number += 1
        }
        
        if order["pending"].boolValue == true {
            number += 1
        }
/*
        if order["approved"].boolValue == true || order["rejected"].boolValue == true {
            number += 1
        }
*/ 
        
        number += getProducts() + 3
        return number
    }
    
    func getLastIndex() -> Int {
        var count = 1
        if order["order_estimate_status_id"].boolValue == true {
            count += 1
        }
        if order["pending"].boolValue == true {
            count += 1
        }
/*
        if order["approved"].boolValue == true || order["rejected"].boolValue == true {
            count += 1
        }
*/
        return count
    }
    
    func getApproveIndex() -> Int {
        if order["approved"].boolValue != true || order["rejected"].boolValue != true {
            return 0
        }
        
        var count = 1
        if order["order_estimate_status_id"].boolValue == true {
            count += 1
        }
        if order["pending"].boolValue == true {
            count += 1
        }
        
        return count
    }
    
    func getPendingCellIndex() -> Int {
        if order["pending"].boolValue != true {
            return 0
        }
        
        var count = 1
        if order["order_estimate_status_id"].boolValue == true {
            count += 1
        }
        
        return count
    }

    func getQuoteStatusCellIndex() -> Int {
        if order["order_estimate_status_id"].boolValue == true {
            return 1
        }
        return 0
    }

    func getProducts() -> Int {
        let products:[AnyObject] = order["products"].arrayObject as! [AnyObject]
        return products.count
    }
    
    func getProduct(index:Int) -> JSON {
        let products:[AnyObject] = order["products"].arrayObject as! [AnyObject]
        let product = JSON(products[index])
        return product
    }
    
    func approveOrder(sender:UIButton) {
        
        let cell:UITableViewCell? = sender.superview?.superview as? UITableViewCell
        if cell == nil {
            return
        }
        
        let indexPath = orderDetailTableView.indexPath(for: cell!)
        if indexPath == nil {
            return
        }
        
        let orderID:Int = order["order_id"].intValue
        
        hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        APIService.sharedService.approveOrder(orderId: orderID, completion: {
            bSuccess, message in
            DispatchQueue.main.async {
                self.hud.dismiss()
                self.index = APIService.sharedService.getOrderIndex(orderId: orderID)
                self.order = APIService.sharedService.orders[self.index]
                self.orderDetailTableView.reloadData()
                if bSuccess == false {
                    self.showAlert(message: message)
                }
                else {
                    APIService.sharedService.customer!["approvals"].int = APIService.sharedService.customer!["approvals"].intValue - 1
                    self.setNavigationBarItem()
                }
            }
        })
    }
    
    func rejectOrder(sender:UIButton) {
        let cell:UITableViewCell? = sender.superview?.superview as? UITableViewCell
        if cell == nil {
            return
        }
        
        let indexPath = orderDetailTableView.indexPath(for: cell!)
        if indexPath == nil {
            return
        }
        
        let orderID:Int = order["order_id"].intValue
        
        hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        APIService.sharedService.rejectOrder(orderId: orderID, completion: {
            bSuccess, message in
            DispatchQueue.main.async {
                self.hud.dismiss()
                self.index = APIService.sharedService.getOrderIndex(orderId: orderID)
                self.order = APIService.sharedService.orders[self.index]
                self.orderDetailTableView.reloadData()
                if bSuccess == false {
                    self.showAlert(message: message)
                }
                else {
                    APIService.sharedService.customer!["approvals"].int = APIService.sharedService.customer!["approvals"].intValue - 1
                    self.setNavigationBarItem()
                }
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
    
}
