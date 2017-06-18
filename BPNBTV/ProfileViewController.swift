//
//  ProfileViewController.swift
//  BPNBTV
//
//  Created by Raditya on 6/18/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
class ProfileViewController: UIViewController,YTPlayerViewDelegate {
    var profileModel:ProfileModel!
    
    @IBOutlet weak var videoContainer: UIView!
    @IBOutlet weak var youtubePlayer: YTPlayerView!
    
    //let playerVars = ["playsinline":1]
    let playerVars = ["enablejsapi":1,
                      "autoplay":1,
                      "controls":1,
                      "playsinline":1,
                      "showinfo"       : 0,
                      "rel"            : 0,
                      //@"origin"         : @"https://www.example.com", // this is critical
                    "modestbranding" : 1]
    
    
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentContainer: UIScrollView!
    @IBOutlet weak var contentTextViewHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = profileModel{
            if let videoId = profileModel.youtube{
                youtubePlayer.load(withVideoId: videoId, playerVars: playerVars)
                //youtubePlayer.webView?.frame = videoContainer.frame
                youtubePlayer.webView?.bounds = videoContainer.bounds
                youtubePlayer.webView?.scrollView.contentInset = UIEdgeInsets.zero
                youtubePlayer.playVideo()
            }
            contentTextView.text = profileModel.desc ?? ""
            contentTextView.scrollsToTop = true
            contentTextView.showsVerticalScrollIndicator = false
            contentTextView.showsHorizontalScrollIndicator = false
            contentTextView.isScrollEnabled = false
            contentTextViewHeightConstraint.constant = contentTextView.sizeThatFits(CGSize(width: contentTextView.frame.width, height: CGFloat.greatestFiniteMagnitude)).height + 64
            titleLabel.text = profileModel.title ?? ""
            
            contentContainer.scrollsToTop = true
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        youtubePlayer?.webView?.scrollView.contentInset = UIEdgeInsets.zero
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        youtubePlayer?.stopVideo()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    deinit {
        printLog(content: "PROFILE VIEW CONTROLLER DEINIT....")
    }

}
