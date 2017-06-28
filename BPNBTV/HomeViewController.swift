//
//  HomeViewController.swift
//  BPNBTV
//
//  Created by Raditya on 6/18/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
class HomeViewController: UIViewController {

    @IBOutlet weak var videoContainer: UIView!
    @IBOutlet weak var playerView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestHeadline()
        requestHomeVideo()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestHeadline(){
        RequestHelper.requestHeadlines(callback: {[weak self] (isSuccess,errorReason,headlineModels) in
            DispatchQueue.main.async {
                if isSuccess{
                    if let _headlines = headlineModels?.headlines{
                        if _headlines.count > 0{
                            self?.playerView.load(withVideoId: _headlines.first?.youtube ?? "", playerVars: Constants.playerVars)
                            self?.playerView.webView?.bounds = (self?.videoContainer.bounds)!
                            self?.playerView.webView?.scrollView.contentInset = UIEdgeInsets.zero
                            self?.playerView.playVideo()
                        }
                        
                    }
                }else{
                    AlertHelper.showErrorAlert(message: errorReason ?? "")
                }
            }
        })
    }
    
    func requestHomeVideo(){
        RequestHelper.requestListBasedOnCategory(params: ["function":"video","limit":"\(Constants.contentListLimit)"], callback: {[weak self](isSuccess,errorReason,videoItems) in
            DispatchQueue.main.async {
                if let _videoItems = videoItems{
                    self?.printLog(content: "Video Items Home : \(_videoItems)")
                }
            }
        })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        playerView?.webView?.scrollView.contentInset = UIEdgeInsets.zero
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerView?.stopVideo()
    }

}
