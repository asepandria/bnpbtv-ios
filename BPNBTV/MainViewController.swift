////
////  ViewController.swift
////  BPNBTV
////
////  Created by Raditya Maulana on 3/18/17.
////  Copyright © 2017 Radith. All rights reserved.
////
//
//import UIKit
//import Alamofire
//class MainViewController: UIViewController,MenuSelectedDelegate {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //setNavigationBarItem()
//        /*if let leftMenu = self.slideMenuController()?.leftViewController{
//            if leftMenu.isKind(of: MenuTV.classForCoder()){
//                (leftMenu as! MenuTV).menuSelectedDelegate = self
//            }
//        }*/
//        /*if let leftMenu = self.slideMenuController()?.leftViewController{
//            if leftMenu.isKind(of: NewMenuVC.classForCoder()){
//                (leftMenu as! NewMenuVC).menuSelectedDelegate = self
//            }
//        }*/
//        
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//}
//
//
//extension MainViewController{
//    
//    func addOrRemoveMenuDelegate(shouldRemove:Bool){
//        if(shouldRemove){
//            /*if let topLeftMenu = SideMenuManager.menuLeftNavigationController?.topViewController{
//                if(topLeftMenu.isKind(of: MenuTV.classForCoder())){
//                    (topLeftMenu as! MenuTV).menuSelectedDelegate = nil
//                }
//            }*/
//        }else{
//            /*if let topLeftMenu = SideMenuManager.menuLeftNavigationController?.topViewController{
//                if(topLeftMenu.isKind(of: MenuTV.classForCoder())){
//                    (topLeftMenu as! MenuTV).menuSelectedDelegate = self
//                }
//            }*/
//        }
//    }
//    
//    func menuDidSelected(menu: Menu) {
//        requestContent(menuString: menu.menu)
//    }
//    
//    func requestContent(menuString:String){
//        var params:Parameters = [String:Any]()
//        params["function"] = "video"
//        if(menuString.caseInsensitiveCompare("home") != ComparisonResult.orderedSame){
//            params["category"] = menuString
//        }
//        Constants.requestManager.request(BRouter.commonRequest(parameters:params)).responseObject{[unowned self](response:DataResponse<VideoItems>)  in
//            do{
//                let videoItems = try response.result.unwrap()
//                self.printLog(content:videoItems)
//            }catch{
//                //Catch Error content retrieval and display it to user
//            }
//        }
//    }
//   
//}
//
///*extension MainViewController : SlideMenuControllerDelegate {
//    
//    func leftWillOpen() {
//        //printLog(content:"SlideMenuControllerDelegate: leftWillOpen")
//    }
//    
//    func leftDidOpen() {
//        //printLog(content:"SlideMenuControllerDelegate: leftDidOpen")
//    }
//    
//    func leftWillClose() {
//        //printLog(content:"SlideMenuControllerDelegate: leftWillClose")
//    }
//    
//    func leftDidClose() {
//        //printLog(content:"SlideMenuControllerDelegate: leftDidClose")
//    }
//    
//    func rightWillOpen() {
//        //printLog(content:"SlideMenuControllerDelegate: rightWillOpen")
//    }
//    
//    func rightDidOpen() {
//        //printLog(content:"SlideMenuControllerDelegate: rightDidOpen")
//    }
//    
//    func rightWillClose() {
//        //printLog(content:"SlideMenuControllerDelegate: rightWillClose")
//    }
//    
//    func rightDidClose() {
//        //printLog(content:"SlideMenuControllerDelegate: rightDidClose")
//    }
//}*/
//
//
//
//
//
