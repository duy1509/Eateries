//
//  MenuViewController.swift
//  Eateries
//
//  Created by DUY on 12/6/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
//import FirebaseAuth
import Firebase
class MenuViewController: UIViewController {
    fileprivate let arrTitle:[String] = ["Thông tin","Thay đổi mật khẩu","Đăng xuất"]
    fileprivate let arrImgIcon:[String] = ["user", "lock" ,"logout"]
    
    @IBOutlet weak var tbvMenu: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Menu"
        self.tabBarController?.tabBar.isHidden = false
        self.setupTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = ""
    }
    //MARK:- Support functions
    private func setupTableView() {
        self.tbvMenu.delegate = self
        self.tbvMenu.dataSource = self
        self.tbvMenu.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        self.tbvMenu.separatorStyle = .none
    }
    fileprivate func showInfoVC() {
        let infoVC = Storyboard.home.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(infoVC, animated: true)
    }
    fileprivate func showChangePassVC() {
        let changePassVC = Storyboard.home.instantiateViewController(withIdentifier: "ChangePassViewController") as! ChangePassViewController
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(changePassVC, animated: true)
    }
    fileprivate func logOut(){
        let auth = Auth.auth()
        do {
            try auth.signOut()
            let home = Storyboard.main.instantiateViewController(withIdentifier: "LoginViewController")
            self.present(home, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
//MARK:- Tableview Delegate & Datasource
extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.selectionStyle = .none
        let title = self.arrTitle[indexPath.row]
        let icon = self.arrImgIcon[indexPath.row]
        cell.setupMenuCell(title, icon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            self.showInfoVC()
            break
        case 1:
            self.showChangePassVC()
            break
        case 2:
            self.logOut()
            break
        default:
            print("Duy")
        }
    }

}

