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
    static let pushAlert = "alert"
    static let pushHeadline = "headline"
    static let screenSize = UIScreen.main.bounds
    static let screenWidth = screenSize.width
    static let screenHeight = screenSize.height
    static let contentListLimit = 10
    static let API_URL = "http://www.bnpbindonesia.tv/api/"
    static let GMAP_API_KEY = "AIzaSyBOT5sh-UqEINFc8VD5CwDFXLZbOK2rYCY"
    static let GMAP_GEOCODING_API_KEY = "AIzaSyBc8ihrXC5gKVimDpyPnT9jKrB5Me9Dt4U"
    //https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=AIzaSyBc8ihrXC5gKVimDpyPnT9jKrB5Me9Dt4U
    static let GMAP_GEOCODING_URL = "https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=AIzaSyBc8ihrXC5gKVimDpyPnT9jKrB5Me9Dt4U"
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
