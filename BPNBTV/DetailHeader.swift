//
//  DetailHeader.swift
//  BPNBTV
//
//  Created by Raditya on 7/2/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import UIKit
protocol DetailHeaderDelegate {
    func refreshContent()
}
class DetailHeader: UICollectionReusableView {
    @IBOutlet weak var langSegment: UISegmentedControl!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    var detailHeaderDelegate:DetailHeaderDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    func setupViews(){
        if let userDefLang = UserDefaults.standard.integer(forKey: Constants.langKey) as Int?{
            langSegment.selectedSegmentIndex = userDefLang
        }else{
            langSegment.selectedSegmentIndex = Constants.langEN
        }
    }
    @IBAction func langChangeAction(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: Constants.langKey)
        detailHeaderDelegate?.refreshContent()
    }
}
