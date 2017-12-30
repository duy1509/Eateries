//
//  ShowLocation.swift
//  Eateries
//
//  Created by DUY on 12/8/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit

class ShowLocation: UITableViewCell {
    var acctionbuttonShowMap:(()->(Void))? = nil

    @IBOutlet weak var txtLocation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func Show(_ sender: UIButton) {
        guard let acctionShow = self.acctionbuttonShowMap else{return}
        acctionShow()
        
    }
}
