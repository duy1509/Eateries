//
//  NetworkService.swift
//  Eateries
//
//  Created by DUY on 12/7/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias success = (_ responseData: JSON?) -> Void
typealias failed = (_ error: String, _ code:Int?) -> Void

struct NetworkService {
    
    static func requestWith(_ requestType: Alamofire.HTTPMethod, url: String, parameters: Dictionary<String, Any>?, header: HTTPHeaders, Completion:((_ data: [String: Any]?, _ error: String?, _ code:Int?) -> Void)?){
        
        Alamofire.request(url, method: requestType, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(let value):
                guard let value = value as? [String: Any] else{
                    Completion!(nil, "Data is wrong format, Please contact server side.", nil)
                    return
                }
                Completion!(value, nil, 200)
                
                
            case .failure(let error):
                if(error._code == -1009) {
                    Completion!(nil, "No internet connection", -1009)
                } else {
                    Completion!(nil, error.localizedDescription, nil)
                }
                break
                
            }
        }
    }
    
}
