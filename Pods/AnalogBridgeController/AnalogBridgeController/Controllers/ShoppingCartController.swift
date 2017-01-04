//
//  ShoppingCartController.swift
//  AnalogBridge
//
//  Created by PSIHPOK on 12/29/16.
//  Copyright © 2016 Marco. All rights reserved.
//

import UIKit
import SDWebImage

class ShoppingCartController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var quantitySumLabel: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    var checkOutCell:CheckOutCell? = nil
    
    var checkOutCellPos:Int = 0
    var startProdPos:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarItem()
        self.navigationItem.title = "Analog Bridge"
        
        var sum:Int = 0
        
        APIService.sharedService.cartProducts = []
        for product in APIService.sharedService.products {
            if product.qty != 0 {
                APIService.sharedService.cartProducts.append(product)
                sum += product.qty
            }
        }
        
        for subView in cartTableView.subviews {
            if subView is UIScrollView {
                (subView as! UIScrollView).delaysContentTouches = false
                break
            }
        }
        cartTableView.delaysContentTouches = false
        setQuantitySumLabel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBadge(count: APIService.sharedService.cartCount)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cartCount = getCartProductsCount()
        if APIService.sharedService.estimateBox != nil && APIService.sharedService.estimateBox!.qty > 0 {
            return cartCount + 2
        }
        return cartCount + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cartCount = getCartProductsCount()
        
        if APIService.sharedService.estimateBox != nil && APIService.sharedService.estimateBox!.qty > 0 {
            checkOutCellPos = cartCount + 1
            startProdPos = 1
        }
        else {
            checkOutCellPos = cartCount
            startProdPos = 0
        }
        
        if indexPath.row == checkOutCellPos {
            let cell:CheckOutCell = tableView.dequeueReusableCell(withIdentifier: "checkOutCell", for: indexPath) as! CheckOutCell
            checkOutCell = cell
            
            cell.sumLabel.text = "$ " + String(format: "%.2f", getEstimateSum())
            cell.checkOutButton.addTarget(self, action: #selector(self.checkOut(sender:)), for: .touchUpInside)
            
            return cell
        }
        else if APIService.sharedService.estimateBox != nil && APIService.sharedService.estimateBox!.qty > 0 && indexPath.row == 0 {
            let cell:ShoppingCartCell = tableView.dequeueReusableCell(withIdentifier: "shoppingCartCell", for: indexPath) as! ShoppingCartCell
            
            cell.product = APIService.sharedService.estimateBox!
            cell.parentController = self
            
            cell.productImageView.sd_setImage(with: URL(string: cell.product.imageURL))
            cell.productName.text = cell.product.name
            cell.priceName.text = "$ " + String(format: "%.2f", cell.product.price) + " per " + cell.product.unitName
            cell.estValueField.text = String(cell.product.qty)
            
            cell.removeCartButton.addTarget(self, action: #selector(self.removeCart(sender:)), for: .touchUpInside)
            
            return cell
        }
        else if indexPath.row >= startProdPos {
            let cell:ShoppingCartCell = tableView.dequeueReusableCell(withIdentifier: "shoppingCartCell", for: indexPath) as! ShoppingCartCell
            
            cell.product = getCartProduct(index: indexPath.row - startProdPos)
            cell.parentController = self
            
            cell.productImageView.sd_setImage(with: URL(string: cell.product.imageURL))
            cell.productName.text = cell.product.name
            cell.priceName.text = "$ " + String(format: "%.2f", cell.product.price) + " per " + cell.product.unitName
            cell.estValueField.text = String(cell.product.qty)
            
            cell.removeCartButton.addTarget(self, action: #selector(self.removeCart(sender:)), for: .touchUpInside)
            
            return cell
        }
        else {
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func getEstimateSum() -> Double {
        var sum:Double = 0.0
        
        for product in APIService.sharedService.products {
            sum += product.price * Double(product.qty)
        }
        
        var estimateSum = 0.0
        if APIService.sharedService.estimateBox != nil {
            estimateSum = Double(APIService.sharedService.estimateBox!.qty) * APIService.sharedService.estimateBox!.price
            
            if sum <= estimateSum {
                return estimateSum
            }
            else {
                return sum
            }
        }
        
        return sum
    }
    
    func setQuantitySumLabel() {
        var sum = 0
        for product in APIService.sharedService.products {
            sum += product.qty
        }
        
        if APIService.sharedService.estimateBox != nil {
            sum += APIService.sharedService.estimateBox!.qty
        }
        
        quantitySumLabel.text = "Currently \(sum) items in cart"
    }
    
    func checkOut(sender:AnyObject) {
        let podBundle = Bundle(for: self.classForCoder)
        let bundleURL = podBundle.url(forResource: "AnalogBridgeController", withExtension: "bundle", subdirectory: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(url:bundleURL!))
        
        let checkoutController = storyboard.instantiateViewController(withIdentifier: "checkoutController")
        let navController:UINavigationController = UINavigationController(rootViewController: checkoutController)
        self.slideMenuController()?.changeMainViewController(navController, close: true)
    }
    
    func getCartProductsCount() -> Int {
        var sum = 0
        for product in APIService.sharedService.products {
            if product.qty != 0 {
                sum += 1
            }
        }
        
        return sum
    }
    
    func getCartProduct(index:Int) -> Product {
        print ("Get cart product called")
        var realIndex = 0
        var temp = 0
        while (temp < index + 1) {
            let product = APIService.sharedService.products[realIndex]
            if product.qty != 0 {
                temp += 1
            }
            realIndex += 1
        }
        
        print ("Get cart product ended")
        return APIService.sharedService.products[realIndex - 1]
    }
    
    func removeCart(sender:UIButton) {
        let cell:UITableViewCell = (sender.superview?.superview) as! UITableViewCell
        let indexPath = self.cartTableView.indexPath(for: cell)
        print (indexPath!.row)
        if indexPath == nil {
            return
        }
        
        if APIService.sharedService.estimateBox != nil && APIService.sharedService.estimateBox!.qty > 0 && indexPath!.row < startProdPos {
            startProdPos = 0
            APIService.sharedService.estimateBox!.qty = 0
            cartTableView.deleteRows(at: [indexPath!], with: .left)
            //cartTableView.reloadData()
            setQuantitySumLabel()
        }
        else {
            let product = getCartProduct(index: (indexPath?.row)! - startProdPos)
            APIService.sharedService.cartCount -= product.qty
            product.qty = 0
            product.currentQty = 0
            cartTableView.deleteRows(at: [indexPath!], with: .left)
            setQuantitySumLabel()
            self.setBadge(count: APIService.sharedService.cartCount)
        }
        
        checkOutCell?.sumLabel.text = "$ " + String(format: "%.2f", getEstimateSum())
    }

}
