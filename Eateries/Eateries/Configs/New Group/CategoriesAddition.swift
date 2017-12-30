//
//  CategoriesAddition.swift
//  Eateries
//
//  Created by DUY on 12/8/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import Foundation
import UIKit

extension String {
   
    
    func isEmptyOrWhitespace() -> Bool {
        
        if(self.isEmpty) {
            return true
        }
        
        return (self.trimmingCharacters(in: CharacterSet.whitespaces) == "")
    }
    
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.height
    }
    
    
    func toDateTime(_ dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss'.'SSS") -> Date
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = dateFormat
        //Parse into NSDate
        let dateFromString : Date? = dateFormatter.date(from: self)
        
        //Return Parsed Date
        return dateFromString!
    }
    
    //    func toDateTime(dateFormat: String, timeZone : TimeZone = .local) -> Date
    //    {
    //        //Create Date Formatter
    //        let dateFormatter = DateFormatter()
    //        let zone: Foundation.TimeZone
    //        //Specify Format of String to Parse
    //        dateFormatter.dateFormat = dateFormat
    //        switch timeZone {
    //        case .local:
    //            zone = NSTimeZone.local
    //        case .utc:
    //            zone = Foundation.TimeZone(secondsFromGMT: 0)!
    //        }
    //        dateFormatter.timeZone = zone
    //        //Parse into NSDate
    //        let dateFromString : Date? = dateFormatter.date(from: self)
    //        //Return Parsed Date
    //        return dateFromString!
    //    }
    
}

extension Data {
    var hexString: String {
        return map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
    }
}



//MARK: UITABLEVIEW
extension UITableView {
    func reloadDataAnimatedKeepingOffset(){
        let offset = contentOffset
        UIView.setAnimationsEnabled(false)
        beginUpdates()
        endUpdates()
        UIView.setAnimationsEnabled(true)
        layoutIfNeeded()
        contentOffset = offset
    }
    
    func reloadAddRow(_ rowNumber: Int){
        let indexPath = IndexPath(item: rowNumber, section: 0)
        self.insertRows(at: [indexPath], with: .fade)
        self.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func reloadDeleteRow(_ rowNumber: Int){
        let indexPath = IndexPath(item: rowNumber, section: 0)
        beginUpdates()
        self.deleteRows(at: [indexPath], with: .bottom)
        endUpdates()
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.reload), userInfo: nil, repeats: false)
    }
    
    @objc func reload(){
        self.reloadData()
    }
    
    func reloadRow(_ rowNumber: Int){
        let indexPath = IndexPath(item: rowNumber, section: 0)
        self.reloadRows(at: [indexPath], with: .none)
    }
}

//MARK:- UIColor
extension UIColor {
    
    convenience init(hex: UInt32, alpha: CGFloat) {
        let red = CGFloat((hex & 0xFF0000) >> 16)/255.0
        let green = CGFloat((hex & 0xFF00) >> 8)/255.0
        let blue = CGFloat(hex & 0xFF)/255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(iRed: Int, iGreen: Int, iBlue: Int, alpha: CGFloat){
        let red = CGFloat(iRed)/255.0
        let green = CGFloat(iGreen)/255.0
        let blue = CGFloat(iBlue)/255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}

//MARK:- Textfield
extension UITextField{
    func underlined(_ color:UIColor){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func addTextRightView(_ text:String, _ font: UIFont) {
        let label = UILabel()
        label.text = text
        label.font = font
        label.frame = CGRect(x: 0, y: 0, width: 30, height: self.frame.size.height)
        self.rightView = label
        self.rightViewMode = .always
    }
    
}
