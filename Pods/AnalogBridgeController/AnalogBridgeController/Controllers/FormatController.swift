//
//  FormatController.swift
//  AnalogBridge
//
//  Created by PSIHPOK on 12/26/16.
//  Copyright © 2016 Marco. All rights reserved.
//

import UIKit
import JGProgressHUD
import SDWebImage

enum FORMAT_TYPE {
    case image
    case film
    case video
}

class FormatController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var productArray:[Product]? = nil
    var hud:JGProgressHUD!
    var formatType:FORMAT_TYPE = FORMAT_TYPE.image
    
    @IBOutlet weak var productTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarItem()
        self.navigationItem.title = "Analog Bridge"
        
        for subView in productTableView.subviews {
            if subView is UIScrollView {
                (subView as! UIScrollView).delaysContentTouches = false
                break
            }
        }
        productTableView.delaysContentTouches = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBadge(count: APIService.sharedService.cartCount)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getProducts()
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
    
    func getProducts() {
        hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        
        APIService.sharedService.getProducts(completion: {
            array in
            
            self.productArray = array!
            
            for product in self.productArray! {
                product.currentQty = 0
            }
            
            DispatchQueue.main.async {
                self.productTableView.reloadData()
                self.goToFormat(type: self.formatType)
                self.hud.dismiss()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productArray == nil {
            return 0
        }
        else {
            return (productArray?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FormatViewCell = tableView.dequeueReusableCell(withIdentifier: "formatViewCell", for: indexPath) as! FormatViewCell
        let product:Product = productArray![indexPath.row]
        
        cell.product = product
        cell.parentController = self
        
        cell.productName.text = product.name
        cell.priceLabel.text = "$" + String(format: "%.2f", product.price) + " per " + product.unitName
        cell.productImageView.sd_setImage(with: URL(string: product.imageURL))
        if product.currentQty != 0 {
            cell.estValueField.text = String(product.currentQty)
        }
        else {
            cell.estValueField.text = ""
        }
        
        return cell
    }
    
    func goToFormat(type:FORMAT_TYPE) {
        if productArray == nil || productArray?.count == 0 {
            return
        }
        
        self.formatType = type
        
        var startIndex = 0
        var typeName:String = ""
        switch type {
        case .image:
            typeName = "image"
        case .film:
            typeName = "film"
        default:
            typeName = "video"
        }
        
        for product in productArray! {
            if product.typeName == typeName {
                break
            }
            startIndex += 1
        }
        
        let indexPath = IndexPath(row: startIndex, section: 0)
        self.productTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 313
    }
}
