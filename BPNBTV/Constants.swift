//
//  Constants.swift
//  BPNBTV
//
//  Created by Raditya Maulana on 4/2/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class Constants{
    static let screenSize = UIScreen.main.bounds
    static let screenWidth = screenSize.width
    static let screenHeight = screenSize.height
    static let API_URL = "http://www.bnpbindonesia.tv/api/"
    static let requestManager = Alamofire.SessionManager.default
    
    class func requestAndUpdateMainMenu(callback:((Bool,String?) -> Void)? ){
        _ = Constants.requestManager.request(BRouter.commonRequest(parameters: ["function":"menu"])).responseObject(queue: DispatchQueue.global()){(response:DataResponse<MenuItems>) in
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
        _ = Constants.requestManager.request(BRouter.commonRequest(parameters: params)).responseObject(queue: DispatchQueue.global()){(response:DataResponse<VideoItems>) in
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
        _ = Constants.requestManager.request(BRouter.commonRequest(parameters: ["function":"profil"])).responseObject(queue: DispatchQueue.global()){(response:DataResponse<ProfileModel>) in
            do{
                let profile = try response.result.unwrap() as ProfileModel
                callback?(true,nil,profile)
            }catch{
                callback?(false,response.error?.localizedDescription,nil)
            }
        }
    }
    
    class func showErrorAlert(message:String){
        let alert = UIAlertController(title: "ERROR", message:message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
        if let topVC = UIApplication.topViewController(){
            topVC.present(alert, animated: true, completion: nil)
        }
    }
}
