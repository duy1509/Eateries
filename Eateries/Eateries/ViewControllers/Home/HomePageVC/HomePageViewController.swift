//
//  HomePageViewController.swift
//  Eateries
//
//  Created by DUY on 12/6/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import KRPullLoader
import Firebase
import ProgressHUD
import Kingfisher

class HomePageViewController: UIViewController {
    @IBOutlet weak var cvwDetails: UICollectionView!
    private let loadMoreView = KRPullLoadView()
    private let refreshView = KRPullLoadView()
    fileprivate var current_Page:Int = 1
    fileprivate var total_pages:Int = 0
    fileprivate var arrPost = [Post]()
    let auth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
        self.setupCollectionView()
        loadChangeData()
    }
    //MARK:- Support functions
    private func setupLayout() {
        tabBarController?.tabBar.isHidden = false
        self.navigationItem.title = "Home"
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
    
    @IBAction func showMap(_ sender: UIButton) {
        let showMap = Storyboard.home.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
        self.navigationItem.title = ""
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(showMap!, animated: true)
    }
    
    //MARK:- Firebase Functions
    
    func loadChangeData(){
        self.arrPost.removeAll()
        loadData()
    }
    
    func loadData(){
        Firebase.shared.getDataPost(TableName.Table, .childAdded) { [weak self] (postData, key, error) in
            guard let strongSelf = self else { return }
            if error == nil {
                guard let postData = postData else { return }
                if let currentUserID = strongSelf.auth.currentUser?.uid {
                    if postData.likes != nil {
                        postData.isLiked = postData.likes![currentUserID] != nil
                    }
                }
                strongSelf.arrPost.append(postData)
                DispatchQueue.main.async {
                    ProgressHUD.showSuccess()
                    strongSelf.cvwDetails.reloadData()
                }
            } else {
                ProgressHUD.showError(error)
            }
        }
    }
    
    
}
//MARK:- CollectionView Datasource & Delegate
extension HomePageViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageCell", for: indexPath) as! HomePageCollectionViewCell
        let post = arrPost[indexPath.row]
        cell.lblName.text  = post.nameEateries
        cell.lblLocation.text = post.address
        if let urlImage = post.urlImage{
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
        let detailVC = Storyboard.detail.instantiateViewController(ofType: DetailEateriesVC.self)
        detailVC.post = post
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
}
// MARK: - KRPullLoader Delegate
extension HomePageViewController: KRPullLoadViewDelegate {
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
