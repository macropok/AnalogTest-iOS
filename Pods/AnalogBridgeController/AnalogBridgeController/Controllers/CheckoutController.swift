//
//  CheckoutController.swift
//  AnalogBridge
//
//  Created by PSIHPOK on 12/29/16.
//  Copyright © 2016 Marco. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import JGProgressHUD
import Stripe
import QuartzCore

class CheckoutController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var address1: UITextField!
    @IBOutlet weak var address2: UITextField!
    @IBOutlet weak var company: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var customInstruction: UITextView!
    
    @IBOutlet weak var paymentValue: UILabel!
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var billingZip: UITextField!
    @IBOutlet weak var expirationDate: UITextField!
    @IBOutlet weak var cvc: UITextField!
    @IBOutlet weak var submitOrderButton: UIButton!
    
    
    
    @IBOutlet weak var containerView: UIView!
    
    
    var hud:JGProgressHUD!
    var prevTextField:UITextField? = nil
    
    let states:[JSON] = [JSON(["short": "AL",
                               "name": "Alabama",
                               "country_code": "US"]),
                         JSON(["short": "AK",
                               "name": "Alaska",
                               "country_code": "US"]),
                         JSON(["short": "AS",
                               "name": "American Samoa",
                               "country_code": "US"]),
                         JSON(["short": "AZ",
                               "name": "Arizona",
                               "country_code": "US"]),
                         JSON(["short": "AR",
                               "name": "Arkansas",
                               "country_code": "US"]),
                         JSON(["short": "CA",
                               "name": "California",
                               "country_code": "US"]),
                         JSON(["short": "CO",
                               "name": "Colorado",
                               "country_code": "US"]),
                         JSON(["short": "CT",
                               "name": "Connecticut",
                               "country_code": "US"]),
                         JSON(["short": "DE",
                               "name": "Delaware",
                               "country_code": "US"]),
                         JSON(["short": "DC",
                               "name": "District of Columbia",
                               "country_code": "US"]),
                         JSON(["short": "FM",
                               "name": "Federated States of Micronesia",
                               "country_code": "US"]),
                         JSON(["short": "FL",
                               "name": "Florida",
                               "country_code": "US"]),
                         JSON(["short": "GA",
                               "name": "Georgia",
                               "country_code": "US"]),
                         JSON(["short": "GU",
                               "name": "Guam",
                               "country_code": "US"]),
                         JSON(["short": "HI",
                               "name": "Hawaii",
                               "country_code": "US"]),
                         JSON(["short": "ID",
                               "name": "Idaho",
                               "country_code": "US"]),
                         JSON(["short": "IL",
                               "name": "Illinois",
                               "country_code": "US"]),
                         JSON(["short": "IN",
                               "name": "Indiana",
                               "country_code": "US"]),
                         JSON(["short": "IA",
                               "name": "Iowa",
                               "country_code": "US"]),
                         JSON(["short": "KS",
                               "name": "Kansas",
                               "country_code": "US"]),
                         JSON(["short": "KY",
                               "name": "Kentucky",
                               "country_code": "US"]),
                         JSON(["short": "LA",
                               "name": "Louisiana",
                               "country_code": "US"]),
                         JSON(["short": "ME",
                               "name": "Maine",
                               "country_code": "US"]),
                         JSON(["short": "MH",
                               "name": "Marshall Islands",
                               "country_code": "US"]),
                         JSON(["short": "MD",
                               "name": "Maryland",
                               "country_code": "US"]),
                         JSON(["short": "MA",
                               "name": "Massachusetts",
                               "country_code": "US"]),
                         JSON(["short": "MI",
                               "name": "Michigan",
                               "country_code": "US"]),
                         JSON(["short": "MN",
                               "name": "Minnesota",
                               "country_code": "US"]),
                         JSON(["short": "MS",
                               "name": "Mississippi",
                               "country_code": "US"]),
                         JSON(["short": "MO",
                               "name": "Missouri",
                               "country_code": "US"]),
                         JSON(["short": "MT",
                               "name": "Montana",
                               "country_code": "US"]),
                         JSON(["short": "NE",
                               "name": "Nebraska",
                               "country_code": "US"]),
                         JSON(["short": "NV",
                               "name": "Nevada",
                               "country_code": "US"]),
                         JSON(["short": "NH",
                               "name": "New Hampshire",
                               "country_code": "US"]),
                         JSON(["short": "NJ",
                               "name": "New Jersey",
                               "country_code": "US"]),
                         JSON(["short": "NM",
                               "name": "New Mexico",
                               "country_code": "US"]),
                         JSON(["short": "NY",
                               "name": "New York",
                               "country_code": "US"]),
                         JSON(["short": "NC",
                               "name": "North Carolina",
                               "country_code": "US"]),
                         JSON(["short": "ND",
                               "name": "North Dakota",
                               "country_code": "US"]),
                         JSON(["short": "MP",
                               "name": "Northern Mariana Islands",
                               "country_code": "US"]),
                         JSON(["short": "OH",
                               "name": "Ohio",
                               "country_code": "US"]),
                         JSON(["short": "OK",
                               "name": "Oklahoma",
                               "country_code": "US"]),
                         JSON(["short": "OR",
                               "name": "Oregon",
                               "country_code": "US"]),
                         JSON(["short": "PW",
                               "name": "Palau",
                               "country_code": "US"]),
                         JSON(["short": "PA",
                               "name": "Pennsylvania",
                               "country_code": "US"]),
                         JSON(["short": "PR",
                               "name": "Puerto Rico",
                               "country_code": "US"]),
                         JSON(["short": "RI",
                               "name": "Rhode Island",
                               "country_code": "US"]),
                         JSON(["short": "SC",
                               "name": "South Carolina",
                               "country_code": "US"]),
                         JSON(["short": "SD",
                               "name": "South Dakota",
                               "country_code": "US"]),
                         JSON(["short": "TN",
                               "name": "Tennessee",
                               "country_code": "US"]),
                         JSON(["short": "TX",
                               "name": "Texas",
                               "country_code": "US"]),
                         JSON(["short": "UT",
                               "name": "Utah",
                               "country_code": "US"]),
                         JSON(["short": "VT",
                               "name": "Vermont",
                               "country_code": "US"]),
                         JSON(["short": "VI",
                               "name": "Virgin Islands",
                               "country_code": "US"]),
                         JSON(["short": "VA",
                               "name": "Virginia",
                               "country_code": "US"]),
                         JSON(["short": "WA",
                               "name": "Washington",
                               "country_code": "US"]),
                         JSON(["short": "WV",
                               "name": "West Virginia",
                               "country_code": "US"]),
                         JSON(["short": "WI",
                               "name": "Wisconsin",
                               "country_code": "US"]),
                         JSON(["short": "WY",
                               "name": "Wyoming",
                               "country_code": "US"]),
                         JSON(["short": "AE",
                               "name": "Armed Forces Europe, the Middle East, and Canada",
                               "country_code": "US"]),
                         JSON(["short": "AP",
                               "name": "Armed Forces Pacific",
                               "country_code": "US"]),
                         JSON(["short": "AA",
                               "name": "Armed Forces Americas (except Canada)",
                               "country_code": "US"])
                         ]
    
    var keyboardHeight:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        self.navigationItem.title = "Analog Bridge"
        registerKeyboardNotification()
        
        customInstruction.layer.borderColor = UIColor(hex: "c1c1c1").cgColor
        customInstruction.layer.borderWidth = 1.0
        customInstruction.layer.cornerRadius = 4.0
        customInstruction.layer.masksToBounds = true
        
        submitOrderButton.layer.cornerRadius = 4
        submitOrderButton.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBadge(count: APIService.sharedService.cartCount)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        
        APIService.sharedService.getCustomer(completion: {
            bSuccess in
            DispatchQueue.main.async {
                self.hud.dismiss()
            }
            if bSuccess == true {
                DispatchQueue.main.async {
                    self.setupWithCustomerInfo()
                }
            }
            else {
                self.showAlert(message: "Failed to get Customer information")
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
    
    func setupWithCustomerInfo() {
        if APIService.sharedService.customer == nil {
            return
        }
        
        firstName.text = getValidateString(json: APIService.sharedService.customer!["ship"], key: "first_name")
        lastName.text = getValidateString(json: APIService.sharedService.customer!["ship"], key: "last_name")
        emailAddress.text = getValidateString(json: APIService.sharedService.customer!["ship"], key: "email")
        phoneNumber.text = getValidateString(json: APIService.sharedService.customer!["ship"], key: "phone")
        address1.text = getValidateString(json: APIService.sharedService.customer!["ship"], key: "address1")
        address2.text = getValidateString(json: APIService.sharedService.customer!["ship"], key: "address2")
        company.text = getValidateString(json: APIService.sharedService.customer!["ship"], key: "company")
        city.text = getValidateString(json: APIService.sharedService.customer!["ship"], key: "city")
        zipCode.text = getValidateString(json: APIService.sharedService.customer!["ship"], key: "zip")
        
        let stateShort = getValidateString(json: APIService.sharedService.customer!["ship"], key: "state")
        for st in states {
            if st["short"].stringValue == stateShort {
                state.text = st["name"].stringValue
            }
        }
    }
    
    func getValidateString(json:JSON, key:String) -> String {
        if json[key] != nil {
            print ("\(key) - \(json[key].stringValue)")
            return json[key].stringValue
        }
        
        return ""
    }
    
    func keyboardShown(notification:Notification) {
        
        let info = notification.userInfo
        let kbSize = (info![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        keyboardHeight = (kbSize?.height)!
    }
    
    func keyboardWillBeHidden(notification:Notification) {
        
    }
    
    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShown(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func checkInputFields() -> Bool {
        
        if firstName.text == "" {
            showAlert(message: "First Name should be required.")
            return false
        }
        
        if lastName.text == "" {
            showAlert(message: "Last Name should be required.")
            return false
        }
        
        if cardNumber.text == "" {
            showAlert(message: "Card Number should be required.")
            return false
        }
        
        if billingZip.text == "" {
            showAlert(message: "Billing Zip should be required.")
            return false
        }
        
        if expirationDate.text == "" || expirationDate.text?.contains("/") == false {
            showAlert(message: "Expiration Date should be required with correct form.")
            return false
        }
        
        if cvc.text == "" {
            showAlert(message: "CVC should be required.")
            return false
        }
        
        return true
    }
    
    @IBAction func onSubmitOrder(_ sender: Any) {
        let bCheck = checkInputFields()
        if bCheck == false {
            return
        }
        
        hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        
        var bComplete:Bool = true
        var state = STPCardValidator.validationState(forNumber: cardNumber.text!, validatingCardBrand: false)
        if state != .valid {
            bComplete = false
            changeBorderColor(textfield: cardNumber, normal: false)
        }
        else {
            changeBorderColor(textfield: cardNumber, normal: true)
        }
        
        let exYear = expirationDate.text?.components(separatedBy: "/")[1]
        let exMon = expirationDate.text?.components(separatedBy: "/")[0]
        
        state = STPCardValidator.validationState(forExpirationYear: exYear!, inMonth: exMon!)
        if state != .valid {
            bComplete = false
            changeBorderColor(textfield: expirationDate, normal: false)
        }
        else {
            changeBorderColor(textfield: expirationDate, normal: true)
        }
        
        if (cvc.text?.characters.count)! > 4 {
            bComplete = false
            changeBorderColor(textfield: cvc, normal: false)
        }
        else {
            changeBorderColor(textfield: cvc, normal: true)
        }
        
        if bComplete == false {
            hud.dismiss()
            return
        }
        
        (APIService.sharedService.customer!["ship"])["first_name"].string = firstName.text!
        (APIService.sharedService.customer!["ship"])["last_name"].string = lastName.text!
        if company.text != nil {
            (APIService.sharedService.customer!["ship"])["company"].string = company.text!
        }
        if address1.text != nil {
            (APIService.sharedService.customer!["ship"])["address1"].string = company.text!
        }
        if address2.text != nil {
            (APIService.sharedService.customer!["ship"])["address1"].string = company.text!
        }
        if city.text != nil {
            (APIService.sharedService.customer!["ship"])["city"].string = company.text!
        }
        (APIService.sharedService.customer!["ship"])["state"].string = getShortStateName(stateName: self.state.text!)
        if zipCode.text != nil {
            (APIService.sharedService.customer!["ship"])["zip"].string = zipCode.text!
        }
        if phoneNumber.text != nil {
            (APIService.sharedService.customer!["ship"])["phone"].string = phoneNumber.text!
        }
        if emailAddress.text != nil {
            (APIService.sharedService.customer!["ship"])["email"].string = emailAddress.text!
        }
        
        print(APIService.sharedService.customer!.rawString()!)
        
        let cardParam:STPCardParams = STPCardParams()
        cardParam.number = cardNumber.text
        cardParam.expMonth = UInt(expirationDate.text!.components(separatedBy: "/")[0])!
        cardParam.expYear = UInt(expirationDate.text!.components(separatedBy: "/")[1])!
        cardParam.cvc = cvc.text
        cardParam.name = firstName.text! + " " + lastName.text!
        
        var totalCount = 0
        for product in APIService.sharedService.products {
            if product.qty > 0 {
                totalCount += product.qty
            }
        }
        
        if APIService.sharedService.estimateBox != nil {
            totalCount += APIService.sharedService.estimateBox!.qty
        }
        
        if totalCount == 0 {
            return
        }
        
        hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        APIService.sharedService.submitOrder(card: cardParam, completion: {
            bSuccess, message in
            if bSuccess == true {
                self.showSuccessController()
            }
            else {
                self.showAlert(message: message!)
            }
        })
    }
    
    func showSuccessController() {
        DispatchQueue.main.async {
            self.hud.dismiss()
            let podBundle = Bundle(for: self.classForCoder)
            let bundleURL = podBundle.url(forResource: "AnalogBridgeController", withExtension: "bundle", subdirectory: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle(url:bundleURL!))
            let successController = storyboard.instantiateViewController(withIdentifier: "orderSuccessController")
            let navController = UINavigationController(rootViewController: successController)
            self.slideMenuController()?.changeMainViewController(navController, close: true)
        }
    }
    
    func getShortStateName(stateName:String) -> String {
        for st in states {
            if st["name"].stringValue == stateName {
                return st["short"].stringValue
            }
        }
        
        return ""
    }
    
    func changeBorderColor(textfield: UITextField, normal:Bool) {
        if normal == false {
            textfield.layer.cornerRadius = 8.0
            textfield.layer.masksToBounds = true
            textfield.layer.borderColor = UIColor.red.cgColor
            textfield.layer.borderWidth = 1.0
        }
        else {
            textfield.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == state {
            
            if prevTextField != nil {
                prevTextField?.resignFirstResponder()
                customInstruction.resignFirstResponder()
            }
            
            var stateNameArray:[String] = []
            for st in states {
                stateNameArray.append(st["name"].stringValue)
            }
            
            var initialIndex:Int = 0
            if textField.text != "" {
                for st in states {
                    if st["name"].stringValue == textField.text {
                        break
                    }
                    initialIndex += 1
                }
            }
            
            ActionSheetMultipleStringPicker.show(withTitle: "Select State", rows: [
                stateNameArray
                ], initialSelection: [initialIndex], doneBlock: {
                    picker, indexes, values in
                    
                    let index:Int = indexes![0] as! Int
                    self.state.text = stateNameArray[index]
                    
                    return
            }, cancel: { ActionMultipleStringCancelBlock in return }, origin: textField)
            return false
        }
        
        prevTextField = textField
        let containerFrame = containerView.frame
        scrollView.contentSize = CGSize(width: containerFrame.size.width, height: containerFrame.size.height + keyboardHeight)
        let frame = textField.frame
        scrollView.setContentOffset(CGPoint(x: 0, y: frame.origin.y), animated: true)
        
        return true
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if textView.text == "Custom Instruction" {
            textView.text = ""
        }
        
        let containerFrame = containerView.frame
        scrollView.contentSize = CGSize(width: containerFrame.size.width, height: containerFrame.size.height + keyboardHeight)
        let frame = textView.frame
        scrollView.setContentOffset(CGPoint(x: 0, y: frame.origin.y), animated: true)
        
        return true
    }
    
    func showStatePickerView() {
        
    }
    
    func hideStatePickerView() {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        customInstruction.resignFirstResponder()
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Custom Instruction"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
