//
//  Constants.swift
//  Eateries
//
//  Created by DUY on 12/6/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import Firebase

struct Storyboard {
    
    static let main = UIStoryboard(name: "Main", bundle: nil)
    static let home = UIStoryboard(name: "Home", bundle: nil)
    static let detail = UIStoryboard(name: "DetailEateries", bundle: nil)

}
struct Constants {
    
    static let googleAPIKey     = "AIzaSyBZtyMst2NAKxGkp95BST17UmGbWGNL_XY"
    static let ref              = Database.database().reference()
    static let refUser          = Database.database().reference().child("User")
    static let refTable          = Database.database().reference().child("Table")
    static let refImagePost       = Database.database().reference().child("ImagePost")
    static let refTableLike      = Database.database().reference().child("TableLike")
    static let urlDirecton      = "https://maps.googleapis.com/maps/api/directions/json"
}

struct TableName {
    static let user                 = "User"
    static let Table                 = "Table"
    static let ImagePost              = "ImagePost"
    static let TableLike             = "TableLike"
}

