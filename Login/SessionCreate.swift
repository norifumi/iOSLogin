//
//  SessionCreate.swift
//  Login
//
//  Created by NORIFUMI HOMMA on 2020/05/17.
//  Copyright © 2020 init6. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public struct User: CustomStringConvertible {
    public var name: String? = nil
    public var email: String? = nil
    public var password: String? = nil
    
    public var description: String {
        get {
            var string = "\nName: \(String(describing: name))\n"
            string += "\nEmail: \(String(describing: email))\n"
            string += "\nPassword: \(String(describing: password))\n"
            return string
        }
    }
    
    public var postParams: [String: String?] {
        return ["user[email]": email,
                "user[password]": password]
    }
}

public class SessionCreate {
    let url = "http://192.168.226.150:3000/sessions.json"
    var postParams: [String: String?]
    
    public init(postParams: [String: String?]){
        self.postParams = postParams
    }
    
    public func post() {
        let request = AF.request(url, method: .post, parameters: postParams).response {
            response in
            var json = JSON.null
            do {
                if response.error == nil && response.data != nil {
                    
                    json = try SwiftyJSON.JSON(data: response.data!)
                }
            } catch {
                // do nothing
            }
            if response.error != nil {
                print(response.error)
                return
            }
            print(json)
        }
    }
}
