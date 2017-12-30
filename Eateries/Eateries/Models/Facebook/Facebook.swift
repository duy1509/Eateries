//
//  Facebook.swift
//  Eateries
//
//  Created by DUY on 12/7/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import SwiftyJSON

struct Facebook {
    
    static func loginWithFacebook(viewcontroller:UIViewController ,_ Success: @escaping success, _ Failed: @escaping failed) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        fbLoginManager.logIn(withReadPermissions: ["public_profile","email"], from: viewcontroller) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.isCancelled {
                    Failed("", 1)
                } else {
                    if fbloginresult.grantedPermissions != nil {
                        if(fbloginresult.grantedPermissions.contains("email")) {
                            if((FBSDKAccessToken.current()) != nil){
                                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                                    if (error == nil){
                                        if let result = result as? Dictionary<String,Any> {
                                            let json = JSON(result)
                                            Success(json)
                                        }
                                    } else {
                                        Failed((error?.localizedDescription)!, nil)
                                    }
                                })
                            }
                        }
                    }
                }
            } else {
                Failed((error?.localizedDescription)!,nil)
            }
        }
    }
}
struct FacebookModel {
    
    var firstName:String
    var email:String
    var id:String
    var lastName:String
    var name:String
    var url:String
    
    init(_ json:JSON) {
        self.firstName = json["first_name"].stringValue
        self.email = json["email"].stringValue
        self.id = json["id"].stringValue
        self.lastName = json["last_name"].stringValue
        self.name = json["name"].stringValue
        let urlString = json["picture"].dictionaryValue
        let dataString = urlString["data"]?.dictionaryValue
        self.url = (dataString?["url"]?.stringValue)!
    }
}
