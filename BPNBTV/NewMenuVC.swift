//
//  NewMenuVC.swift
//  BPNBTV
//
//  Created by Raditya on 6/8/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import UIKit
import SideMenu
protocol MenuSelectedDelegate:class {
    //func menuSelected()
    func menuTapped(menu:Menu)
}
class NewMenuVC: UIViewController {
    var menuItems:[Menu] = [Menu]()
    //var menuItemsChild:[String:[Menu]] = [String:[Menu]]()
    var menuItemsChild = OrderedDict<String,[Menu]>()
    weak var menuSelectedDelegate:SideMenuToContainerDelegate?
    var headerTB:CollapsibleTableViewHeader?
    var sections = [MenuSection]()
    //var mainViewController: UIViewController!
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTF?.text = ""
    }
    func setupViews(){
        
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationBarColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        removeBottomBorderNavigationBar()
        
        menuTable.register(UINib(nibName: "MenuTVCell", bundle: nil), forCellReuseIdentifier: "menuTVCell")
        menuTable.showsVerticalScrollIndicator = false
        menuTable.showsHorizontalScrollIndicator = false
        menuTable.contentInset = UIEdgeInsets.zero
        menuTable.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        menuTable.tableFooterView = UIView(frame:CGRect.zero)
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
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        headerTB?.delegate = nil
        headerTB = nil
    }
    func setMenuData(){
        if sections.count > 0{return}
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
                            if !menuItemsChild.keys.contains(key){
                                menuItemsChild[key] = [child]
                            }
                            
                        }
                    }
                }
                
            }
            //parse the menu again
            for key in menuItemsChild.keys{
                if key.lowercased() == "main"{
                    for child in menuItemsChild[key]!{
                        if !(sections.contains(where: {
                            return  $0.name.lowercased() == child.menu.lowercased()
                        })){
                            
                            if child.hasChild{
                                sections.append(MenuSection(name: key, items: menuItemsChild[key]! ))
                            }else{
                                sections.append(MenuSection(name: child.menu, items: []))
                            }
                        }
                    }
                }else{
                    if let index = sections.index(where: { (item) -> Bool in
                        item.name.lowercased() == key.lowercased()
                    }){
                        //printLog(content: "INDEX : \(index)......item name : \(key)")
                        sections[index].items = menuItemsChild[key]!
                    }else{
                        sections.append(MenuSection(name: key, items: menuItemsChild[key]! ))
                    }
                }
            }
            menuTable.reloadData()
        }else{
            printLog(content: "Empty Menu")
            requestMenu()
        }
        
        
        
    }
    
    func requestMenu(){
        Constants.requestAndUpdateMainMenu(callback: {[weak self] (isSuccess,reason) in
            if isSuccess{
                self?.setMenuData()
            }else{
                Constants.showErrorAlert(message: reason ?? "")
            }
        })
    }
    
    deinit {
        printLog(content:"NEW MENU TV DESTROYED")
    }

}
