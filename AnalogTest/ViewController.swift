//
//  ViewController.swift
//  AnalogTest
//
//  Created by PSIHPOK on 1/4/17.
//  Copyright © 2017 marco. All rights reserved.
//

import UIKit
import AnalogBridgeController
import JGProgressHUD

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func importAnalog(_ sender: Any) {
        let tokenURL = "https://analogbridge.io/analog/customer/token"
        let publicKey = "pk_test_eY7kL6QyHG3tNUHbmLdDYWWN"
        
        let requestURL = URL(string:tokenURL)!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"

        let hud = JGProgressHUD(style: .dark)
        hud?.show(in: self.view)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            guard let _ = data, error == nil else {
                DispatchQueue.main.async {
                    hud?.dismiss()
                }
                self.showAlert(message: "Unable to get Token")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                DispatchQueue.main.async {
                    hud?.dismiss()
                }
                self.showAlert(message: "Unable to get Token")
                return
            }
            
            let customerToken = String(data: data!, encoding: .utf8)!
            
            AnalogBridgeRunner.sharedRunner.setAuthInfo(publicKey: publicKey, customerToken: customerToken, completion: {
                bSuccess, message in
                if bSuccess == true {
                    DispatchQueue.main.async {
                        hud?.dismiss()
                        AnalogBridgeRunner.sharedRunner.runFrom(controller: self)
                    }
                }
                else {
                    self.showAlert(message: message)
                }
            })
        })
        task.resume()
    }

    func showAlert(message:String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

