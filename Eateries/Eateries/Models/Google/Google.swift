//
//  Google.swift
//  Eateries
//
//  Created by DUY on 12/7/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import Foundation
import SwiftyJSON
import GoogleSignIn

struct Google {
    
    var name:String
    var email:String
    var userId:String
    var idToken:String
    var imgURL:String
    
    init(_ data:GIDGoogleUser) {
        
        if let name = data.profile.name {
            self.name = name
        } else {
            self.name = ""
        }
        
        if let email = data.profile.email {
            self.email = email
        } else {
            self.email = ""
        }
        
        if let userId = data.userID {
            self.userId = userId
        } else {
            self.userId = ""
        }
        
        if let idToken = data.authentication.idToken {
            self.idToken = idToken
        } else {
            self.idToken = ""
        }
        
        if let imgURL = data.profile.imageURL(withDimension: 400) {
            let urlString = imgURL.absoluteString
            self.imgURL = urlString
        } else {
            self.imgURL = ""
        }
    }
}
