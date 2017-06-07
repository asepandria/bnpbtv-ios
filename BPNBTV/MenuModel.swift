//
//  MenuModel.swift
//  BPNBTV
//
//  Created by Raditya on 4/5/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import Foundation
import SwiftyJSON

struct MenuItems:ResponseObjectSerializable {
    var items:[Menu] = [Menu]()
    init?(response: HTTPURLResponse, representation: Any) {
        if(response.statusCode == 200){
            guard let rep =  representation as? [String:Any] else{return nil}
            guard let jsonObject =  JSON(rep) as JSON? else{return nil}
            let _temp = jsonObject["items"].arrayValue
            if(_temp.count == 0){
                return nil
            }
            for value in _temp {
                items.append(Menu(_parent: value["parent"].stringValue, _menu: value["menu"].stringValue)!)
            }
        }else{
            return nil
        }
    }
}

struct Menu:ResponseObjectSerializable {
    let parent:String!
    let menu:String!
    let hasChild:Bool!
    init?(response: HTTPURLResponse, representation: Any) {
        if(response.statusCode != 200){ return nil}
        guard let rep = representation as? [String:Any]
        else{ return nil}
        let _parent = rep["parent"] as? String
        let _menu = rep["menu"] as? String
        self.menu = _menu
        self.parent = _parent
        self.hasChild = false
    }
    
    init?(_parent:String="main",_menu:String="",_hasChild:Bool=false){
        self.menu = _menu
        self.parent = _parent
        self.hasChild = _hasChild
    }
}

