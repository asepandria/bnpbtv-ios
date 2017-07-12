//
//  NSObject.swift
//  BPNBTV
//
//  Created by Raditya on 6/7/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import Foundation
import UIKit

extension NSObject{
    open func printLog(content:Any){
        //debugPrint("BNPB-LOG :: \(content)")
    }
    
    open func getScreenWidth()->CGFloat{
        let mainScreen = UIScreen.main
        return mainScreen.bounds.width
    }
    
    open func getScreenHeight()->CGFloat{
        let mainScreen = UIScreen.main
        return mainScreen.bounds.height
    }
}
