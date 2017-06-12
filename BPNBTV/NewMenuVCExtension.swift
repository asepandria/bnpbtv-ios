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
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return (menuItemsChild["main"]?.count) ?? 0
        return sections[section].items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuTVCell", for: indexPath) as! MenuTVCell
        //let  mainMenu = menuItemsChild["main"]
        //cell.textLabel?.text = mainMenu?[indexPath.row].menu
        cell.textLabel?.text  = sections[indexPath.section].items[indexPath.row].menu
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].collapsed! ? 0 : 44
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerTB = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        if(sections[section].items.count == 0){
            headerTB?.arrowImage.isHidden = true
        }else{
            headerTB?.arrowImage.isHidden = false
        }
        headerTB?.titleLabel.text = sections[section].name.firstCharToUpper()
        headerTB?.backgroundColor = UIColor.white
        headerTB?.setCollapsed(collapsed: sections[section].collapsed)
        headerTB?.section = section
        headerTB?.delegate = self
        return headerTB!
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        printLog(content: "HEADER ASU")
    }
}
extension NewMenuVC:CollapsibleTableViewHeaderDelegate{
    func toggleSection(header: CollapsibleTableViewHeader, section: Int) {
        
        let collapsed = !sections[section].collapsed
        // Toggle collapse
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed: collapsed)
        
        // Adjust the height of the rows inside the section
        for i in 0 ..< sections[section].items.count {
            menuTable.reloadRows(at: [IndexPath(row: i, section: section)], with: UITableViewRowAnimation.automatic)
        }
        
        
        let numberOfRows = menuTable.numberOfRows(inSection: section)
        if numberOfRows > 0{
            if let indexPath = IndexPath(row: numberOfRows - 1, section: section) as IndexPath?{
                menuTable.scrollToRow(at: indexPath,at: UITableViewScrollPosition.none, animated: true)
            }
        }else{
            //THIS Main Menu Then, do something about it
        }
    }
}
