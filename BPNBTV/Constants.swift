//
//  Constants.swift
//  BPNBTV
//
//  Created by Raditya Maulana on 4/2/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import Foundation
import UIKit

class Constants{
    static let screenSize = UIScreen.main.bounds
    static let screenWidth = screenSize.width
    static let screenHeight = screenSize.height
    static let contentListLimit = 10
    static let API_URL = "http://www.bnpbindonesia.tv/api/"
    static let playerVars = ["enablejsapi":1,
                      "autoplay":1,
                      "controls":1,
                      "playsinline":1,
                      "showinfo"       : 0,
                      "rel"            : 0,
                      //@"origin"         : @"https://www.example.com", // this is critical
        "modestbranding" : 1]
    
    static let langKey = "langKey"
    static let langID = 0
    static let langEN = 1
}
