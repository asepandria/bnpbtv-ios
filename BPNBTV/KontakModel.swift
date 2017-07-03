//
//  KontakModel.swift
//  BPNBTV
//
//  Created by Raditya on 7/4/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import Foundation
import SwiftyJSON

struct KontakModel:ResponseObjectSerializable {
    let kontakString:String!
    init?(response: HTTPURLResponse, representation: Any) {
        if(response.statusCode == 200){
            guard let rep =  representation as? [String:Any] else{return nil}
            guard let jsonObject =  JSON(rep) as JSON? else{return nil}
            self.kontakString = jsonObject["kontak"].stringValue
        }else{
            return nil
        }
    }
}
