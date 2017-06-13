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
        Constants.requestAndUpdateMainMenu(callback: nil)
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
