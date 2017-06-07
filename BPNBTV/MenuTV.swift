//
//  MenuTV.swift
//  BPNBTV
//
//  Created by Raditya on 4/5/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import UIKit
protocol MenuSelectedDelegate {
    func menuDidSelected(menu:Menu)
}
class MenuTV: UITableViewController {
    var menuItems:[Menu] = [Menu]()
    var menuItemsChild:[String:[Menu]] = [String:[Menu]]()
    var menuSelectedDelegate:MenuSelectedDelegate?
    var mainViewController: UIViewController!
    
    @IBOutlet weak var searchTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        self.tableView.register(UINib(nibName: "MenuTVCell", bundle: nil), forCellReuseIdentifier: "menuTVCell")
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.contentInset = UIEdgeInsets.zero
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        let imageSearch = UIImageView(frame: CGRect(x: 0, y: 0, width: searchTF.frame.height, height: searchTF.frame.height))
        imageSearch.image = UIImage(named: "icon_search_blue")
        imageSearch.isUserInteractionEnabled = true
        let searchImageTap = UITapGestureRecognizer(target: self, action: #selector(MenuTV.searchTapped(gesture:)))
        searchImageTap.numberOfTapsRequired = 1
        imageSearch.addGestureRecognizer(searchImageTap)
        searchTF.rightView = imageSearch
        searchTF.rightViewMode = UITextFieldViewMode.always
    }
    
    func searchTapped(gesture:UITapGestureRecognizer){
        printLog(content: "Search Tapped")
        view.endEditing(true)
        self.slideMenuController()?.closeLeft()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTF?.text = ""
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let dictMenu = UserDefaults.standard.object(forKey: "MENU")as! [[String:String]]?{
            for dm in dictMenu{
                for(key,val) in dm{
                    /*if let _tempMenu = Menu(_parent: key, _menu: val){
                        let su = menuItems.filter({$0.menu == val && $0.parent == key}) as [Menu]
                        if su.count == 0{
                            menuItems.append(_tempMenu)
                        }
                    }*/
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
        tableView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return menuItems.count
        return (menuItemsChild["main"]?.count) ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuTVCell", for: indexPath) as! MenuTVCell
        /*(if(menuItems[indexPath.row].parent.caseInsensitiveCompare("main") == ComparisonResult.orderedSame){
            let keys = Array(menuItemsChild.keys)
            cell.textLabel?.text = keys[indexPath.row]//menuItems[indexPath.row].menu
        }*/
        let  mainMenu = menuItemsChild["main"]
        cell.textLabel?.text = mainMenu?[indexPath.row].menu
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //menuSelectedDelegate?.menuDidSelected(menu: menuItems[indexPath.row])
        if let  mainMenu = menuItemsChild["main"]{
            if (mainMenu[indexPath.row].parent ?? "") != "main"{
                printLog(content:menuItemsChild[(mainMenu[indexPath.row].parent) ?? ""]!)
                self.slideMenuController()?.closeLeft()
            }else{
                if let tempMenuComp = mainMenu[indexPath.row].menu{
                    if let childArr = menuItemsChild[tempMenuComp.lowercased()]{
                        if childArr.count > 0 {
                            printLog(content:"EXPAND THE MENU --> TOGGLE")
                        }
                    }else{
                        printLog(content:"MAIN MENU TAPPED")
                        self.slideMenuController()?.closeLeft()
                    }
                }
            }
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsets.zero
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    deinit {
        printLog(content:"MENU TV DESTROYED")
    }
}
