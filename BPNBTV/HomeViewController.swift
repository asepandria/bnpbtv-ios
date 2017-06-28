//
//  HomeViewController.swift
//  BPNBTV
//
//  Created by Raditya on 6/18/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import Kingfisher
class HomeViewController: UIViewController {

    @IBOutlet weak var videoContainer: UIView!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    var homeVideoItems:VideoItems!
    var video:Video!
    var collectionLayout:UICollectionViewFlowLayout!
    var currentIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        requestHeadline()
        requestHomeVideo()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCollectionView(){
        collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.sectionInset = UIEdgeInsets(top: 2, left: 4, bottom: 4, right: 4)
        collectionLayout.itemSize = CGSize(width: (getScreenWidth() / 2) - 8, height: getScreenHeight()/3)
        collectionLayout.minimumInteritemSpacing = -2
        collectionLayout.minimumLineSpacing = 4
        //homeCollectionView.register(LeftCellCV.self, forCellWithReuseIdentifier: "LeftCellCV")
        homeCollectionView.register(UINib(nibName: "LeftCellCV", bundle: nil), forCellWithReuseIdentifier: "LeftCellCV")
        homeCollectionView?.collectionViewLayout = collectionLayout
        homeCollectionView?.delegate = self
        homeCollectionView?.dataSource = self
        homeCollectionView?.showsVerticalScrollIndicator = false
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
                    //self?.printLog(content: "Video Items Home : \(_videoItems)")
                    if let _ = self!.homeVideoItems{
                        for _v in _videoItems.videos{
                            if !self!.homeVideoItems.videos.contains(where: {$0.idVideo == _v.idVideo}){
                                self!.homeVideoItems.videos.append(_v)
                            }
                        }
                    }else{
                        self?.homeVideoItems = _videoItems
                    }
                    self?.homeCollectionView.reloadData()
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

extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        if let _ = homeVideoItems{
//            return homeVideoItems.videos.count
//        }else{
//            return 0
//        }
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = homeVideoItems{
            return  homeVideoItems.videos.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeftCellCV", for: indexPath) as! LeftCellCV
        /*if indexPath.section == 0{
            video = homeVideoItems.videos[indexPath.row]
        }else{
            if indexPath.section % 2 == 0{
                currentIndex = (indexPath.section + 1) + (indexPath.row)
            }else{
                currentIndex = (indexPath.section + 1) + (indexPath.row + 1)
            }
            
        }*/
        
        video = homeVideoItems.videos[indexPath.row]
        cell.titleList?.text = video.judul
        if (video.description.characters.count > 50){
            cell.contentList?.text = video.description.substring(to: video.description.index(video.description.startIndex, offsetBy: 50)) + "..."
        }else{
            cell.contentList?.text = video.description
        }
        cell.imageList?.kf.setImage(with: URL(string: video.imageUrl ?? ""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor.bnpbLightGrayColor()
    }
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((getScreenWidth() / 2) - 10)   , height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }*/
    
}
