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
    var headerView:DetailHeader!
    var progressIndicator: UIActivityIndicatorView!
    var videoItems:VideoItems!
    var totalRelatedVideo = 0
    var currentPage = 1
    var totalPage = 0
    var totalLimitVideos = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        if let _ = video{
            requestRelatedVideos(params: ["function":"video","category":video.category ?? "","page":"\(currentPage)"])
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {[weak self] in
            self?.playerView?.webView?.scrollView.contentInset = UIEdgeInsets.zero
        }
        
    }
    func setupViews(){
        progressIndicator = UIActivityIndicatorView()
        collectionView?.register(UINib(nibName: "LeftCellCV", bundle: nil), forCellWithReuseIdentifier: "LeftCellCV")
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
    
    func requestRelatedVideos(params:[String:String]){
        RequestHelper.requestListBasedOnCategory(params: params, callback: {[weak self](isSuccess,reason,videoItems) in
            //self?.printLog(content: "VIDEO RELATED : \(String(describing: videoItems))")
            DispatchQueue.main.async {
                self?.progressIndicator?.stopAnimating()
                self?.progressIndicator?.removeFromSuperview()
                if let _videoItems = videoItems{
                    //self?.printLog(content: "Video Items Home : \(_videoItems)")
                    if let _ = self?.videoItems{
                        for _v in _videoItems.videos{
                            if let checkerIf = self?.videoItems.videos.contains(where: {$0.idVideo == _v.idVideo}){
                                if !checkerIf{
                                    self?.videoItems.videos.append(_v)
                                }
                            }
                        }
                    }else{
                        self?.videoItems = _videoItems
                    }
                    self?.totalRelatedVideo = (self?.videoItems.videos.count) ?? 0
                    self?.totalPage = (self?.videoItems.totalPage) ?? 0
                    self?.totalLimitVideos = (self?.videoItems.limit) ?? 0
                    self?.collectionView.reloadData()
                    self?.collectionView.setNeedsLayout()
                    self?.collectionView.setNeedsDisplay()
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        headerView?.detailHeaderDelegate = nil
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        printLog(content: "DETAIL CONTENT DEINIT..")
    }
}


extension DetailContentViewController:UICollectionViewDelegate,
            UICollectionViewDataSource,
            UICollectionViewDelegateFlowLayout,
            DetailHeaderDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = videoItems{
            return totalRelatedVideo
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeftCellCV", for: indexPath) as! LeftCellCV
        cell.titleList?.text = videoItems.videos[indexPath.row].judulEN
        
        if (videoItems.videos[indexPath.row].summaryEN.characters.count > 80){
            cell.contentList?.text = videoItems.videos[indexPath.row].summaryEN.substring(to: videoItems.videos[indexPath.row].summaryEN.index(videoItems.videos[indexPath.row].summaryEN.startIndex, offsetBy: 80)) + "..."
        }else{
            cell.contentList?.text = videoItems.videos[indexPath.row].summaryEN
        }
        cell.imageList?.kf.setImage(with: URL(string: videoItems.videos[indexPath.row].imageUrl ?? ""))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor.bnpbLightGrayColor()
        progressIndicator?.stopAnimating()
        progressIndicator?.removeFromSuperview()
        if(indexPath.row == videoItems.videos.count - 1 && totalRelatedVideo < totalLimitVideos){
            currentPage += 1
            requestRelatedVideos(params: ["function":"video","category":video.category ?? "","page":"\(currentPage)"])
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DetailHeader", for: indexPath as IndexPath) as! DetailHeader
            if headerView.detailHeaderDelegate == nil{
                headerView.detailHeaderDelegate = self
            }
            setContentForHeader()
            return headerView
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterIndicatorDetail", for: indexPath as IndexPath)
            footerView.backgroundColor = UIColor.white
            progressIndicator.startAnimating()
            progressIndicator.frame = CGRect(x:(getScreenWidth()/2)-10,y:5,width:20,height:20)
            progressIndicator.color = UIColor.gray
            footerView.addSubview(progressIndicator)
            return footerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((getScreenWidth() / 2) - 8)   , height: 180)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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
        detailVC.video = videoItems.videos[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: getScreenWidth(), height: 30)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let _ = headerView{
            return CGSize(width: getScreenWidth(), height: headerView.frame.height)
        }else{
            return CGSize(width: getScreenWidth(), height: 125)
        }
        
    }
    
    func refreshContent() {
        setContentForHeader()
    }
    
    func setContentForHeader(){
        let tempLabel = UILabel()
        tempLabel.font = UIFont(name: "Helvetica", size: 15)
        tempLabel.frame = CGRect(x: 0, y: 0, width: getScreenWidth() - 16, height: CGFloat.greatestFiniteMagnitude)
        tempLabel.numberOfLines = 0
        if let selectedLang = UserDefaults.standard.integer(forKey: Constants.langKey) as Int?{
            if selectedLang == Constants.langID{
                headerView.titleLabel.text = video?.judul
                headerView.contentLabel.text = video?.description
                tempLabel.text = video?.description
            }else if selectedLang == Constants.langEN{
                headerView.titleLabel.text = video?.judulEN
                headerView.contentLabel.text = video?.descriptionEN
                tempLabel.text = video?.descriptionEN
            }
        }else{
            headerView.titleLabel.text = video?.judulEN
            headerView.contentLabel.text = video?.descriptionEN
            tempLabel.text = video?.descriptionEN
        }
        tempLabel.sizeToFit()
        headerView.contentHeightConstraint.constant = tempLabel.frame.height
        headerView.frame.size.height = tempLabel.frame.height + 105
        headerView.setNeedsDisplay()
        headerView.setNeedsLayout()
        //collectionView.reloadData()
    }
}
