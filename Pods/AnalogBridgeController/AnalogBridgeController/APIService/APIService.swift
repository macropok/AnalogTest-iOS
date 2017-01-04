//
//  APIService.swift
//  AnalogBridge
//
//  Created by PSIHPOK on 12/27/16.
//  Copyright © 2016 Marco. All rights reserved.
//

import UIKit
import Stripe

public class Product {
    public var name:String!
    public var price:Double!
    public var imageURL:String!
    public var productID:Int!
    public var unitName:String!
    public var categoryName:String!
    public var productTypeID:Int!
    public var bridgeProductTypeID:Int!
    public var diplayHome:Int!
    public var typeName:String!
    public var qty:Int!
    public var currentQty:Int!
    public var jsonData:JSON!
    
    
    init() {
        name = ""
        price = 0.0
        imageURL = ""
        productID = 0
        unitName = ""
        categoryName = ""
        productTypeID = 0
        bridgeProductTypeID = 0
        diplayHome = 0
        typeName = ""
        qty = 0
        currentQty = 0
    }
}

public class Faq {
    public var question:String!
    public var answer:String!
    public var position:Int!
    
    init() {
        question = ""
        answer = ""
        position = 0
    }
}

public class APIService: NSObject {
    
    public static let sharedService:APIService = APIService()
    
    let apiURL = "https://api.analogbridge.io"
    var publicKey:String = ""
    
    var customerToken:String = ""
    
    var customer:JSON? = nil
    var customerObjStr:String? = nil
    
    var products:[Product] = []
    var cartProducts:[Product] = []
    var estimateBox:Product?
    
    var order:JSON? = nil
    
    var cartCount:Int = 0
    
    override init () {
        super.init()
    }
    
    func clearData() {
        customer = nil
        customerObjStr = nil
        products = []
        cartProducts = []
        estimateBox = nil
        order = nil
        cartCount = 0
    }
    
    func getApiURL(url:String) -> String {
        let retURL = apiURL + "/v1/" + url
        return retURL
    }
    
