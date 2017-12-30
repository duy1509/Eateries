//
//  UIViewControllerExtension.swift
//  Eateries
//
//  Created by DUY on 12/6/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(with messages: String) {
        let alert = UIAlertController(title: "ERROR", message: messages, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertSuccess(with messages: String) {
        let alert = UIAlertController(title: "MESSAGE", message: messages, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithAction(_ title:String,_ mess:String,_ confirmBtn:String?, completion:@escaping (_ bool:Bool)->()) {
        let alert = UIAlertController(title: title, message: mess, preferredStyle: .alert)
        if let confirmBtn = confirmBtn {
            let ok = UIAlertAction(title: confirmBtn, style: .default, handler: { (action) in
                completion(true)
            })
            alert.addAction(ok)
        } else {
            let cancel = UIAlertAction(title: "OK", style: .cancel) { (action) in
                completion(false)
            }
            alert.addAction(cancel)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - PRESENT VC
    func addChildView(_ storyboardName: String, identifier: String) -> UIViewController{
        let vc = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: identifier)
        self.addChildViewController(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        return vc
    }
    
    func pushTo(_ vc: UIViewController){
        let transition = TransitionManager.sharedInstance
        transition.isPresentOnBackButton = false
        vc.transitioningDelegate = transition
        self.present(vc, animated: true, completion: nil)
    }
    
    func popFrom(_ vc: UIViewController){
        let transition = TransitionManager.sharedInstance
        transition.isPresentOnBackButton = true
        vc.transitioningDelegate = transition
        self.present(vc, animated: true, completion: nil)
    }
    
    func rootVC() -> UIViewController{
        return UIApplication.shared.keyWindow!.rootViewController!
    }
    
    //MARK: - HIDE KEYBOARD
    
    func tapToHideKeyboard(){
        let tapOutside = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        self.view.addGestureRecognizer(tapOutside)
    }
    
    @objc func tap(_ gesture: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
}

