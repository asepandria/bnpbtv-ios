//
//  VideoModel.swift
//  BPNBTV
//
//  Created by Raditya on 4/6/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import Foundation
import SwiftyJSON
struct VideoItems:ResponseObjectSerializable{
    var videos:[Video]!
    init?(response: HTTPURLResponse, representation: Any) {
        if(response.statusCode == 200){
            guard let rep =  representation as? [String:Any] else{return nil}
            guard let jsonObject =  JSON(rep) as JSON? else{return nil}
            let _temp = jsonObject["video"].arrayValue
            if(_temp.count == 0){
                return nil
            }
            var _tempVideos = [Video]()
            for value in _temp {
                //items.append(Menu(_parent: value["parent"].stringValue, _menu: value["menu"].stringValue)!)
                _tempVideos.append(Video(id: value["id"].stringValue, idVideo: value["idvideo"].stringValue,
                                    category: value["category"].stringValue, judul: value["judul"].stringValue,
                                    judulEN: value["judul_EN"].stringValue, tanggal: value["tanggal"].stringValue,
                                    imageUrl: value["image"].stringValue, videoUrl: value["video"].stringValue,
                                    youtube: value["youtube"].stringValue, description: value["description"].stringValue,
                                    descriptionEN: value["description_EN"].stringValue, aktivasi: value["aktivasi"].stringValue))
            }
            videos = _tempVideos
        }else{
            return nil
        }
    }
}

struct Video:ResponseObjectSerializable {
    let id:String!
    let idVideo:String!
    let category:String!
    let judul:String!
    let judulEN:String!
    let tanggal:String!
    let imageUrl:String!
    let videoUrl:String!
    let youtube:String!
    let description:String!
    let descriptionEN:String!
    let aktivasi:String!
    
    init?(response: HTTPURLResponse, representation: Any) {
        if(response.statusCode != 200){ return nil}
        guard let rep = representation as? [String:Any]
            else{ return nil}
        self.id = rep["id"] as? String
        self.idVideo = rep["idvideo"] as? String
        self.category = rep["category"] as? String
        self.judul = rep["judul"] as? String
        self.judulEN = rep["judul_EN"] as? String
        self.tanggal = rep["tanggal"] as? String
        self.imageUrl = rep["image"] as? String
        self.videoUrl = rep["video"] as? String
        self.youtube = rep["youtube"] as? String
        self.description = rep["description"] as? String
        self.descriptionEN = rep["description_EN"] as? String
        self.aktivasi = rep["aktivasi"] as? String
    }
    
    init(id:String="",idVideo:String="",category:String="",
         judul:String="",judulEN:String="",tanggal:String="",imageUrl:String="",
         videoUrl:String="",youtube:String="",description:String="",descriptionEN:String="",
         aktivasi:String="") {
        self.id = id
        self.idVideo = idVideo
        self.category = category
        self.judul = judul
        self.judulEN = judulEN
        self.tanggal = tanggal
        self.imageUrl = imageUrl
        self.videoUrl = videoUrl
        self.youtube = youtube
        self.description = description
        self.descriptionEN = descriptionEN
        self.aktivasi = aktivasi
    }
}

