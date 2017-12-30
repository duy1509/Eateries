//
//  DetailEateriesVC.swift
//  Eateries
//
//  Created by DUY on 12/8/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
import Kingfisher
import AXPhotoViewer

class DetailEateriesVC: UIViewController {
    @IBOutlet weak var tbvDetail: UITableView!
    var post:Post?
    var arrPost:[Post] = []
    fileprivate var colHeight:CGFloat = 0.0
    fileprivate var detailTextViewHeight:CGFloat = 0.0
    fileprivate var isReload = false
    var arrUserLike:[Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        self.tabBarController?.tabBar.isHidden = false
        setupNavigation()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTableView()
        setupLayout()
    }
    
    // MARK: - Support functions
    
    private func setupTableView() {
        tbvDetail.delegate = self
        tbvDetail.dataSource = self
        tbvDetail.separatorStyle = .none
    }
    private func setupLayout() {
        tabBarController?.tabBar.isHidden = false
        self.navigationItem.title = self.post?.nameEateries
    }
    
    private func setupNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrowLeftSimpleLineIcons"), style: .done, target: self, action: #selector(DetailEateriesVC.dismissView))
        self.navigationItem.title = self.post?.nameEateries
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // MARK: - Action buttons
    @objc func dismissView() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Firebase Functions
    
    func loadData(){
        guard let post = post else { return }
        arrPost.append(post)
    }
}
// MARK: - Tableview Datasource and Delegate
extension DetailEateriesVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let post = post else { return UITableViewCell() }
        switch indexPath.row {
        case 0:
            let headerCell = tableView.dequeueReusableCell(ofType: HeaderImageCell.self, at: indexPath)
            headerCell.post = post
            headerCell.configHeaderCell(post)
            headerCell.acctionButtonLike = {  sender in
                
            }
            headerCell.selectionStyle = .none
            
            return headerCell
        case 1:
            let detailCell = tableView.dequeueReusableCell(ofType: DetailCell.self, at: indexPath)
            detailCell.configCell(post)
            detailCell.contentView.layoutIfNeeded()
            return detailCell
        case 2:
            let showLocation = tableView.dequeueReusableCell(ofType: ShowLocation.self, at: indexPath)
            showLocation.acctionbuttonShowMap = { [weak self] in
                guard let strongSelf = self else { return }
                let mapVC = Storyboard.home.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
                strongSelf.navigationItem.title = ""
                mapVC?.postDirection = strongSelf.post
                mapVC?.isDirection = true
                strongSelf.hidesBottomBarWhenPushed = true
                strongSelf.navigationController?.pushViewController(mapVC!, animated: true)
            }
            
            return showLocation
        case 3:
            let imageDetailCell = tableView.dequeueReusableCell(ofType: ImageEateriesCell.self, at: indexPath)
            imageDetailCell.configCell(post)
            imageDetailCell.completionHandler = { (index) in
                
            }
            return imageDetailCell
        default:
            let eateriesNearHostelCell = tableView.dequeueReusableCell(ofType: EateriesNearHostelCell.self, at: indexPath)
            return eateriesNearHostelCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 181
        case 1:
            return 300
        case 2 :
            return 50
        case 3:
            return 130
        case 4:
            return 466
        default:
            return 0
        }
    }
}

