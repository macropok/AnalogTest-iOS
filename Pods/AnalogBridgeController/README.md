# AnalogBridgeController

AnalogBridgeController is a component which contains iOS project for demo. (https://analogbridge.io/demo)

```
pod 'AnalogBridgeController', '~> 0.2.0'
```

AnalogBridgeRunner provides sigleton instance.
When use this instance, you should set publicKey and customerToken.
Here is demo project. (https://github.com/macropok/AnalogTest-iOS)

```
AnalogBridgeRunner.sharedRunner.setAuthInfo(publicKey: publicKey, customerToken: customerToken, completion: {
                bSuccess, message in
                if bSuccess == true {
                    // present AnalogBridgeUI when login success
                    DispatchQueue.main.async {
                        AnalogBridgeRunner.sharedRunner.runFrom(controller: currentController)
                    }
                }
                else {
                    // process error when login failed
                }
            })
```
