//
//  InfoViewController.swift
//  Eateries
//
//  Created by DUY on 12/15/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import GooglePlaces
import Kingfisher
import Photos
import Firebase
import ProgressHUD
import SwiftyJSON

class InfoViewController: UIViewController {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var btnEdit: UIButton!
    fileprivate var userLocation:CLLocationCoordinate2D?
    fileprivate var autocompleteController:GMSAutocompleteViewController?
    var selectedProfilePhoto:UIImage?
    let auth = Auth.auth()
    let ref = Database.database().reference()
    let storage = Storage.storage().reference(forURL: "gs://eateries-eae99.appspot.com/")
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    //MARK:- Support functions
    
    private func setupUI() {
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width / 2
        self.imgProfile.clipsToBounds = true
        txtAddress.delegate = self
        self.setupNavigation()
        self.setupTextField(false)
        setupActionForImg()
        self.tabBarController?.tabBar.isHidden = true
        
    }
    private func setupNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrowLeftSimpleLineIcons"), style: .done, target: self, action: #selector(InfoViewController.dismissView))
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    fileprivate func setupTextField(_ isActive:Bool) {
        self.txtEmail.isUserInteractionEnabled = isActive
    }
    private func setupActionForImg() {
        imgProfile.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showLibrary))
        imgProfile.translatesAutoresizingMaskIntoConstraints = false
        imgProfile.addGestureRecognizer(tapGesture)
    }
    //MARK:- Action buttons
    
    @objc func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editProfile(_ sender: UIButton) {
        ProgressHUD.show("Waiting...")
        uploadToDaTa(name: txtFullName.text!, email: txtEmail.text!, address: txtAddress.text!, phone: txtPhoneNumber.text!, image: imgProfile.image!)
    }
    
    @objc func showLibrary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    //MARK:- Firebase Functions
    func loadData(){        
        
        let refUser = ref.child("User").child((auth.currentUser?.uid)!)
        refUser.observeSingleEvent(of: .value, with: { [weak self] (data) in
            guard let strongSelf = self else { return }
            guard let userData = data.value as? [String:AnyObject] else { return }
            let userInfo = User(dic: userData)
            DispatchQueue.main.async {
                let url = URL(string: userInfo.avatarUrl!)
                strongSelf.imgProfile.kf.setImage(with:url)
                strongSelf.txtFullName.text = userInfo.fullName
                strongSelf.txtEmail.text = userInfo.email
                strongSelf.txtPhoneNumber.text = userInfo.phone
                strongSelf.txtAddress.text = userInfo.address
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    func uploadToDaTa(name:String,email:String,address:String,phone:String,image:UIImage){
        let data = UIImagePNGRepresentation(imgProfile.image!)
        let image = UUID().uuidString
        let strongRef = storage.child("Avatar\(image).png")
        strongRef.putData(data!, metadata: nil) { (metadata, error) in
            if error != nil{
                ProgressHUD.showError(error?.localizedDescription)
            }else{
                let imgString = metadata?.downloadURL()?.absoluteString
                var newvalue = ["fullname":name,"email":email,"address":address,"phone":phone,"avatar":image]
                newvalue.updateValue((imgString as AnyObject) as! String, forKey: "avatar")
                newvalue.updateValue((self.txtFullName.text as AnyObject) as! String, forKey: "fullname")
                newvalue.updateValue((self.txtEmail.text as AnyObject) as! String
                    , forKey: "email")
                newvalue.updateValue((self.txtAddress.text as AnyObject) as! String, forKey: "address")
                let userProfile = self.ref.child("User").child((self.auth.currentUser?.uid)!)
                userProfile.setValue(newvalue, withCompletionBlock: { (error, data) in
                    if error != nil {
                        ProgressHUD.showError(error?.localizedDescription)
                    }else{
                        ProgressHUD.showSuccess("Success")
                    }
                })
            }
        }
    }
}

// MARK: - Textfield Delegate
extension InfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.endEditing(true)
        autocompleteController = GMSAutocompleteViewController()
        autocompleteController?.delegate = self
        DispatchQueue.main.async {
            self.present(self.autocompleteController!, animated: true, completion: nil)
        }
    }
}
// MARK: - AutocompleteController Delegate
extension InfoViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        userLocation = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        if let address = place.formattedAddress {
            txtAddress.text = address
        }
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
extension InfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let newimg = Utilities.shared.resizeImage(image: image, newWidth: 300)
            self.imgProfile.image = newimg
            selectedProfilePhoto = newimg
        }
        dismiss(animated: true, completion: nil)
    }
    
}

