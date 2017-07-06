//
//  CollectionViewController.swift
//  BPNBTV
//
//  Created by Raditya on 6/18/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import UIKit
import Kingfisher
class CollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var collectionVideoItems:VideoItems!
    var video:Video!
    var collectionLayout:UICollectionViewFlowLayout!
    var currentIndex = 0
    var totalCollectionVideo = 0
    var currentPage = 1
    var totalPage = 0
    var totalLimitVideos = 0
    var progressIndicator: UIActivityIndicatorView!
    var selectedCategory = ""
    var isSearch = false
    var keyWord = ""
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func requestVideoItems(params:[String:String] = ["function":"video","page":"\(1)"]){
        if !isSearch{
            RequestHelper.requestListBasedOnCategory(params: params, callback: {[weak self] (isSuccess,errorReason,videoItems) in
                DispatchQueue.main.async {[weak self] in
                    if isSuccess{
                        self?.printLog(content: "CONTENT : \(videoItems)")
                    }else{
                        AlertHelper.showErrorAlert(message: errorReason ?? "")
                    }
                }
                
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
