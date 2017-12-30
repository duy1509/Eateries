//
//  Color.swift
//  Eateries
//
//  Created by DUY on 12/6/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import Foundation
import UIKit

class Color {
    static func mainColor() -> UIColor {
        return UIColor(red: 58/255.0, green: 157/255.0, blue: 211/255.0, alpha: 0.9)
    }
    static func kLightGrayColor() -> UIColor {
        return UIColor(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1)
    }
    static func txtUnderlineColor() -> UIColor {
        return UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 0.5)
    }

}
class Font: UIFont {
    
    static func fontAvenirNext(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir Next", size: size)!
    }
    
    static func fontAvenirNextBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Bold", size: size)!
    }
    static func txtUnderlineColor() -> UIColor {
        return UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 0.5)
    }

}


