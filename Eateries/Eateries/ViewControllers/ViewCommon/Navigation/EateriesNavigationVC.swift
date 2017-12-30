//
//  EateriesNavigationVC.swift
//  Eateries
//
//  Created by DUY on 12/6/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit

class EateriesNavigationVC: UINavigationController {
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBasicView()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Support function
    private func setupBasicView() {
        self.navigationBar.barTintColor = Color.mainColor()
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: Font.fontAvenirNextBold(20),NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationController?.interactivePopGestureRecognizer?.delegate = self
     
    }
    
    public func setupTitle(_ titleName:String) {
        self.navigationBar.topItem?.title = titleName
    }
}

// MARK: - Gesture Delegate
extension EateriesNavigationVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

