//
//  ImageCollectionViewCell.swift
//  Eateries
//
//  Created by DUY on 12/8/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgHinh: UIImageView!
    func configCell(_ image: UIImage) {
        imgHinh.image = image
    }

}
