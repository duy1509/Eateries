//
//  DataCenter.swift
//  Eateries
//
//  Created by DUY on 12/26/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import Foundation
import Alamofire

class DataCenter {
    
    static let shared = DataCenter()
    
    private func createArrImage(_ arrImg:[UIImage]) -> [UIImage] {
        let arrImage = arrImg.filter({ $0 != UIImage(named: "add_image")! })
        return arrImage
    }
}
