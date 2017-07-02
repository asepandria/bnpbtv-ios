//
//  DetailContentViewController.swift
//  BPNBTV
//
//  Created by Raditya on 7/1/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
class DetailContentViewController: UIViewController {
    var video:Video!
    @IBOutlet weak var videoContainer: UIView!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }

    
    func setupViews(){
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsVerticalScrollIndicator = false
        DispatchQueue.main.async {[weak self] in
            if let _ = self?.video{
                self?.playerView.load(withVideoId: self?.video.youtube ?? "", playerVars: Constants.playerVars)
                self?.playerView.webView?.bounds = (self?.videoContainer.bounds)!
                self?.playerView.webView?.scrollView.contentInset = UIEdgeInsets.zero
                self?.playerView.playVideo()
            }
        }
        
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        printLog(content: "DETAIL CONTENT DEINIT..")
    }
}


extension DetailContentViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeftCellCV", for: indexPath) as! LeftCellCV
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DetailHeader", for: indexPath as IndexPath) as! DetailHeader
            headerView.titleLabel.text = video?.judulEN
            headerView.contentLabel.text = video?.descriptionEN
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
}
