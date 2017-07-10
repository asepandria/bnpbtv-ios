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
    var totalHomeVideo = 0
    var currentPage = 1
    var totalPage = 0
    var totalLimitVideos = 0
    var progressIndicator: UIActivityIndicatorView!
    var isFromNotification = false
    var notificationContainer:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        if !isFromNotification{
            requestHeadline()
        }else{
            playerView?.removeFromSuperview()
            setNotificationContainer()
        }
        requestHomeVideo()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFromNotification{
            DispatchQueue.main.async {[weak self] in
                self?.playerView?.webView?.scrollView.contentInset = UIEdgeInsets.zero
            }
        }
        
    }
    
    func setNotificationContainer(){
        notificationContainer = UIView()
        notificationContainer.frame = CGRect(x: 0, y: 0, width: getScreenWidth(), height: videoContainer.frame.height)
        /*notificationContainer.snp.makeConstraints({ make in
            make.top.equalTo(videoContainer)
            make.left.right.equalTo(videoContainer)
            make.height.equalTo(videoContainer.snp.height)
        })*/
        notificationContainer.backgroundColor = UIColor.blue
        videoContainer.addSubview(notificationContainer)
    }
    func setCollectionView(){
        progressIndicator = UIActivityIndicatorView()
        homeCollectionView.register(UINib(nibName: "LeftCellCV", bundle: nil), forCellWithReuseIdentifier: "LeftCellCV")
        homeCollectionView.register(UINib(nibName: "RightCellCV", bundle: nil), forCellWithReuseIdentifier: "RightCellCV")
        homeCollectionView?.delegate = self
        homeCollectionView?.dataSource = self
        homeCollectionView?.showsVerticalScrollIndicator = false
        
        /*homeCollectionView.register(CollectionFooterIndicator.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "FooterIndicator")*/
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
    
    func requestHomeVideo(params:[String:String] = ["function":"video","page":"\(1)"]){
        RequestHelper.requestListBasedOnCategory(params:params , callback: {[weak self](isSuccess,errorReason,videoItems) in
            DispatchQueue.main.async {
                self?.progressIndicator?.stopAnimating()
                self?.progressIndicator?.removeFromSuperview()
                if let _videoItems = videoItems{
                    //self?.printLog(content: "Video Items Home : \(_videoItems)")
                    if let _ = self?.homeVideoItems{
                        for _v in _videoItems.videos{
                            if let checkerIf = self?.homeVideoItems.videos.contains(where: {$0.idVideo == _v.idVideo}){
                                if !checkerIf{
                                    self?.homeVideoItems.videos.append(_v)
                                }
                            }
                        }
                    }else{
                        self?.homeVideoItems = _videoItems
                    }
                    self?.totalHomeVideo = (self?.homeVideoItems.videos.count) ?? 0
                    self?.totalPage = (self?.homeVideoItems.totalPage) ?? 0
                    self?.totalLimitVideos = (self?.homeVideoItems.limit) ?? 0
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

    deinit {
        printLog(content: "HOMEVIEWCONTROLLER DEINIT...")
    }
}

extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = homeVideoItems{
            return totalHomeVideo
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        video = homeVideoItems.videos[indexPath.row]
        if(indexPath.row % 2 == 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeftCellCV", for: indexPath) as! LeftCellCV
            cell.titleList?.text = video.judulEN
            if (video.summaryEN.characters.count > 80){
                cell.contentList?.text = video.summaryEN.substring(to: video.summaryEN.index(video.summaryEN.startIndex, offsetBy: 80)) + "..."
            }else{
                cell.contentList?.text = video.summaryEN
            }
            cell.imageList?.kf.setImage(with: URL(string: video.imageUrl ?? ""))
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RightCellCV", for: indexPath) as! RightCellCV
            cell.position = indexPath.row - 1
            //printLog(content: "\(cell.position)")
            cell.titleList.text = video.judulEN
            if (video.summaryEN.characters.count > 150){
                cell.summaryList?.text = video.summaryEN.substring(to: video.summaryEN.index(video.summaryEN.startIndex, offsetBy: 150)) + "..."
            }else{
                cell.summaryList?.text = video.summaryEN
            }
            //cell.summaryList.text = video.summary
            DispatchQueue.main.async {[weak self] in
                cell.summaryList.frame.size.width = (((self?.getScreenWidth())! / 2) - 20)
                cell.summaryList.frame.origin.x = 8
                cell.titleList.frame.size.width = (((self?.getScreenWidth())! / 2) - 20)
                cell.titleList.frame.origin.x = 8
                cell.titleList.setNeedsDisplay()
                cell.titleList.setNeedsLayout()
                cell.summaryList.setNeedsDisplay()
                cell.summaryList.setNeedsLayout()
            }
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor.bnpbLightGrayColor()
        progressIndicator?.stopAnimating()
        progressIndicator?.removeFromSuperview()
        if(indexPath.row == homeVideoItems.videos.count - 1 && totalHomeVideo < totalLimitVideos){
            //printLog(content: "Load More API...")
            currentPage += 1
            requestHomeVideo(params: ["function":"video","page":"\(currentPage)"])
        }
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row % 2 == 0{
            return CGSize(width: ((getScreenWidth() / 2) - 8)   , height: 200)
        }else{
            return CGSize(width: ((getScreenWidth() / 2) - 8)  , height: 200)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape{
            
        }else if UIDevice.current.orientation.isPortrait{
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 4, bottom: 4, right: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Content", bundle: nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "DetailContentViewController") as! DetailContentViewController
        detailVC.video = homeVideoItems.videos[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
        /*if let rootVC = self.navigationController?.viewControllers.first{
            if rootVC.isKind(of: ContainerViewController.self){
                (rootVC as! ContainerViewController).removeChildViewControllers()
                (rootVC as! ContainerViewController).addChildViewController(detailVC)
                
                detailVC.view.frame = CGRect(x:0, y:0, width:rootVC.view.frame.size.width, height:rootVC.view.frame.size.height)
                rootVC.view.addSubview(detailVC.view)
                detailVC.didMove(toParentViewController: rootVC)
            }
        }*/
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: getScreenWidth(), height: 30)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterIndicator", for: indexPath as IndexPath)
            footerView.backgroundColor = UIColor.white
            progressIndicator.startAnimating()
            progressIndicator.frame = CGRect(x:(getScreenWidth()/2)-10,y:5,width:20,height:20)
            progressIndicator.color = UIColor.gray
            footerView.addSubview(progressIndicator)
            return footerView
        default:
            //assert(false, "Unexpected element kind")
            fatalError("Unexpected element kind")
        }
    }
}
