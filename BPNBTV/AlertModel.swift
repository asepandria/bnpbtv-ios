//
//  AlertModel.swift
//  BPNBTV
//
//  Created by Raditya on 7/10/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import Foundation
import SwiftyJSON
struct AlertItemsModel:ResponseObjectSerializable {
    let alertModel:[AlertModel]!
    init?(response: HTTPURLResponse, representation: Any) {
        if(response.statusCode == 200){
            guard let rep =  representation as? [String:Any] else{return nil}
            guard let jsonObject =  JSON(rep) as JSON? else{return nil}
            let _temp = jsonObject["items"].arrayValue
            if _temp.count <= 0{
                alertModel = [AlertModel]()
            }else{
                var tempAlert = [AlertModel]()
                var tempImageArr = [String]()
                for value in _temp{
                    tempImageArr.removeAll()
                    //print("VALUE : \(value)")
                    let imageSingle = value["slider"]["image"].stringValue 
                    if let imageArrTemp = value["slider"]["image"].arrayValue as [JSON]?{
                        for iat  in imageArrTemp{
                            tempImageArr.append(iat.stringValue)
                        }
                    }
                    tempAlert.append(AlertModel(_imageSliderURLArr: tempImageArr, _imageSliderSingle: imageSingle, _id: value["id"].stringValue, _title: value["title"].stringValue, _date: value["date"].stringValue, _address: value["address"].stringValue, _longlat: value["longlat"].stringValue, _scale: value["scale"].stringValue, _description: value["description"].stringValue, _shortURL: value["short_url"].stringValue))
                }
                alertModel = tempAlert
            }
            
        }else{
            return nil
        }
    }
    
}
struct AlertModel:ResponseObjectSerializable{
    let imageSliderURLArr:[String]!
    let imageSliderSingle:String!
    let id:String!
    let title:String!
    let date:String!
    let address:String!
    let longlat:String!
    let scale:String!
    let description:String!
    let shortURL:String!
    init?(response: HTTPURLResponse, representation: Any) {
        if(response.statusCode != 200){ return nil}
        guard let rep = representation as? [String:Any]
            else{ return nil}
        self.id = rep["id"] as? String
        self.title = rep["title"] as? String
        self.date = rep["date"] as? String
        self.address = rep["address"] as? String
        self.longlat = rep["longlat"] as? String
        self.scale = rep["scale"] as? String
        self.description = rep["description"] as? String
        self.shortURL = rep["short_url"] as? String
        self.imageSliderSingle = rep["image"] as? String
        self.imageSliderURLArr = rep["image"] as? [String]
    }
    init(_imageSliderURLArr:[String] = [String](),
         _imageSliderSingle:String = "",
         _id:String = "",
         _title:String = "",
         _date:String = "",
         _address:String = "",
         _longlat:String = "",
         _scale:String = "",
         _description:String = "",
         _shortURL:String = "") {
        self.imageSliderURLArr = _imageSliderURLArr
        self.imageSliderSingle = _imageSliderSingle
        self.id = _id
        self.title = _title
        self.date = _date
        self.address = _address
        self.longlat = _longlat
        self.scale = _scale
        self.description = _description
        self.shortURL = _shortURL
    }
}
