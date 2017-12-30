//
//  ChangePassViewController.swift
//  Eateries
//
//  Created by DUY on 12/15/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import FirebaseAuth
import ProgressHUD

class ChangePassViewController: UIViewController {
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    let auth = Auth.auth()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        
    }
    //MARK:- Support functions
    func setupUI(){
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    //MARK:- Support functions
    fileprivate func setupNavigation() {
        self.navigationItem.title = "Change Password"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrowLeftSimpleLineIcons"), style: .done, target: self, action: #selector(ChangePassViewController.dismissView))
    }
    func changePass(){
        auth.currentUser?.updatePassword(to: txtNewPass.text!, completion: { (error) in
            ProgressHUD.showError(error?.localizedDescription)
        })
    }
    
    
    @objc func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func saveNewPass(_ sender: UIButton) {
        //        changePass()
    }
    
    
}
