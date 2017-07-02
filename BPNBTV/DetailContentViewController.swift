//
//  DetailContentViewController.swift
//  BPNBTV
//
//  Created by Raditya on 7/1/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import UIKit

class DetailContentViewController: UIViewController {
    var video:Video!
    @IBOutlet weak var videoContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //printLog(content: "Content Description : \(video.descriptionEN)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
