# AnalogBridgeController

AnalogBridgeController is a component which contains iOS project for demo. (https://analogbridge.io/demo)

```
pod 'AnalogBridgeController', '~> 0.1.0'
```

In your project, when you want to run this component, please add the code to appDelegate.

```
import AnalogBridgeController
AnalogBridgeRunner.sharedRunner.setDefaultPublicKey(key: "Public Key")
AnalogBridgeRunner.sharedRunner.run(window: window!)
```
