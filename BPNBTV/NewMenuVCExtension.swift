//
//  NewMenuVCExtension.swift
//  BPNBTV
//
//  Created by Raditya on 6/8/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import Foundation
import UIKit
extension NewMenuVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (menuItemsChild["main"]?.count) ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuTVCell", for: indexPath) as! MenuTVCell
        let  mainMenu = menuItemsChild["main"]
        cell.textLabel?.text = mainMenu?[indexPath.row].menu
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let  mainMenu = menuItemsChild["main"]{
            if (mainMenu[indexPath.row].parent ?? "") != "main"{
                printLog(content:menuItemsChild[(mainMenu[indexPath.row].parent) ?? ""]!)
                //self.slideMenuController()?.closeLeft()
            }else{
                if let tempMenuComp = mainMenu[indexPath.row].menu{
                    if let childArr = menuItemsChild[tempMenuComp.lowercased()]{
                        if childArr.count > 0 {
                            printLog(content:"EXPAND THE MENU --> TOGGLE")
                        }
                    }else{
                        printLog(content:"MAIN MENU TAPPED")
                        //self.slideMenuController()?.closeLeft()
                    }
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsets.zero
        
    }
}
