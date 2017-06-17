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
protocol SideMenuToContainerDelegate:class {
    func selectedMenu(menuName:String)
}
class ContainerViewController:UIViewController{
    var menuLeftNavigationController:UISideMenuNavigationController!
    var newMenuVC:NewMenuVC!
    let PAGEROW = 10
    var page = 0
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Constants.requestAndUpdateMainMenu(callback: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newMenuVC  = storyboard!.instantiateViewController(withIdentifier: "NewMenuVC") as! NewMenuVC
        newMenuVC?.menuSelectedDelegate = self
        menuLeftNavigationController = UISideMenuNavigationController(rootViewController: newMenuVC)
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.menuRightNavigationController = nil
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: (self.navigationController?.navigationBar)!, forMenu: UIRectEdge.left)
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuPresentMode = SideMenuManager.MenuPresentMode.menuSlideIn
        
        printLog(content: "test")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sideMenuAction(_ sender: UIBarButtonItem) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
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

extension ContainerViewController:SideMenuToContainerDelegate{
    func selectedMenu(menuName: String) {
        //menuName.lowercased()
        Constants.requestListBasedOnCategory(params: ["function":"video","category":menuName.lowercased()], callback: {[weak self](isSuccess,reason,videoItems) in
            //self?.printLog(content: "\(String(describing: videoItems))")
        })
    }
}
