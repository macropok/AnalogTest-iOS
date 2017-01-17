//
//  FormatViewCell.swift
//  AnalogBridge
//
//  Created by PSIHPOK on 12/27/16.
//  Copyright © 2016 Marco. All rights reserved.
//

import UIKit
import QuartzCore

class FormatViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var estValueField: UITextField!
    @IBOutlet weak var productImageView: UIImageView!
    
    var inputField:UITextField? = nil
    var product:Product!
    var parentController:FormatController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        estValueField.attributedPlaceholder = NSAttributedString(string: "# Qty",
                                                               attributes: [NSForegroundColorAttributeName: UIColor.black])
        
        estValueField.layer.borderColor = UIColor.darkGray.cgColor
        estValueField.layer.borderWidth = 1.0
        estValueField.layer.cornerRadius = 5
    }

    @IBAction func onAddEstimate(_ sender: Any) {
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        estValueField.isEnabled = false
        
        let alertController = UIAlertController(title: "Estimate Quantity", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: {
            textField in
            
            if self.product.currentQty != 0 {
                textField.text = String(self.product.currentQty)
            }
            
            textField.keyboardType = .numberPad
            self.inputField = textField
        })
        
        let estimateAction = UIAlertAction(title: "Add To Estimate", style: .default, handler: {
            action in
            DispatchQueue.main.async {
                let textfield = alertController.textFields![0]
                if textfield.text != nil && textfield.text != "" {
                    self.estValueField.text = textfield.text
                    self.product.currentQty = Int(textfield.text!)
                    self.product.qty = self.product.qty + self.product.currentQty
                    
                    APIService.sharedService.cartCount += self.product.currentQty
                    self.parentController.setBadge(count: APIService.sharedService.cartCount)
                }
                self.estValueField.isEnabled = true
                self.parentController.showToast(message: "Items added successfully.")
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            action in
            DispatchQueue.main.async {
                self.estValueField.isEnabled = true
                self.parentController.showToast(message: "Adding items failed.")
            }
        })
        
        alertController.addAction(estimateAction)
        alertController.addAction(cancelAction)
        
        self.parentController.present(alertController, animated: true, completion: nil)
        
        return false
    }
}
