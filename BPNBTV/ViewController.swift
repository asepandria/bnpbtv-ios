//
//  ViewController.swift
//  BPNBTV
//
//  Created by Raditya Maulana on 3/18/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Constants.requestManager.request(BRouter.commonRequest(parameters: ["function":"menu"])).responseObject{(response:DataResponse<MenuItems>) in
            do{
                let menuItems = try response.result.unwrap() as MenuItems
                let dictMenu = menuItems.items.map({[$0.parent ?? "":$0.menu ?? ""]})
                UserDefaults.standard.set(dictMenu, forKey: "MENU")
                UserDefaults.standard.synchronize()
                self.setupSideMenu(menuItems: menuItems.items)
            }catch{
                
            }
            //debugPrint(response.result)
            //self.setupSideMenu(response.result)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupSideMenu(menuItems:[Menu]){
        // Define the menus
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        /*if let topLeftMenu = SideMenuManager.menuLeftNavigationController?.topViewController{
            if(topLeftMenu.isKind(of: MenuTV.classForCoder())){
                (topLeftMenu as! MenuTV).menuItems = menuItems
            }
        }*/
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.menuPresentMode = .menuSlideIn
    }

}

