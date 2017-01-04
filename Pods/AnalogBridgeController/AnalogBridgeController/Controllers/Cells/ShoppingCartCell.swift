//
//  ShoppingCartCell.swift
//  AnalogBridge
//
//  Created by PSIHPOK on 12/29/16.
//  Copyright © 2016 Marco. All rights reserved.
//

import UIKit

class ShoppingCartCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var removeCartButton: UIButton!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var priceName: UILabel!
    @IBOutlet weak var estValueField: UITextField!
    @IBOutlet weak var estStepper: UIStepper!

    var product:Product!
    var parentController:ShoppingCartController!
    var inputField:UITextField? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        removeCartButton.layer.cornerRadius = 2
        removeCartButton.layer.masksToBounds = true
        removeCartButton.layer.borderColor = UIColor.gray.cgColor
        removeCartButton.layer.borderWidth = 2
        
        estStepper.maximumValue = 10000
        estStepper.value = Double(product.qty)
    }
    
    @IBAction func onStepperChanged(_ sender: Any) {
        
        if product.unitName != "box" {
            APIService.sharedService.cartCount -= product.qty
        }
        
        product.qty = Int(estStepper.value)
        estValueField.text = String(product.qty)
        self.parentController.setQuantitySumLabel()
        self.parentController.cartTableView.reloadData()

        if product.unitName != "box" {
            APIService.sharedService.cartCount += product.qty
        }
        self.parentController.setBadge(count: APIService.sharedService.cartCount)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        estValueField.isEnabled = false
        if product.unitName != "box" {
            APIService.sharedService.cartCount -= self.product.qty
        }
        
        let alertController = UIAlertController(title: "Quantity", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: {
            textField in
            
            textField.text = String(self.product.qty)
            textField.keyboardType = .numberPad
            self.inputField = textField
        })
        
        let estimateAction = UIAlertAction(title: "Set", style: .default, handler: {
            action in
            DispatchQueue.main.async {
                let textfield = alertController.textFields![0]
                if textfield.text != nil && textfield.text != "" {
                    self.estValueField.text = textfield.text
                    self.product.qty = Int(textfield.text!)
                    self.product.currentQty = 0
                }
                self.estValueField.isEnabled = true
                self.parentController.setQuantitySumLabel()
                self.parentController.cartTableView.reloadData()
                if self.product.unitName != "box" {
                    APIService.sharedService.cartCount += self.product.qty
                }
                self.parentController.setBadge(count: APIService.sharedService.cartCount)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            action in
            DispatchQueue.main.async {
                self.estValueField.isEnabled = true
                APIService.sharedService.cartCount += self.product.qty
                self.parentController.setBadge(count: APIService.sharedService.cartCount)
            }
        })
        
        alertController.addAction(estimateAction)
        alertController.addAction(cancelAction)
        
        self.parentController.present(alertController, animated: true, completion: nil)
        
        return false
    }
}
