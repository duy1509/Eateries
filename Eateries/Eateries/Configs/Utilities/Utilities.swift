//
//  Utilities.swift
//  Eateries
//
//  Created by DUY on 12/18/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import Foundation
import UIKit

struct Utilities {
    
    static let shared = Utilities()
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        
        
        image.draw(in: CGRect(x: 0, y: 0,width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    func ShowAlert(title:String,Messenges:String,Viewcontroller:UIViewController){
        let alert:UIAlertController = UIAlertController(title: title, message: Messenges, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        Viewcontroller.present(alert, animated: true, completion: nil)
    }
    
    func showAlerControler(title: String?, message: String?, alertStyle: UIAlertControllerStyle, confirmButtonText: String?, cancaleButtonText:String? ,atController: UIViewController, completion: @escaping (_ isButtonConfirm: Bool) -> Void){
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        if let confirmStr = confirmButtonText{
            let confirmButton = UIAlertAction(title: confirmStr, style: .default, handler: { (ACTION) -> Void in
                completion(true)
            })
            alert.addAction(confirmButton)
        }
        if let confirmStr = cancaleButtonText{
            let confirmButton = UIAlertAction(title: confirmStr, style: .default, handler: { (ACTION) -> Void in
                completion(false)
            })
            alert.addAction(confirmButton)
        }
        atController.present(alert, animated: true, completion: nil)
    }

}
