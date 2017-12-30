//
//  LoginViewController.swift
//  Eateries
//
//  Created by DUY on 12/6/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import GoogleSignIn
import ProgressHUD
import FBSDKLoginKit
import Firebase
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var lctCenterLblLogo: NSLayoutConstraint!
    @IBOutlet weak var lctWidthLblLogo: NSLayoutConstraint!
    @IBOutlet weak var lctHeightLblLogo: NSLayoutConstraint!
    @IBOutlet weak var vwLogin: UIView!
    @IBOutlet weak var vwBound: UIView!
    @IBOutlet weak var lblLogo: UILabel!
    var facebook:FacebookModel?
    var google:Google?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogle()
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

        //MARK:- Support function
    
    fileprivate func setupGoogle() {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
  
    fileprivate func loginFacebook() {
        Facebook.loginWithFacebook(viewcontroller: self, { [weak self] (dataFB) in
            guard let strongSelf = self else { return }
            if let dataJSON = dataFB {
                strongSelf.facebook = FacebookModel(dataJSON)
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                Auth.auth().signIn(with: credential) { (user, error) in
                    if error != nil {
                        ProgressHUD.showError()
                        return
                    } else {
                        ProgressHUD.show("Warning...")
                        let ref = Database.database().reference()
                        let userFace = ref.child("User").child((user?.uid)!)
                        guard let user = user else { return }
                        var value: [String:Any] = [:]
                        value.updateValue(user.email as Any, forKey: "email")
                        value.updateValue(user.photoURL?.absoluteString as Any, forKey: "avatar")
                        value.updateValue(user.displayName as Any, forKey: "fullname")
                        userFace.setValue(value, withCompletionBlock: { (error, data) in
                            if error == nil {
                                let tabBarVC = TabBarViewController()
                                self?.pushTo(tabBarVC)
                            }
                        })
                    }
                }
            }
        }) { [weak self] (error, code) in
            guard let strongSelf = self else { return }
            if error != "" {
                strongSelf.showAlert(with: error)
            }
        }
    }
    @IBAction func loginGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance().clientID = "781099394888-gasa86i4cka3nd0h9v6pa193kif8fq59.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func loginEmail(_ sender: UIButton) {
        let loginVC = Storyboard.main.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.pushTo(loginVC)

    }
    
    @IBAction func loginFacebook(_ sender: UIButton) {
        loginFacebook()
    }
}
//MARK:- Google Delegate
extension LoginViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let authentication = user.authentication else { return }
        guard let userProfile = user else { return }
        self.google = Google(userProfile)
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error)
                return
            } else {
                let ref = Database.database().reference()
                let userGoogle = ref.child("User").child((user?.uid)!)
                guard let user = user else { return }
                var value: [String:Any] = [:]
                value.updateValue(user.email as Any, forKey: "email")
                value.updateValue(user.photoURL?.absoluteString as Any, forKey: "avatar")
                value.updateValue(user.displayName as Any, forKey: "fullname")
                
                userGoogle.setValue(value, withCompletionBlock: { (error, data) in
                    if error == nil {
                        let tabBarVC = TabBarViewController()
                        self.pushTo(tabBarVC)
                        
                    }
                })
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print(user.profile)
    }
    
}

