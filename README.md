# AnalogTest-iOS

This is a demo project which use AnalogBridgeController.

When click 'Import Analog' button, the app gets customerToken and log in to service.
If log in success, the app present AnalogBridgeUI, else show error messages.

```
  func importAnalog(_ sender: Any) {
        let tokenURL = "TOKEN_URL"
        let publicKey = "PUBLIC KEY"
        
        let requestURL = URL(string:tokenURL)!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"

        let hud = JGProgressHUD(style: .dark)
        hud?.show(in: self.view)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            DispatchQueue.main.async {
                hud?.dismiss()
            }
            
            guard let _ = data, error == nil else {
                self.showAlert(message: "Unable to get Token")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                self.showAlert(message: "Unable to get Token")
                return
            }
            
            let customerToken = String(data: data!, encoding: .utf8)!
            
            AnalogBridgeRunner.sharedRunner.setAuthInfo(publicKey: publicKey, customerToken: customerToken, completion: {
                bSuccess, message in
                if bSuccess == true {
                    DispatchQueue.main.async {
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
```
