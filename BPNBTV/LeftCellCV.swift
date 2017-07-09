//
//  LeftCellCV.swift
//  BPNBTV
//
//  Created by Raditya on 6/28/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import UIKit

class LeftCellCV: UICollectionViewCell {
    @IBOutlet weak var imageList: UIImageView!
    @IBOutlet weak var titleList: UILabel!
    @IBOutlet weak var contentList: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.bnpbLightGrayColor().cgColor
        self.layer.cornerRadius = 1
        
        imageList.contentMode = UIViewContentMode.scaleToFill
    }
}
