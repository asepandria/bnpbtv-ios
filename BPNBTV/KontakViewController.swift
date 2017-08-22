//
//  KontakViewController.swift
//  BPNBTV
//
//  Created by Raditya on 7/4/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import UIKit

class KontakViewController: UIViewController {

    
    @IBOutlet weak var labelKontak: UILabel!
    var kontakString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        labelKontak.text = kontakString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
