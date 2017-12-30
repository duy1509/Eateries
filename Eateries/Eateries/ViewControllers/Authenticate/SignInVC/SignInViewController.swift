//
//  SignInViewController.swift
//  Eateries
//
//  Created by DUY on 12/5/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class SignInViewController: UIViewController {
    @IBOutlet weak var btnForgotPass: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnResend: UIButton!
    
    @IBOutlet weak var txtResendEmail: UILabel!
    @IBOutlet var vwForgotPass: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    var changeEmailViewLctTop:NSLayoutConstraint!
    fileprivate var isChangeView:Bool = true
    var vwBlur:UIView!
    let auth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForgotPassView()
        setupUI()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK:- Support functions
    private func setupUI() {
        let btnAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any]
        
        let stringAttribute = NSMutableAttributedString(string: "Forgot Password?", attributes: btnAttributes)
        let stringAttribute1 = NSMutableAttributedString(string: "Register with Email?", attributes: btnAttributes)
        btnForgotPass.setAttributedTitle(stringAttribute, for: .normal)
        btnRegister.setAttributedTitle(stringAttribute1, for: .normal)
    }
    fileprivate func setupForgotPassView() {
        
        self.vwBlur = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.vwBlur.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        self.view.insertSubview(self.vwForgotPass, belowSubview: self.view)
        self.view.insertSubview(self.vwBlur, belowSubview: vwForgotPass)
        self.vwBlur.isHidden = true
        self.vwBlur.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissView))
        self.vwBlur.addGestureRecognizer(tap)
        self.vwForgotPass.translatesAutoresizingMaskIntoConstraints = false
        self.vwForgotPass.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.changeEmailViewLctTop = NSLayoutConstraint.init(item: self.vwForgotPass, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 1000)
        self.changeEmailViewLctTop.isActive = true
        self.vwForgotPass.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25).isActive = true
        self.vwForgotPass.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        self.vwForgotPass.layer.cornerRadius = 3
        self.vwForgotPass.layer.borderWidth = 0
    }
    
    @IBAction func Back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func SignIn(_ sender: UIButton) {
        guard let email = txtEmail.text , let pass = txtPassword.text else { return }
        ProgressHUD.show("Login..")
        signInWith(email, pass)
    }
    @IBAction func RegisterEmail(_ sender: UIButton) {
        let registerVC = Storyboard.main.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.pushTo(registerVC)
        
    }
    @objc func dismissView() {
        self.view.endEditing(true)
        if !(self.isChangeView) {
            self.isChangeView = true
            self.changeEmailViewLctTop.constant = 1000
            self.vwBlur.isHidden = true
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func forgotPass(_ sender: UIButton) {
        if self.isChangeView {
            self.isChangeView = false
            self.changeEmailViewLctTop.constant = self.view.frame.size.height / 2 - self.vwForgotPass.frame.size.height
            self.vwBlur.isHidden = false
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    //MARK:- Firebase functions
    private func signInWith(_ email:String, _ password:String) {
        auth.signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
            guard let strongSelf = self else { return }
            if error == nil {
                ProgressHUD.dismiss()
                let tabbarVC = TabBarViewController()
                strongSelf.pushTo(tabbarVC)
            } else {
                ProgressHUD.showError(error?.localizedDescription)
            }
        })
    }
    
    
}
