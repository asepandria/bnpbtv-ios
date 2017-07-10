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
import PKHUD
protocol SideMenuToContainerDelegate:class {
    func selectedMenu(menuName:String)
    func searchSelected(keyword:String)
}
enum MENU_CLASS:String{
    case HOME = "home"
    case PROFILE = "profile"
    case PROFIL = "profil"
    case COLLECTION = "collection"
    case KONTAK_KAMI = "kontak kami"
    case BERITA_BENCANA = "berita bencana"
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
        
        selectedMenu(menuName: "HOME")
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: getScreenWidth()/3))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "bnpbtv")
        imageView.image = image
        navigationItem.titleView = imageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sideMenuAction(_ sender: UIBarButtonItem) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
        newMenuVC.searchTF.becomeFirstResponder()
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
extension ContainerViewController{
    func removeChildViewControllers(){
        if childViewControllers.count > 0{
            for cvc in childViewControllers{
                cvc.willMove(toParentViewController: nil)
                cvc.view.removeFromSuperview()
                cvc.removeFromParentViewController()
            }
        }
    }
}

extension ContainerViewController:SideMenuToContainerDelegate{
    func searchSelected(keyword: String) {
        self.removeChildViewControllers()
        let contentStoryBoard = UIStoryboard(name: "Content", bundle: nil)
        let collectionVC = contentStoryBoard.instantiateViewController(withIdentifier: "CollectionViewController") as! CollectionViewController
        collectionVC.isSearch = true
        collectionVC.keyWord = keyword
        addChildViewController(collectionVC)
        collectionVC.view.frame = CGRect(x:0, y:0, width:view.frame.size.width, height:view.frame.size.height);
        view.addSubview(collectionVC.view)
        collectionVC.didMove(toParentViewController:self)
    }
    func selectedMenu(menuName: String) {
        
        
        removeChildViewControllers()
        let contentStoryBoard = UIStoryboard(name: "Content", bundle: nil)
        self.removeChildViewControllers()
        if(menuName.lowercased() == MENU_CLASS.HOME.rawValue){
            HUD.show(HUDContentType.progress)
            RequestHelper.requestListBasedOnCategory(params: ["function":"video"], callback: {[weak self](isSuccess,reason,videoItems) in
                DispatchQueue.main.async {
                    HUD.hide()
                    if isSuccess{
                        if let _self = self{
                            let homeVC = contentStoryBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                            _self.addChildViewController(homeVC)
                            homeVC.view.frame = CGRect(x:0, y:0, width:_self.view.frame.size.width, height:_self.view.frame.size.height);
                            _self.view.addSubview(homeVC.view)
                            homeVC.didMove(toParentViewController: _self)
                        }
                    }else{
                        AlertHelper.showErrorAlert(message: reason ?? "")
                    }
                    
                }
                
            })
            
        }else if(menuName.lowercased() == MENU_CLASS.PROFILE.rawValue ||
            menuName.lowercased() == MENU_CLASS.PROFIL.rawValue){
            HUD.show(HUDContentType.progress)
            RequestHelper.requestProfile(callback: {[weak self](isSuccess,reason,profile) in
                DispatchQueue.main.async {
                    HUD.hide()
                    if isSuccess{
                        if let _self = self{
                            let profileVC = contentStoryBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                            profileVC.profileModel = profile
                            _self.addChildViewController(profileVC)
                            profileVC.view.frame = CGRect(x:0, y:0, width:_self.view.frame.size.width, height:_self.view.frame.size.height)
                            _self.view.addSubview(profileVC.view)
                            profileVC.didMove(toParentViewController: _self)
                            
                        }
                    }else{
                        AlertHelper.showErrorAlert(message: reason ?? "")
                    }
                    
                }
            })
            
        }else if(menuName.lowercased() == MENU_CLASS.KONTAK_KAMI.rawValue){
            HUD.show(HUDContentType.progress)
            RequestHelper.requestContact(callback: {[weak self](isSuccess,reason,kontak) in
                DispatchQueue.main.async {
                    HUD.hide()
                    if isSuccess{
                        if let _ = self{
                            let kontakVC = contentStoryBoard.instantiateViewController(withIdentifier: "KontakViewController") as! KontakViewController
                            kontakVC.kontakString = (kontak?.kontakString) ?? ""
                            self!.addChildViewController(kontakVC)
                            
                            kontakVC.view.frame = CGRect(x:0, y:0, width:self!.view.frame.size.width, height:self!.view.frame.size.height)
                            self!.view.addSubview(kontakVC.view)
                            kontakVC.didMove(toParentViewController: self!)
                        }
                        
                    }else{
                       AlertHelper.showErrorAlert(message: reason ?? "")
                    }
                }
            
            })
            
            
        }else if (menuName.lowercased() == MENU_CLASS.BERITA_BENCANA.rawValue){
            let collectionVC = contentStoryBoard.instantiateViewController(withIdentifier: "CollectionViewController") as! CollectionViewController
            collectionVC.isAlertList = true
            collectionVC.selectedCategory = menuName.lowercased()
            addChildViewController(collectionVC)
            collectionVC.view.frame = CGRect(x:0, y:0, width:view.frame.size.width, height:view.frame.size.height);
            view.addSubview(collectionVC.view)
            collectionVC.didMove(toParentViewController:self)
        }
        else{
            //this is collection
            /*RequestHelper.requestListBasedOnCategory(params: ["function":"video"], callback: {[weak self](isSuccess,reason,videoItems) in
                DispatchQueue.main.async {
                    HUD.hide()
                    if isSuccess{
                        if let _self = self{
                            let collectionVC = contentStoryBoard.instantiateViewController(withIdentifier: "CollectionViewController") as! CollectionViewController
                            _self.addChildViewController(collectionVC)
                            collectionVC.view.frame = CGRect(x:0, y:0, width:_self.view.frame.size.width, height:_self.view.frame.size.height);
                            _self.view.addSubview(collectionVC.view)
                            collectionVC.didMove(toParentViewController: _self)
                        }
                    }else{
                        AlertHelper.showErrorAlert(message: reason ?? "")
                    }
                    
                }
            })*/
            
            let collectionVC = contentStoryBoard.instantiateViewController(withIdentifier: "CollectionViewController") as! CollectionViewController
            collectionVC.selectedCategory = menuName.lowercased()
            addChildViewController(collectionVC)
            collectionVC.view.frame = CGRect(x:0, y:0, width:view.frame.size.width, height:view.frame.size.height);
            view.addSubview(collectionVC.view)
            collectionVC.didMove(toParentViewController:self)
            
        }
        
    }
    
    func assignViewController(viewController:UIViewController){
        
    }
    
}
