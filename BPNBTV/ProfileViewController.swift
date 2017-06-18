//
//  ProfileViewController.swift
//  BPNBTV
//
//  Created by Raditya on 6/18/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import UIKit
import YouTubePlayer
class ProfileViewController: UIViewController {
    var profileModel:ProfileModel!
    var youtubePlayerView: YouTubePlayerView!
    
    @IBOutlet weak var playerContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        youtubePlayerView = YouTubePlayerView(frame: playerContainer.frame)
        playerContainer.addSubview(youtubePlayerView)
        if let _ = profileModel{
            if let videoId = profileModel.youtube{
                youtubePlayerView.loadVideoID(videoId)
            }
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
