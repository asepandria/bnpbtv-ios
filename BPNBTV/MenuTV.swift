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
    var menuSelectedDelegate:MenuSelectedDelegate?
    var mainViewController: UIViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        let dictMenu = UserDefaults.standard.object(forKey: "MENU")as! [[String:String]]
        for dm in dictMenu{
            for(key,val) in dm{
                if let _tempMenu = Menu(_parent: key, _menu: val){
                    let su = menuItems.filter({$0.menu == val && $0.parent == key}) as [Menu]
                    if su.count == 0{
                        menuItems.append(_tempMenu)
                    }
                }
            }
        }
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return menuItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuTableCell", for: indexPath)
        if(menuItems[indexPath.row].parent.caseInsensitiveCompare("main") == ComparisonResult.orderedSame){
            cell.textLabel?.text = menuItems[indexPath.row].menu
        }
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //debugPrint(menuItems[indexPath.row])
        menuSelectedDelegate?.menuDidSelected(menu: menuItems[indexPath.row])
        self.slideMenuController()?.closeLeft()
        
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
        debugPrint("MENU TV DESTROYED")
    }
}
