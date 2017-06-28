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
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentContainer: UIScrollView!
    @IBOutlet weak var contentTextViewHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = profileModel{
            if let videoId = profileModel.youtube{
                printLog(content: "VIDEO ID : \(videoId)")
                youtubePlayer.load(withVideoId: videoId, playerVars: Constants.playerVars)
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
            contentTextViewHeightConstraint.constant = contentTextView.sizeThatFits(CGSize(width: contentTextView.frame.width, height: CGFloat.greatestFiniteMagnitude)).height + 96
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
