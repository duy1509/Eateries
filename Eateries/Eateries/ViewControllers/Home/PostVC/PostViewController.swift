//
//  PostViewController.swift
//  Eateries
//
//  Created by DUY on 12/6/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Photos
import GooglePlaces
import TLPhotoPicker
import Firebase
import ProgressHUD

class PostViewController: UIViewController {
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var coView: UICollectionView!
    fileprivate let imgDefault = UIImage(named: "add_image")!
    fileprivate var arrImage:[UIImage] = [UIImage]()
    fileprivate var arrUrlString:[String] = []
    fileprivate var row:Int = 0
    fileprivate var eateriesLocation:CLLocationCoordinate2D!
    fileprivate var autocompleteController:GMSAutocompleteViewController?
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    let auth = Auth.auth()
    let ref = Database.database().reference()
    let storage = Storage.storage().reference(forURL: "gs://eateries-eae99.appspot.com/")
    var userData:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupUI()
        setupDelegate()
        loadData()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Support function
    private func setupUI() {
        self.txtName.underlined(Color.txtUnderlineColor())
        self.txtLocation.underlined(Color.txtUnderlineColor())
        self.txtPrice.underlined(Color.txtUnderlineColor())
        self.txtPhone.underlined(Color.txtUnderlineColor())
        txtPrice.addTextRightView("VNĐ", Font.fontAvenirNext(12))
    }
    private func setupCollectionView() {
        arrImage.append(imgDefault)
        coView.delegate = self
        coView.dataSource = self
    }
    
    private func setupDelegate() {
        txtView.delegate = self
        txtLocation.delegate = self
    }
    
    fileprivate func selectPhoto(_ row:Int) {
        let photoVC = TLPhotosPickerViewController()
        photoVC.delegate = self
        photoVC.configure.mediaType = PHAssetMediaType.image
        photoVC.configure.usedCameraButton = true
        photoVC.configure.maxSelectedAssets = 1
        self.row = row
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.present(photoVC, animated: true, completion: nil)
        }
    }
    
    //MARK:- Firebase Functions
    
    func loadData(){
        
        let refUser = ref.child("User").child((auth.currentUser?.uid)!)
        refUser.observeSingleEvent(of: .value, with: { [weak self] (data) in
            guard let strongSelf = self else { return }
            guard let userData = data.value as? [String:AnyObject] else { return }
            let userInfo = User(dic: userData)
            strongSelf.userData = userInfo
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func uploadDataAndImage(_ tablePost:DatabaseReference){
        for i in 0..<arrImage.count{
            if arrImage[i] != imgDefault {
                let image = arrImage[i]
                let imgData: Data = UIImageJPEGRepresentation((image), 0.1)!
                let img = UUID().uuidString
                let storageRef = storage.child("Image\(img).png")
                storageRef.putData(imgData, metadata: nil) { [weak self] (metadata, error) in
                    guard let strongSelf = self else { return }
                    if error != nil {
                        ProgressHUD.showError(error?.localizedDescription)
                    }else{
                        guard let imgString = metadata?.downloadURL()?.absoluteString else { return }
                        strongSelf.arrUrlString.append(imgString)
                        strongSelf.uploadImageToDatabase(img, imgUrl: imgString, tableData: tablePost)
                    }
                }
            }
        }
    }
    @IBAction func Post(_ sender: UIButton) {
        ProgressHUD.show("Waiting..!")
        if checkParam() {
            uploadPost()
        }
    }
    
    
    private func uploadImageToDatabase(_ imgName:String, imgUrl:String, tableData:DatabaseReference) {
        let tableImge = ref.child("ImagePost")
        let value = ["linkUrl": imgUrl] as [String:Any]
        tableImge.child(imgName).setValue(value, withCompletionBlock: { [weak self] (err, data) in
            guard let strongSelf = self else { return }
            if err == nil {
                strongSelf.upLoadImageForTablePost(tableData)
            }
        })
    }
    
    private func checkParam() -> Bool{
        if (txtLocation.text?.isEmpty)! || (txtName.text?.isEmpty)! || (txtPhone.text?.isEmpty)! || (txtPrice.text?.isEmpty)! {
            ProgressHUD.showError("Please enter requiment fields")
            return false
        }
        return true
    }
    
    private func uploadPost() {
        let table = ref.child("Table")
        var value: [String:Any] = [:]
        
        value.updateValue(self.userData?.avatarUrl as Any, forKey: "avatar")
        value.updateValue(self.userData?.fullName as Any, forKey: "fullname")
        value.updateValue(self.userData?.email as Any, forKey: "email")
        value.updateValue(self.txtName.text as Any, forKey: "name")
        value.updateValue(self.txtLocation.text as Any, forKey: "address")
        value.updateValue(self.txtPhone.text as Any, forKey: "phone")
        value.updateValue(self.txtPrice.text as Any, forKey: "price")
        value.updateValue(self.txtView.text as Any, forKey: "describe")
        value.updateValue(self.eateriesLocation.latitude as Any, forKey: "latitude")
        value.updateValue(self.eateriesLocation.longitude as Any, forKey: "longitude")
        
        table.childByAutoId().setValue(value) { [weak self] (err, data) in
            guard let strongSelf = self else { return }
            if err == nil {
                strongSelf.uploadDataAndImage(data)
            }
        }
    }
    
    private func upLoadImageForTablePost(_ tableData: DatabaseReference) {
        var value = [String:Any]()
        var arrImgValue = [String:Any]()
        for index in 0..<arrUrlString.count {
            value.updateValue(arrUrlString[index] as Any, forKey: "urlImage\(index + 1)")
            arrImgValue.updateValue(value as Any, forKey: "arrImg")
            tableData.updateChildValues(arrImgValue)
            ProgressHUD.showSuccess()
        }
        self.txtPrice.text = ""
        self.txtPhone.text = ""
        self.txtName.text = ""
        self.txtLocation.text = ""
        self.txtView.text = "Có chỗ để xe, có máy lạnh,…"
        self.arrImage = [imgDefault]
        DispatchQueue.main.async {
            self.coView.reloadData()
        }
    }
    
}
// MARK: - CollectionView DataSource and Delegate
extension PostViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ofType: ImageCollectionViewCell.self, at: indexPath)
        let image = arrImage[indexPath.row]
        cell.configCell(image)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectPhoto(indexPath.row)
    }
}

// MARK: - TextView Delegate
extension PostViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtView.text == "Có chỗ để xe, có máy lạnh,…"{
            txtView.text = ""
            txtView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtView.text == ""{
            txtView.text = "Có chỗ để xe, có máy lạnh,…"
            txtView.textColor = UIColor.gray
        }
    }
}
// MARK: - TLPhoto Delegate
extension PostViewController: TLPhotosPickerViewControllerDelegate {
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        guard let imagePicker = withTLPHAssets.first else { return }
        guard let imageFullSize = imagePicker.fullResolutionImage else { return }
        let imageData = imageFullSize.resizeToData()
        let img = UIImage(data: imageData)
        var imgQuanAn = arrImage[row]
        if arrImage.count <= 4 && imgQuanAn == imgDefault {
            arrImage.append(imgDefault)
        }
        imgQuanAn = img!
        arrImage[row] = imgQuanAn
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.coView.reloadData()
        }
    }
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
    }
    func photoPickerDidCancel() {
    }
    func dismissComplete() {
    }
    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
    }
}
// MARK: - Textfield Delegate
extension PostViewController: UITextFieldDelegate {
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
extension PostViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        eateriesLocation = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        if let address = place.formattedAddress {
            txtLocation.text = address
        }
        let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)

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
