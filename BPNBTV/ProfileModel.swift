//
//  ProfileModel.swift
//  BPNBTV
//
//  Created by Raditya on 6/18/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ProfileModel:ResponseObjectSerializable {
    let title:String!
    let video:String!
    let youtube:String!
    let desc:String!
    
    init?(response: HTTPURLResponse, representation: Any) {
        if(response.statusCode != 200){ return nil}
        guard let rep = representation as? [String:Any]
            else{ return nil}
        self.title = rep["title"] as? String
        self.video = rep["video"] as? String
        self.youtube = rep["youtube"] as? String
        self.desc = rep["desc"] as? String
    }
}
