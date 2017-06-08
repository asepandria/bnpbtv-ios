//
//  ContainerViewController.swift
//  BPNBTV
//
//  Created by Raditya on 4/6/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import UIKit
import Alamofire
import SideMenu
class ContainerViewController:UIViewController  {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestAndUpdateMainMenu()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "NewMenuVCNav") as! UISideMenuNavigationController
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.menuRightNavigationController = nil
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: (self.navigationController?.navigationBar)!, forMenu: UIRectEdge.left)
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuPresentMode = SideMenuManager.MenuPresentMode.menuSlideIn
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestAndUpdateMainMenu(){
        Constants.requestManager.request(BRouter.commonRequest(parameters: ["function":"menu"])).responseObject(queue: DispatchQueue.global()){[unowned self](response:DataResponse<MenuItems>) in
            do{
                
                let menuItems = try response.result.unwrap() as MenuItems
                let dictMenu = menuItems.items.map({[$0.parent ?? "":$0.menu ?? ""]})
                UserDefaults.standard.set(dictMenu, forKey: "MENU")
                UserDefaults.standard.synchronize()
                
            }catch{
                //Catch Error Menu And Display it to user
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
