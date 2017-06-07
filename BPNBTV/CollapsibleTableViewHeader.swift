//
//  CollapsibleTableViewHeader.swift
//  BPNBTV
//
//  Created by Raditya on 4/12/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import Foundation
import UIKit

import UIKit
protocol CollapsibleTableViewHeaderDelegate {
    func toggleSection(header: CollapsibleTableViewHeader, section: Int)
}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView {
    
    var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0
    
    let titleLabel = UILabel()
    //let arrowLabel = UILabel()
    let arrowImage = UIImageView()
    let separatorView = UIView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        //
        // Constraint the size of arrow label for auto layout
        //
        if #available(iOS 9.0, *) {
            //arrowLabel.widthAnchor.constraintEqualToConstant(12).active = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 9.0, *) {
            //arrowLabel.heightAnchor.constraintEqualToConstant(12).active = true
        } else {
            // Fallback on earlier versions
        }
        
        /*titleLabel.translatesAutoresizingMaskIntoConstraints = false
         arrowImage.translatesAutoresizingMaskIntoConstraints = false
         separatorView.translatesAutoresizingMaskIntoConstraints = false*/
        
        
        
        
        //titleLabel.font = UIFont.init(name: "Bliss2-Regular", size: 13.5)
        arrowImage.image = UIImage(named: "icon_expand_caret")
        separatorView.frame = CGRect(x: 0, y: 43.5, width: getScreenWidth() - 16, height: 0.5)
        setContentFrame()
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImage)
        contentView.addSubview(separatorView)
        
        //
        // Call tapHeader when tapping on this header
        //
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsibleTableViewHeader.tapHeader(gestureRecognizer:))))
    }
    
    func setContentFrame(){
        titleLabel.frame = CGRect(x: 8, y: (44 - 20)/2, width: 200, height: 20)
        arrowImage.frame = CGRect(x:getScreenWidth() - 40,y: (44 - 5)/2, width:10,height: 5)
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.backgroundColor = UIColor.white//UIColor.colorFromCode(0x2E3944)
        
        titleLabel.textColor = UIColor.gray//UIColor.whiteColor()
        //arrowLabel.textColor = UIColor.trimegahGray()//UIColor.whiteColor()
        //arrowImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        separatorView.backgroundColor = UIColor.white
    }
    
    //
    // Trigger toggle section when tapping on the header
    //
    func tapHeader(gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {
            return
        }
        
        delegate?.toggleSection(header: self, section: cell.section)
    }
    
    func setCollapsed(collapsed: Bool) {
        //
        // Animate the arrow rotation (see Extensions.swf)
        //
        //arrowLabel.rotate(collapsed ? 0.0 : CGFloat(M_PI_2))
        //arrowLabel.setRotationX(collapsed ? 0.0 : CGFloat(M_PI_2))
        
        arrowImage.transform = CGAffineTransform(rotationAngle: collapsed ? 0.0 : CGFloat(Double.pi))
    }
    
}
