//
//  UIViewController.swift
//  BPNBTV
//
//  Created by Raditya on 4/6/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController{
    func removeBottomBorderNavigationBar(){
        if let _ = navigationController{
            for parent in navigationController!.view.subviews {
                for child in parent.subviews {
                    for view in child.subviews {
                        if view is UIImageView && view.frame.height == 0.5 {
                            view.alpha = 0
                        }
                    }
                }
            }
        }
    }
    
    func getNavigationBarHeight() -> CGFloat{
        if let bar = navigationController?.navigationBar{
            return bar.frame.height
        }
        return 0
    }
}