    func retriveCustomer(completion: @escaping (Bool, String) -> Void) {
        let authString = "{\"publicKey\":\"\(publicKey)\",\"customerToken\":\"\(customerToken)\"}"
        let url = "https://api.analogbridge.io/v1/customer/auth"
        self.sendPostRequest(url: url, body: authString, completionHandler: {
            data, response, error in
            guard let _ = data, error == nil else {
                completion(false, "NO_RESPONSE")
                return
            }
            
            let responseStr = String(data: data!, encoding: .utf8)!
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print(httpStatus.statusCode)
                print(responseStr)
                completion(false, responseStr)
                return
            }
            
            completion(true, responseStr)
        })
    }
    
    func getProducts(completion:@escaping ([Product]?) -> Void) {
        
        if products.count > 0 {
            completion(products)
            return
        }
        
        let url = getApiURL(url: "products/in")
        self.sendGetRequest(url: url, completionHandler: {
            data, response, error in
            
            guard let _ = data, error == nil else {
                completion(nil)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                completion(nil)
                return
            }
            
            let jsonData = JSON(data: data!)
            
            let array:[AnyObject] = jsonData["products"].arrayObject as! [AnyObject]
            
            self.products = []
            
            for itemData in array {
                let json = JSON(itemData)
                let item:Product = Product()
                item.name = json["name"].stringValue
                item.price = json["price"].doubleValue
                item.imageURL = json["thumb"].stringValue
                item.productID = json["product_id"].intValue
                item.categoryName = json["category_name"].stringValue
                item.unitName = json["unit_name"].stringValue
                item.productTypeID = json["product_type_id"].intValue
                item.diplayHome = json["display_home"].intValue
                item.bridgeProductTypeID = json["bridge_product_id"].intValue
                item.typeName = json["type_name"].stringValue
                item.jsonData = json
                
                if item.unitName == "box" {
                    self.estimateBox = item
                }
                else {
                    self.products.append(item)
                }
            }
            
            completion(self.products)
        })
    }
    
    func getCustomer(completion:@escaping (Bool) -> Void) {
        if customer != nil {
            completion(true)
        }
        
        let url = getApiURL(url: "customer")
        let authData = [
            "publicKey" : publicKey,
            "customerToken" : customerToken
        ]
        
        self.sendGetRequest(url: url, parameters: authData as [String : AnyObject], completionHandler: {
            data, response, error in
            
            guard let _ = data, error == nil else {
                completion(false)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                completion(false)
                return
            }
            
            self.customerObjStr = String(data: data!, encoding: .utf8)
            self.customer = JSON(data: data!)
            
            if self.customer == nil {
                completion(false)
            }
            else {
                completion(true)
            }
        })
    }
    
    func getCartCount() -> Int {
        var sum = 0
        for product in products {
            sum += product.qty
        }
        return sum
    }
    
    func getFaqs(completion:@escaping ([Faq]?) -> Void) {
        let url = getApiURL(url: "faqs")
        self.sendGetRequest(url: url, completionHandler: {
            data, response, error in
            
            guard let _ = data, error == nil else {
                completion(nil)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                completion(nil)
                return
            }
            
            let jsonData = JSON(data: data!)
            let array:[AnyObject] = jsonData.arrayObject as! [AnyObject]
            
            var faqArray:[Faq] = []
            
            for item in array {
                let json = JSON(item)
                let faq:Faq = Faq()
                faq.question = json["question"].stringValue
                faq.answer = json["answer"].stringValue
                faq.position = json["position"].intValue
                
                faqArray.append(faq)
            }
            
            completion(faqArray)
        })
    }
    
    func setDefaultPublicKey(key:String) {
        publicKey = key
        Stripe.setDefaultPublishableKey(publicKey)
    }
    
    func submitOrder(card:STPCardParams, completion:@escaping (Bool, String?) -> Void) {
        STPAPIClient.shared().createToken(withCard: card, completion: {
            cardObj, error in
            
            if cardObj == nil {
                completion(false, error?.localizedDescription)
            }
            else {
                let url = self.getApiURL(url: "customer/orders")
                let cardStr = self.getStringFromCard(card: cardObj!)
                let estStr = self.getEstimateStr()
                self.customerObjStr = self.customer!.rawString()
                
                let authStr:String = "{\"publicKey\":\"\(self.publicKey)\",\"card\":\(cardStr),\"customer\":\(self.customerObjStr!),\"estimate\":\(estStr)}"
                let auth:String = authStr.replacingOccurrences(of: "\\n", with: "", options: .regularExpression)
                print (auth)
                self.sendPostRequest(url: url, body: auth, completionHandler: {
                    data, response, error in
                    
                    guard let _ = data, error == nil else {
                        completion(false, "NO RESPONSE")
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 {
                        print (httpStatus.statusCode)
                        let jsonData = JSON(data: data!)
                        print (jsonData.rawString()!)
                        completion(false, "\(httpStatus.statusCode)")
                        return
                    }
                    
                    let jsonData = JSON(data: data!)
                    self.order = jsonData["data"] as JSON
                    
                    print (self.order!.rawString()!)
                    
                    completion(true, "Success")
                })
            }
        })
    }
    
    func getOrder(orderId:Int) -> JSON? {
        if customer == nil {
            return nil
        }
        
        let orders:[AnyObject] = customer!["orders"].arrayObject as! [AnyObject]
        for orderdata in orders {
            let order:JSON = JSON(orderdata)
            if order["order_id"].intValue == orderId {
                return order
            }
        }
        
        return nil
    }
    
    func updateOrderEstimate(orderId:Int, approve:Bool) {
        if customer == nil {
            return
        }
        
        var order:JSON? = getOrder(orderId: orderId)
        
        if order == nil {
            return
        }
        
        order!["rejected"].bool = false
        order!["approved"].bool = false
        order!["pending"].bool = false
        order!["estimate_status"].bool = true
        
        if approve == true {
            order!["estimate_title"].string = "Approved"
        }
        else {
            order!["estimate_title"].string = "Rejected"
        }
    }
    
    func approveOrder(orderId:Int, completion:@escaping (Bool, String) -> Void) {
        let url = getApiURL(url: "customer/orders/\(orderId)/approve-estimate")
        let authString = "{\"publicKey\":\"\(publicKey)\""
        sendPostRequest(url: url, body: authString, completionHandler: {
            data, response, error in
            guard let _ = data, error == nil else {
                completion(false, "NO RESPONSE")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print (httpStatus.statusCode)
                let jsonData = JSON(data: data!)
                print (jsonData.rawString()!)
                completion(false, "\(httpStatus.statusCode)")
                return
            }
            
            self.updateOrderEstimate(orderId: orderId, approve: true)
            let message = String(data: data!, encoding: .utf8)
            completion(true, message!)
        })
    }
    
    func rejectOrder(orderId:Int, completion:@escaping (Bool, String) -> Void) {
        let url = getApiURL(url: "customer/orders/\(orderId)/reject-estimate")
        let authString = "{\"publicKey\":\"\(publicKey)\""
        sendPostRequest(url: url, body: authString, completionHandler: {
            data, response, error in
            guard let _ = data, error == nil else {
                completion(false, "NO RESPONSE")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print (httpStatus.statusCode)
                let jsonData = JSON(data: data!)
                print (jsonData.rawString()!)
                completion(false, "\(httpStatus.statusCode)")
                return
            }
            
            self.updateOrderEstimate(orderId: orderId, approve: false)
            let message = String(data: data!, encoding: .utf8)
            completion(true, message!)
        })
    }
    
    func getEstimateStr() -> String {
        var estimateStr:String = "{\"products\":{"
        
        var basketCount = 0
        var total = 0.0
        
        for product in self.products {
            if product.qty > 0 {
                basketCount += product.qty
                total += Double(product.qty) * product.price
                let prodStr = getStringFromProduct(product: product)
                estimateStr += prodStr + ","
            }
        }
        
        if self.estimateBox != nil && self.estimateBox!.qty > 0 {
            basketCount += self.estimateBox!.qty
            if total < Double(self.estimateBox!.qty) * self.estimateBox!.price {
                total = Double(self.estimateBox!.qty) * self.estimateBox!.price
            }
            
            let boxStr = getStringFromProduct(product: self.estimateBox!)
            estimateStr += boxStr
        }
        else {
            let index = estimateStr.index(before: estimateStr.endIndex)
            estimateStr.remove(at: index)
        }
        
        estimateStr += "},"
        
        estimateStr += "\"total\":\(total),"
        estimateStr += "\"formatTotal\":\"\(total)\","
        estimateStr += "\"basketCount\":\(basketCount)"
        
        estimateStr += "}"
        
        return estimateStr
    }
    
    func getStringFromProduct(product:Product) -> String {
        var prodStr = "\"\(product.bridgeProductTypeID!)\":{"
        
        let total = Double(product.qty) * product.price
        
        if product.unitName == "box" {
            prodStr += "\"qty\":\(product.qty!),\"total\":\(total),\"data\":"
        }
        else {
            prodStr += "\"qty\":\(product.qty!),\"total\":\(total),\"formatTotal\":\"\(total)\",\"data\":"
        }
        
        prodStr += product.jsonData.rawString()!
        
        prodStr += "}"
        
        return prodStr
    }
    
    func getStringFromCard(card:STPToken) -> String {
        
        var brandStr:String = "unknown"

        if card.card?.brand == STPCardBrand.visa {
            brandStr = "visa"
        }
        else if card.card?.brand == STPCardBrand.amex {
            brandStr = "amex"
        }
        else if card.card?.brand == STPCardBrand.dinersClub {
            brandStr = "dinersClub"
        }
        else if card.card?.brand == STPCardBrand.discover {
            brandStr = "discover"
        }
        else if card.card?.brand == STPCardBrand.JCB {
            brandStr = "JCB"
        }
        else if card.card?.brand == STPCardBrand.masterCard {
            brandStr = "masterCard"
        }
        else {
            brandStr = "unknown"
        }
        
        let str:String = "{\"id\":\"\(card.tokenId)\",\"isLive\":\(card.livemode),\"brand\":\"\(brandStr)\",\"last4\":\"\(card.card!.last4())\",\"expMonth\":\(card.card!.expMonth),\"expYear\":\(card.card!.expYear),\"expString\":\"\(card.card!.expMonth)/\(card.card!.expYear)\"}"
        
        return str
    }
    
    private func sendPostRequest(url: String, parameters: [String: AnyObject], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let parameterString = parameters.stringFromHttpParameters()
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpBody = parameterString.data(using: .utf8)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
    
    private func sendPostRequest(url: String, body: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = body.data(using: .utf8)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
    
    private func sendGetRequest(url: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let requestURL = URL(string:url)!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
    
    private func sendGetRequest(url: String, body: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpBody = body.data(using: .utf8)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
    
    private func sendGetRequest(url: String, parameters: [String: AnyObject], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let parameterString = parameters.stringFromHttpParameters()
        var requestURL = URL(string:"\(url)?\(parameterString)")!
        
        if parameterString == "" {
            requestURL = URL(string:url)!
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
    
    private func sendPutRequest(url: String, parameters: [String: AnyObject], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let parameterString = parameters.stringFromHttpParameters()
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = parameterString.data(using: .utf8)
        request.httpMethod = "PUT"
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
    
    private func sendPutRequest(url: String, body: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpBody = body.data(using: .utf8)
        request.httpMethod = "PUT"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
}

extension String {
    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
}

extension Dictionary {
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).addingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
}
