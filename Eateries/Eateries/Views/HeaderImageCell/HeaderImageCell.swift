//
//  HeaderImageCell.swift
//  Eateries
//
//  Created by DUY on 12/8/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
import Kingfisher

class HeaderImageCell: UITableViewCell {
    let auth = Auth.auth()
    let ref = Database.database().reference()
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var imgHinh: UIImageView!
    var acctionButtonLike:((UIButton)->())? = nil
    var post:Post?
    var info:Post?
    var id:String?
    //MARK:- Action buttons
    
    @IBAction func Like(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let actionLike = self.acctionButtonLike else {return}
        actionLike(sender)
        handleLikeTap()
    }
    //MARK:- Support functions
    
    func configHeaderCell(_ post:Post) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            if let urlImage = post.urlImage {
                let url = URL(string: urlImage)
                strongSelf.imgHinh.kf.setImage(with: url)
            }
            let imageLike = post.likes == nil || !post.isLiked! ? "heart" : "likeSelected-1"
            strongSelf.btnLike.setImage(UIImage(named:imageLike), for: .normal)
        }
    }
    
    func handleLikeTap() {
        let postReference = ref.child("Table").child((post?.id)!)
        showLike(forReference: postReference)
    }
    
    //MARK:- Firebase Functions
    
    func showLike(forReference refLike: DatabaseReference){
        refLike.runTransactionBlock({ (currentData:MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = self.auth.currentUser?.uid{
                var likes: [String:Bool]
                likes = post["likes"] as? [String : Bool] ?? [:]
                var likeCount = post["likeCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    // Unlike the post and remove self from stars
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    // Like the post and add self to stars
                    likeCount += 1
                    likes[uid] = true
                }
                post["likeCount"] = likeCount as AnyObject
                post["likes"] = likes as AnyObject
                
                // Set value and report transaction success
                currentData.value = post
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
            
        }) { (error, committed, snapshot) in
            if let error = error {
                ProgressHUD.showError(error.localizedDescription)
            }
            let dic = snapshot?.value as! [String:AnyObject]
            let post = Post(dic: dic)
            if let currentUserID = self.auth.currentUser?.uid{
                if post.likes != nil {
                    post.isLiked = post.likes![currentUserID] != nil
                }
            }
            self.upDataLike(post: post)
        }
    }
    
    func upDataLike(post: Post){
        let btnImageLike = post.likes == nil || !post.isLiked! ? "heart" : "likeSelected-1"
        if post.isLiked == nil {
            self.btnLike.setImage(UIImage(named:"heart"), for: .normal)
            self.loadDataUserIsLike()
        } else {
            if post.isLiked! {
                self.btnLike.setImage(UIImage(named:"likeSelected-1"), for: .normal)
                self.loadDataUserLike()
            } else{
                self.btnLike.setImage(UIImage(named:btnImageLike), for: .selected)
                ref.child("TableUserLike").child(post.id!).child((auth.currentUser?.uid)!).removeValue()
            }
        }
    }
    
    func loadDataUserIsLike(){
        let table = ref.child("TableLike").child((aut.currentUser?.uid)!).child((post?.id)!)
        
        var tableUserLike:[String:Any] = Dictionary()
        tableUserLike.updateValue("", forKey: "id")
        tableUserLike.updateValue("", forKey: "imageHeader")
        tableUserLike.updateValue("", forKey: "name")
        tableUserLike.updateValue("", forKey: "address")
        table.setValue(tableUserLike) { (error, data) in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
            }else{
                ProgressHUD.showSuccess()
            }
        }
    }
    
    func loadDataUserLike(){
        let table = ref.child("TableLike")
        var tableUserLike:[String:Any] = Dictionary()
        tableUserLike.updateValue(post?.id as Any, forKey: "id")
        tableUserLike.updateValue(post?.urlImage as Any, forKey: "imageHeader")
        tableUserLike.updateValue(post?.nameEateries as Any, forKey: "name")
        tableUserLike.updateValue(post?.address as Any, forKey: "address")
        let newtable = table.child((auth.currentUser?.uid)!).child((post?.id)!)
        newtable.setValue(tableUserLike) { (error, data) in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
            }else{
                ProgressHUD.showSuccess()
            }
        }
    }
}
