//
//  RegisterViewController.swift
//  Eateries
//
//  Created by DUY on 12/5/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
import TLPhotoPicker

class RegisterViewController: UIViewController {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtConfirmPassWord: UITextField!
    @IBOutlet weak var lctTopBtnBack: NSLayoutConstraint!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassWord: UITextField!
    let picker = UIImagePickerController()
    let auth = Auth.auth()
    let ref = Database.database().reference()
    let storage = Storage.storage().reference(forURL: "gs://eateries-eae99.appspot.com/")
    var selectedProfilePhoto:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActionForImg()
        // Do any additional setup after loading the view.
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK:- Support functions
    private func setupUI() {
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width / 2
        self.imgProfile.clipsToBounds = true
    }
    private func setupActionForImg() {
        imgProfile.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showLibrary))
        imgProfile.translatesAutoresizingMaskIntoConstraints = false
        imgProfile.addGestureRecognizer(tapGesture)
    }
    
    //MARK:- Action buttons
    
    @IBAction func nextStep(_ sender: UIButton) {
        ProgressHUD.show("Waiting...!")
        guard let email = txtEmail.text , let pass = txtPassWord.text , let fullname = txtFullName.text else { return }
        if txtPassWord.text == txtConfirmPassWord.text {
            createUser(email, pass, fullname)
        } else {
            ProgressHUD.showError("Please check passWord")
        }
        
    }
    @IBAction func Back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func showLibrary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    //MARK:- Firebase Functions
    
    private func upLoadImage(completion:@escaping ((_ urlString:String?,_ error:String?)->(Void))){
        var downloadURL = ""
        if let profileImage = self.selectedProfilePhoto, let imageData = UIImagePNGRepresentation(profileImage) {
            let imgName = UUID().uuidString
            let profileImgStorage = self.storage.child("Avatar/")
            let newImg = profileImgStorage.child(imgName)
            newImg.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error == nil {
                    print(imageData)
                    downloadURL = (metadata?.downloadURL()?.absoluteString)!
                    completion(downloadURL,nil)
                } else {
                    completion(nil,(error?.localizedDescription)!)
                }
            })
        }
    }
    private func createUser(_ email:String,_ pass:String,_ name:String) {
        self.auth.createUser(withEmail: email, password: pass, completion: { [weak self] (user, error) in
            guard let strongSelf = self else { return }
            if error == nil {
                strongSelf.upLoadImage(completion: { [weak self] (urlString, err) -> (Void) in
                    if err == nil {
                        var value:Dictionary<String,AnyObject> = Dictionary()
                        value.updateValue(email as AnyObject, forKey: "email")
                        value.updateValue(name as AnyObject, forKey: "fullname")
                        value.updateValue(urlString as AnyObject, forKey: "avatar")
                        let user = Constants.refUser.child((user?.uid)!)
                        user.setValue(value, withCompletionBlock: { [weak self] (error, data) in
                            guard let strongSelf = self else { return }
                            if error == nil {
                                ProgressHUD.showSuccess()
                                strongSelf.dismiss(animated: true, completion: nil)
                            } else {
                                ProgressHUD.showError(error?.localizedDescription)
                            }
                        })
                    } else {
                        ProgressHUD.showError(err)
                    }
                })
            } else {
                ProgressHUD.showError(error?.localizedDescription)
            }
        })
    }
    
}
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let newimg = Utilities.shared.resizeImage(image: image, newWidth: 300)
            self.imgProfile.image = newimg
            selectedProfilePhoto = newimg
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}


