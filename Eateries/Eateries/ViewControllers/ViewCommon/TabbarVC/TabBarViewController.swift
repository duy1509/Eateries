//
//  TabBarViewController.swift
//  Eateries
//
//  Created by DUY on 12/6/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = Color.mainColor()
        self.setupViewController()
    }

    private func setupViewController() {
        let homePageVC = Storyboard.home.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
        let naviPageVC = EateriesNavigationVC(rootViewController: homePageVC)
        naviPageVC.tabBarItem = UITabBarItem(title: "Trang Chủ", image: UIImage(named: "home"), selectedImage: UIImage(named: "homeSelected"))
        naviPageVC.setupTitle("Trang Chủ")


        let likeVC = Storyboard.home.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
        let naviLikeVC = EateriesNavigationVC(rootViewController: likeVC)
        naviLikeVC.tabBarItem = UITabBarItem(title: "Yêu Thích", image: UIImage(named: "heart"), selectedImage: UIImage(named:"likeSelected"))
        naviLikeVC.setupTitle("Yêu Thích")

        let postVC = Storyboard.home.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        let naviPostVC = EateriesNavigationVC(rootViewController: postVC)
        naviPostVC.tabBarItem = UITabBarItem(title: "Đăng Tin", image: UIImage(named: "plus"), selectedImage: UIImage(named:"postSeledted"))
        naviPostVC.setupTitle("Đăng Tin")

        let menuVC = Storyboard.home.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        let naviMenuVC = EateriesNavigationVC(rootViewController: menuVC)
        naviMenuVC.tabBarItem = UITabBarItem(title: "Menu", image: UIImage(named: "menu"), selectedImage: UIImage(named:"menu_selected"))
        naviMenuVC.setupTitle("Menu")

        self.viewControllers = [naviPageVC, naviLikeVC , naviPostVC, naviMenuVC]
        self.selectedViewController = naviPageVC

    }
}


