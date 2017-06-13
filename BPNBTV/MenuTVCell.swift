//
//  MenuTVCell.swift
//  BPNBTV
//
//  Created by Raditya on 4/7/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import UIKit

class MenuTVCell: UITableViewCell {
    static let CIRCLE_VIEW_RADIUS:CGFloat = 4
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var menuLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupViews(){
        circleView.layer.cornerRadius = circleView.frame.width/2
    }

}
