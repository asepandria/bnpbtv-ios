//
//  NewMenuVC.swift
//  BPNBTV
//
//  Created by Raditya on 6/8/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import UIKit
import SideMenu
protocol MenuSelectedDelegate {
    func menuDidSelected(menu:Menu)
}
class NewMenuVC: UIViewController {
    var menuItems:[Menu] = [Menu]()
    var menuItemsChild:[String:[Menu]] = [String:[Menu]]()
    var menuSelectedDelegate:MenuSelectedDelegate?
    var mainViewController: UIViewController!
    @IBOutlet weak var menuTable: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setMenuData()
        setupViews()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    func setMenuData(){
        if let dictMenu = UserDefaults.standard.object(forKey: "MENU")as! [[String:String]]?{
            for dm in dictMenu{
                for(key,val) in dm{
                    if let child = Menu(_parent:key,_menu:val){
                        if menuItemsChild.keys.contains(key){
                            var temp = menuItemsChild[key]
                            if let su = temp?.filter({$0.menu == val && $0.parent == key}){
                                if(su.count == 0){
                                    temp?.append(child)
                                    menuItemsChild[key] = temp
                                }
                            }
                        }else{
                            menuItemsChild[key] = [child]
                        }
                    }
                    
                }
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTF?.text = ""
    }
    func setupViews(){
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        removeBottomBorderNavigationBar()
        
        menuTable.register(UINib(nibName: "MenuTVCell", bundle: nil), forCellReuseIdentifier: "menuTVCell")
        menuTable.showsVerticalScrollIndicator = false
        menuTable.showsHorizontalScrollIndicator = false
        menuTable.contentInset = UIEdgeInsets.zero
        menuTable.separatorStyle = UITableViewCellSeparatorStyle.none
        menuTable.delegate = self
        menuTable.dataSource = self
        menuTable.reloadData()
        
        let imageSearch = UIImageView(frame: CGRect(x: 0, y: 0, width: searchTF.frame.height, height: searchTF.frame.height))
        imageSearch.image = UIImage(named: "icon_search_blue")
        imageSearch.isUserInteractionEnabled = true
        let searchImageTap = UITapGestureRecognizer(target: self, action: #selector(NewMenuVC.searchTapped(gesture:)))
        searchImageTap.numberOfTapsRequired = 1
        imageSearch.addGestureRecognizer(searchImageTap)
        searchTF.rightView = imageSearch
        searchTF.rightViewMode = UITextFieldViewMode.always
        
    }
    
    
    func searchTapped(gesture:UITapGestureRecognizer){
        printLog(content: "Search Tapped")
        view.endEditing(true)
        //self.slideMenuController()?.closeLeft()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        printLog(content:"NEW MENU TV DESTROYED")
    }

}
