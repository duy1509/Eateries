//
//  EateriesNearHostelCell.swift
//  Eateries
//
//  Created by DUY on 12/8/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit

class EateriesNearHostelCell: UITableViewCell {

    @IBOutlet weak var cvwEateries: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func setupCollectionView() {
        cvwEateries.delegate = self
        cvwEateries.dataSource = self
        //Setup layout for item in collectionview
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.contentView.frame.size.width, height: 181)
        layout.scrollDirection = .vertical
        cvwEateries.collectionViewLayout = layout
        cvwEateries.isScrollEnabled = false
        
        //Register cell for collectionView
        let nib = UINib(nibName: "HomePageCell", bundle: nil)
        cvwEateries.register(nib, forCellWithReuseIdentifier: "HomePageCell")
    }

}
extension EateriesNearHostelCell: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageCell", for: indexPath) as! HomePageCollectionViewCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.contentView.frame.size.width, height: 181)
    }
    
}
