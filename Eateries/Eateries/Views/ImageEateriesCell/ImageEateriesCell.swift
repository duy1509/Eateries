//
//  ImageEateriesCell.swift
//  Eateries
//
//  Created by DUY on 12/8/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
import Kingfisher

class ImageEateriesCell: UITableViewCell {
    
    @IBOutlet weak var cvwImageDeatil: UICollectionView!
    var completionHandler:((_ indexPath:IndexPath)->())?
    let auth = Auth.auth()
    let ref = Database.database().reference()
    let storage = Storage.storage().reference(forURL: "gs://eateries-eae99.appspot.com/")
    var arrImage:[String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCollectionView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    private func setupCollectionView(){
        cvwImageDeatil.delegate = self
        cvwImageDeatil.dataSource = self
        
        //Setup layout for item in collectionview
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        cvwImageDeatil.collectionViewLayout = layout
        
    }
    
    func configCell(_ post: Post) {
        arrImage = post.arrString
        DispatchQueue.main.async {
            self.cvwImageDeatil.reloadData()
        }
    }
}
// MARK: - CollectionView Datasouce & Delegate
extension ImageEateriesCell:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageEateriesCollectionViewCell
        let url = URL(string: arrImage[indexPath.row])
        cell.imgEateries.kf.setImage(with: url)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let actionClick = self.completionHandler else { return }
        actionClick(indexPath)
        
    }
    
}

