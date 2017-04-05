//
//  ContainerViewController.swift
//  BPNBTV
//
//  Created by Raditya on 4/6/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import Alamofire
class ContainerViewController:SlideMenuController  {
    
    /*override func awakeFromNib() {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "Main") {
            self.mainViewController = controller
        }
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "MenuTV") {
            self.leftViewController = controller
        }
        super.awakeFromNib()
    }*/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAndUpdateMainMenu()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func isTagetViewController() -> Bool {
        if let vc = UIApplication.topViewController() {
            if vc is MainViewController {
                return true
            }
        }
        return false
    }
    
    override func track(_ trackAction: TrackAction) {
        switch trackAction {
        case .leftTapOpen:
            debugPrint("TrackAction: left tap open.")
        case .leftTapClose:
            debugPrint("TrackAction: left tap close.")
        case .leftFlickOpen:
            debugPrint("TrackAction: left flick open.")
        case .leftFlickClose:
            debugPrint("TrackAction: left flick close.")
        case .rightTapOpen:
            debugPrint("TrackAction: right tap open.")
        case .rightTapClose:
            debugPrint("TrackAction: right tap close.")
        case .rightFlickOpen:
            debugPrint("TrackAction: right flick open.")
        case .rightFlickClose:
            debugPrint("TrackAction: right flick close.")
        }
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
