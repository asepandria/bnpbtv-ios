//
//  RightCellCV.swift
//  BPNBTV
//
//  Created by Raditya on 6/30/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import UIKit

class RightCellCV: UICollectionViewCell {
    @IBOutlet weak var summaryList: UILabel!
    @IBOutlet weak var titleList: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var buttonContainer: UIView!
    
    var position = 0{
        didSet{
            if position % 4 == 0{
                contentView.backgroundColor = UIColor.bnpbBlueColor()
                containerView.backgroundColor =
                    UIColor.bnpbBlueColor()
                buttonContainer.backgroundColor = UIColor.bnpbDarkBlueColor()
                //setNeedsDisplay()
            }else if position % 2 == 0{
                contentView.backgroundColor = UIColor.bnpbDarkOrangeColor()
                containerView.backgroundColor = UIColor.bnpbDarkOrangeColor()
                buttonContainer.backgroundColor = UIColor.bnpbOrangeColor()
                //setNeedsDisplay()
            }
        }
    }
    override func awakeFromNib() {
        summaryList.frame.size.width = ((getScreenWidth() / 2) - 8)
        titleList.frame.size.width = ((getScreenWidth() / 2) - 8)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.bnpbLightGrayColor().cgColor
        self.layer.cornerRadius = 1
    }
    override func layoutSubviews() {
        /*if position % 2 == 0{
            contentView.backgroundColor = UIColor.bnpbBlueColor()
            containerView.backgroundColor =
                UIColor.bnpbBlueColor()
            //setNeedsDisplay()
        }else{
            contentView.backgroundColor = UIColor.bnpbOrangeColor()
            containerView.backgroundColor = UIColor.bnpbOrangeColor()
            //setNeedsDisplay()
        }*/
    }
}
