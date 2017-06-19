//
//  HeadlineModel.swift
//  BPNBTV
//
//  Created by Raditya on 6/19/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import Foundation
import SwiftyJSON
struct HeadlineModels:ResponseObjectSerializable{
    let headlines:[HeadlineModel]!
    init?(response: HTTPURLResponse, representation: Any) {
        if(response.statusCode == 200){
            guard let rep =  representation as? [String:Any] else{return nil}
            guard let jsonObject =  JSON(rep) as JSON? else{return nil}
            let _temp = jsonObject["headline"].arrayValue
            if(_temp.count == 0){
                return nil
            }
            var _tempHeadlines = [HeadlineModel]()
            for value in _temp {
                //items.append(Menu(_parent: value["parent"].stringValue, _menu: value["menu"].stringValue)!)
                _tempHeadlines.append(HeadlineModel(id: value["id"].stringValue, video: value["video"].stringValue, youtube: value["youtube"].stringValue))
            }
            self.headlines  = _tempHeadlines
        }else{
            return nil
        }
    }
}


struct HeadlineModel:ResponseObjectSerializable{
    let id:String!
    let video:String!
    let youtube:String!
    init?(response: HTTPURLResponse, representation: Any) {
        if(response.statusCode != 200){ return nil}
        guard let rep = representation as? [String:Any]
            else{ return nil}
        self.id = rep["id"] as? String
        self.video = rep["video"] as? String
        self.youtube = rep["youtube"] as? String
    }
    
    init(id:String="",video:String="",youtube:String="") {
        self.id = id
        self.video = video
        self.youtube = youtube
        
    }
}
