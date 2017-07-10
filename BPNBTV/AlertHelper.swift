//
//  AlertHelper.swift
//  BPNBTV
//
//  Created by Raditya on 6/19/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import Foundation
import UIKit
class AlertHelper{
    class func showErrorAlert(message:String){
        let alert = UIAlertController(title: "ERROR", message:message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
        if let topVC = UIApplication.topViewController(){
            topVC.present(alert, animated: true, completion: nil)
        }
    }
    class func showCommonAlert(message:String){
        let alert = UIAlertController(title: "TEST ALERT", message:message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
        if let topVC = UIApplication.topViewController(){
            topVC.present(alert, animated: true, completion: nil)
        }
    }
}
