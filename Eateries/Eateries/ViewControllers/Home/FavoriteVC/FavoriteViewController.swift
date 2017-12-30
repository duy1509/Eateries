//
//  FavoriteViewController.swift
//  Eateries
//
//  Created by DUY on 12/6/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import KRPullLoader
import ProgressHUD

class FavoriteViewController: UIViewController {
    @IBOutlet weak var cvwDetails: UICollectionView!
    private let loadMoreView = KRPullLoadView()
    private let refreshView = KRPullLoadView()
    fileprivate var current_Page:Int = 1
    fileprivate var total_pages:Int = 0
    fileprivate var arrPost = [Post]()
    let auth = Auth.auth()
    var post:Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataUserLike()
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
        self.setupCollectionView()
        //        loadChangeData()
    }
    
    //MARK:- Support functions
    private func setupLayout() {
        tabBarController?.tabBar.isHidden = false
        self.navigationItem.title = "Favorite"
    }
    
    private func setupCollectionView() {
        cvwDetails.delegate = self
        cvwDetails.dataSource = self
        //Setup layout for item in collectionview
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.size.width, height: 280)
        layout.scrollDirection = .vertical
        cvwDetails.collectionViewLayout = layout
        
        //Register cell for collectionView
        let nib = UINib(nibName: "HomePageCell", bundle: nil)
        cvwDetails.register(nib, forCellWithReuseIdentifier: "HomePageCell")
        loadMoreView.delegate = self
        refreshView.delegate = self
        cvwDetails.addPullLoadableView(loadMoreView, type: .loadMore)
        cvwDetails.addPullLoadableView(refreshView, type: .refresh)
    }
    
    //MARK:- Firebase Functions
    
    
    func loadDataUserLike(){
        Firebase.shared.getDataUserLike(TableName.TableLike, .childAdded) { [weak self] (userLike, key, error) in
            guard let strongSelf = self else { return }
            if error == nil {
                guard let  userLike = userLike else { return }
                strongSelf.arrPost.append(userLike)
                DispatchQueue.main.async {
                    ProgressHUD.showSuccess()
                    strongSelf.cvwDetails.reloadData()
                }
            } else {
                ProgressHUD.showError(error)
            }
        }
    }
    
    func loadChangeData(){
        arrPost.removeAll()
        loadDataPost()
    }
    
    
    func loadDataPost(){
        //        Firebase.shared.getDataPost(TableName.Table, .childAdded) { [weak self] (postData, key, error) in
        //            guard let strongSelf = self else { return }
        guard let post = self.post else {return}
        //            if error == nil {
        //                guard let postData = postData else { return }
        if let currentUserID = self.auth.currentUser?.uid {
            if post.likes != nil {
                post.isLiked = post.likes![currentUserID] != nil
            }
        }
        self.arrPost.append(post)
        
        DispatchQueue.main.async {
            ProgressHUD.showSuccess()
            self.cvwDetails.reloadData()
        }
    }
    
    
}
//MARK:- CollectionView Datasource & Delegate
extension FavoriteViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageCell", for: indexPath) as! HomePageCollectionViewCell
        cell.lblName.text  = arrPost[indexPath.row].nameEateries
        cell.lblLocation.text = arrPost[indexPath.row].address
        if let urlImage = arrPost[indexPath.row].urlImage {
            let urlString = URL(string: urlImage)
            cell.imgHinhCell.kf.setImage(with: urlString)
        }
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 280)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = arrPost[indexPath.row]
        let detail = Storyboard.detail.instantiateViewController(ofType: DetailEateriesVC.self)
        detail.post = post
        navigationController?.pushViewController(detail, animated: true)
    }
    
}
// MARK: - KRPullLoader Delegate
extension FavoriteViewController: KRPullLoadViewDelegate {
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        weak var `self` = self
        if type == .loadMore {
            switch state {
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    guard let strongSelf = self else { return }
                    completionHandler()
                    strongSelf.loadMore()
                }
            default: break
            }
        } else {
            switch state {
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    guard let strongSelf = self else { return }
                    completionHandler()
                    strongSelf.refreshPage()
                })
            default: break
            }
        }
    }
    
    private func loadMore() {
        if current_Page < total_pages {
            current_Page += 1
        }
    }
    
    private func refreshPage() {
        current_Page = 1
    }
}

