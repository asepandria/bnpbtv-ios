//
//  RequestHelper.swift
//  BPNBTV
//
//  Created by Raditya on 6/19/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class RequestHelper{
    static let requestManager = Alamofire.SessionManager.default
    
    class func requestAndUpdateMainMenu(callback:((Bool,String?) -> Void)? ){
        _ = RequestHelper.requestManager.request(BRouter.commonRequest(parameters: ["function":"menu"])).responseObject(queue: DispatchQueue.global()){(response:DataResponse<MenuItems>) in
            do{
                
                let menuItems = try response.result.unwrap() as MenuItems
                let dictMenu = menuItems.items.map({[$0.parent ?? "":$0.menu ?? ""]})
                UserDefaults.standard.set(dictMenu, forKey: "MENU")
                callback?(true,nil)
            }catch{
                //Catch Error Menu And Display it to user
                //debugPrint("Error Retrieving Menu Data : Response -> \(response.error.debugDescription)")
                callback?(false,response.error?.localizedDescription)
            }
        }
    }
    
    class func requestListBasedOnCategory(params:[String:String],callback:((Bool,String?,VideoItems?) -> Void)?){
        _ = RequestHelper.requestManager.request(BRouter.commonRequest(parameters: params)).responseObject(queue: DispatchQueue.global()){(response:DataResponse<VideoItems>) in
            do{
                
                let videoItems = try response.result.unwrap() as VideoItems
                callback?(true,nil,videoItems)
            }catch{
                //Catch Error Menu And Display it to user
                //debugPrint("Error Retrieving Menu Video Items : Response -> \(response.error.debugDescription)")
                callback?(false,response.error?.localizedDescription,nil)
            }
        }
    }
    
    class func requestProfile(callback:((Bool,String?,ProfileModel?) -> Void)?){
        _ = RequestHelper.requestManager.request(BRouter.commonRequest(parameters: ["function":"profil"])).responseObject(queue: DispatchQueue.global()){(response:DataResponse<ProfileModel>) in
            do{
                let profile = try response.result.unwrap() as ProfileModel
                callback?(true,nil,profile)
            }catch{
                callback?(false,response.error?.localizedDescription,nil)
            }
        }
    }
    
    
    class func requestHeadlines(callback:((Bool,String?,HeadlineModels?) -> Void)?){
        _ = RequestHelper.requestManager.request(BRouter.commonRequest(parameters:["function":"headline"])).responseObject(queue: DispatchQueue.global()){(response:DataResponse<HeadlineModels>) in
            do{
                let headlineItems = try response.result.unwrap() as HeadlineModels
                callback?(true,nil,headlineItems)
            }catch{
                //Catch Error Menu And Display it to user
                //debugPrint("Error Retrieving Menu Video Items : Response -> \(response.error.debugDescription)")
                callback?(false,response.error?.localizedDescription,nil)
            }
        }
    }
    
    class func requestContact(callback:((Bool,String?,KontakModel?) -> Void)?){
        _ = RequestHelper.requestManager.request(BRouter.commonRequest(parameters:["function":"kontak"])).responseObject(queue: DispatchQueue.global()){(response:DataResponse<KontakModel>) in
            do{
                let kontak = try response.result.unwrap() as KontakModel
                callback?(true,nil,kontak)
            }catch{
                callback?(false,response.error?.localizedDescription,nil)
            }
        }
    }
}
