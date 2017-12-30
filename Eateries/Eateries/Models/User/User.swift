//
//  User.swift
//  Eateries
//
//  Created by DUY on 12/15/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import Foundation
import Firebase
import Kingfisher
import GoogleMaps
import GooglePlaces
import SwiftyJSON

class User {
    
    var id:String?
    var email:String?
    var address:String?
    var phone:String?
    var avatarUrl:String?
    var fullName:String?


    
    init(dic: [String:AnyObject]) {

        email = dic["email"] as? String ?? ""
        fullName = dic["fullname"] as? String ?? ""
        address = dic["address"] as? String ?? ""
        phone = dic["phone"] as? String ?? ""
        avatarUrl = dic["avatar"] as? String ?? ""

    }

    
    
}

