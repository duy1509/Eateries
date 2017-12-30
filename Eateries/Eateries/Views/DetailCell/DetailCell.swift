//
//  DetailCell.swift
//  Eateries
//
//  Created by DUY on 12/8/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
import Kingfisher

class DetailCell: UITableViewCell {
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var vwBoundsTextView: UIView!
    @IBOutlet weak var vwInfo: UIView!
    @IBOutlet weak var lblCreateDay: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txvDes: UITextView!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    let auth = Auth.auth()
    let ref = Database.database().reference()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUIImage()
        setupTextField(false)
    }
    
    fileprivate func setupTextField(_ isActive:Bool) {
        self.txvDes.isUserInteractionEnabled = isActive
        self.lblName.isUserInteractionEnabled = isActive
        self.lblPhone.isUserInteractionEnabled = isActive
        self.lblPrice.isUserInteractionEnabled = isActive
        self.lblLocation.isUserInteractionEnabled = isActive
        self.lblCreateDay.isUserInteractionEnabled = isActive
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configCell(_ post: Post) {
        lblName.text = post.fullName
        lblPhone.text = post.phone
        lblPrice.text = post.price
        lblLocation.text = post.address
        txvDes.text = post.describe
        DispatchQueue.main.async {
            guard let stringAvatar = post.avatarUrl else { return }
            let url = URL(string: stringAvatar)
            self.imgUser.kf.setImage(with: url)
        }
    }
    
    private func setupUIImage() {
        self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width / 2
        self.imgUser.clipsToBounds = true
    }
}

