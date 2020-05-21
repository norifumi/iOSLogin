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

public extension Notification.Name {
    public static let sessionAPIStart = Notification.Name("SessionAPIStart")
    public static let sessionAPIComplete = Notification.Name("SessionAPIComplete")
}

public struct User: CustomStringConvertible {
    public var id: Int = 0
    public var name: String? = nil
    public var email: String? = nil
    public var password: String? = nil
    public var access_token: String = ""
    
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
    
    public var idAccessToken: String {
        return "\(id):\(access_token)"
    }
    
    public mutating func parseIdAccessToken(idAccessToken: JSON) {
        let id_access_token = idAccessToken["id_access_token"].string?.components(separatedBy: ":")
        if id_access_token != nil && id_access_token?.count == 2 {
            self.id = Int((id_access_token?[0])!)!
            self.access_token = id_access_token?[1] as! String
        }
    }
}

public class SessionController {
    let url = "http://192.168.226.150:3000/sessions.json"
    var postParams: [String: String?]
    var user: User = User()
    
    public init(user: User){
        self.user = user
        self.postParams = self.user.postParams
    }
    
    public func create() {
        NotificationCenter.default.post(name: .sessionAPIStart, object: nil)
        
        let request = AF.request(url, method: .post, parameters: postParams).response {
            response in
            var json = JSON.null
            do {
                if response.error == nil && response.data != nil {
                    
                    json = try SwiftyJSON.JSON(data: response.data!)
                    NotificationCenter.default.post(name: .sessionAPIComplete, object: nil, userInfo: ["idAccessToken": json["id_access_token"].string])
                    return
                }
            } catch {
                if let error = response.error {
                    self.notifyError(errorMessage: "\(error)")
                }
                return
            }
            
            self.notifyError(errorMessage: "メールアドレスまたはパスワードが間違えています")
            
            
        }
    }
    
    private func notifyError(errorMessage: String?){
        var message = "Unknown error."
        if errorMessage != nil {
            message = errorMessage!
        }
        NotificationCenter.default.post(name: .sessionAPIComplete, object: nil, userInfo: ["error": message])
    }
}
