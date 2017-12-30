//
//  Post.swift
//  Eateries
//
//  Created by DUY on 12/27/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import Foundation
import Firebase
import Kingfisher
import GoogleMaps
import GooglePlaces
import SwiftyJSON

class Post {
    
    var id:String?
    var email:String?
    var address:String?
    var phone:String?
    var avatarUrl:String?
    var active:Int?
    var total_Eateries:Int?
    var fullName:String?
    var latitude:Double?
    var longitude:Double?
    var nameEateries:String?
    var likeCount: Int?
    var likes: [String:Any]?
    var isLiked: Bool?
    var price:String?
    var describe:String?
    var image :[String:Any]?
    var location:CLLocationCoordinate2D?
    var imageHeader:String?
    var arrDataImage: [String:Any]?
    var urlImage:String?
    var arrString = [String]()
    
    init(dic: [String:AnyObject]) {
        email = dic["email"] as? String ?? ""
        fullName = dic["fullname"] as? String ?? ""
        nameEateries = dic["name"] as? String ?? ""
        address = dic["address"] as? String ?? ""
        price = dic["price"] as? String ?? ""
        phone = dic["phone"] as? String ?? ""
        describe = dic["describe"] as? String ?? ""
        likes = dic["likes"] as? [String:AnyObject]
        likeCount = dic["likeCount"] as? Int
        arrDataImage = dic["arrImg"] as? [String:Any]
        longitude = dic["longitude"] as? Double
        latitude = dic["latitude"] as? Double
        avatarUrl = dic["avatar"] as? String ?? ""
        if let lat = latitude, let long = longitude {
            location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        guard let arrData = arrDataImage else { return }
        if arrData.count > 0 {
            urlImage = arrData["urlImage1"] as? String ?? "bread-2796393_1920"
            for i in 0..<arrData.count {
                let url = arrData["urlImage\(i + 1)"] as? String ?? ""
                arrString.append(url)
            }
        }
    }
}


