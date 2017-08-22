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
        if sections.count <= section {return 0}
        return sections[section].items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuTVCell", for: indexPath) as! MenuTVCell
        if sections.count >  indexPath.section{
            cell.menuLabel?.text = sections[indexPath.section].items[indexPath.row].menu
        }else{
            cell.menuLabel?.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {[weak self] _ in
            self?.resetHeaderFont()
            let cell = tableView.cellForRow(at: indexPath) as! MenuTVCell
            cell.menuLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
            self?.selectedMenuCell = (indexPath.section,indexPath.row)
            //self?.printLog(content: "\(self?.selectedMenuCell)")
            if let menuSelected = self?.sections[indexPath.section].items[indexPath.row]{
                self?.menuSelectedDelegate?.selectedMenu(menuName: menuSelected.menu)
                self?.selectedMenuString = menuSelected.menu
            }
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MenuTVCell
        cell.menuLabel.font = UIFont(name:"HelveticaNeue", size: 16.0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sections.count > indexPath.section{
            return sections[indexPath.section].collapsed! ? 0 : 44
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        (cell as! MenuTVCell).menuLabel.font = UIFont(name:"HelveticaNeue", size: 16.0)
        if indexPath.section % 2 == 0{
            cell.contentView.backgroundColor = UIColor.navigationBarColor()
        }else{
            cell.contentView.backgroundColor = UIColor.white
        }
        if(sections.count <= indexPath.section){return}
        if selectedMenuString == sections[indexPath.section].items[indexPath.row].menu{
            (cell as! MenuTVCell).menuLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
        }else{
            (cell as! MenuTVCell).menuLabel.font = UIFont(name:"HelveticaNeue", size: 15.0)
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerTB = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        if sections.count <=  section{ return nil}
        if(sections[section].items.count == 0){
            headerTB?.arrowImage.isHidden = true
        }else{
            headerTB?.arrowImage.isHidden = false
        }
        
        
        headerTB?.titleLabel.text = sections[section].name.firstCharToUpper()
        if selectedMenuString == sections[section].name.firstCharToUpper(){
            headerTB?.titleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 17.0)
        }else{
            headerTB?.titleLabel.font = UIFont(name:"HelveticaNeue", size: 17.0)
        }
        headerTB?.setCollapsed(collapsed: sections[section].collapsed)
        headerTB?.section = section
        headerTB?.delegate = self
        if !headers.contains(where: {$0.titleLabel.text == sections[section].name.firstCharToUpper()}){
            headers.append(headerTB!)
        }
        return headerTB!
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //printLog(content: "HEADER ASU")
    }
}
extension NewMenuVC:CollapsibleTableViewHeaderDelegate{
    func toggleSection(header: CollapsibleTableViewHeader, section: Int) {
        if sections.count <= section {return}
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
            DispatchQueue.main.async {[weak self] _ in
                self?.resetHeaderFont()
                header.titleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 17.0)
                self?.menuSelectedDelegate?.selectedMenu(menuName:(self?.sections[section].name)!)
                self?.selectedMenuString = (self?.sections[section].name) ?? ""
                self?.dismiss(animated: true, completion: nil)
                guard let _self = self else{return}
                guard let _selectedMenuCell = _self.selectedMenuCell else{return}
                if let indexPath = IndexPath(row: _selectedMenuCell.1, section: _selectedMenuCell.0) as IndexPath?{
                    //self?.printLog(content: _selectedMenuCell)
                    //self?.printLog(content: "INdexpath : \(indexPath)")
                    if let cell = _self.menuTable.cellForRow(at: indexPath) as! MenuTVCell?{
                        cell.menuLabel.font = UIFont(name:"HelveticaNeue", size: 16.0)
                    }
                }
                
            }
            
            
        }
    }
    
    func resetHeaderFont(){
        if headers.count <= 0 {return}
        for header in headers{
            header.titleLabel.font = UIFont(name:"HelveticaNeue", size: 17.0)
            header.setNeedsLayout()
        }
    }
}


extension NewMenuVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        view.endEditing(true)
        cleanUpNavigationControllerForSearch()
        self.menuSelectedDelegate?.searchSelected(keyword: searchTF.text ?? "")
        dismiss(animated: true, completion: nil)
        return true
    }
    
    func cleanUpNavigationControllerForSearch(){
        if let _topVC = UIApplication.shared.keyWindow?.rootViewController{
            for _tvc in _topVC.childViewControllers{
                if(_tvc.isKind(of: DetailContentViewController.self) ||
                    _tvc.isKind(of: DetailAlertViewController.self) ){
                    //_tvc.navigationController?.popViewController(animated: true)
                    _tvc.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
}
