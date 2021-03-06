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
import GoogleMaps
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
    var pushId = ""
    var pushType = ""
    var alertModel:AlertModel!{
        didSet{
            //setNotificationContainer()
            printLog(content: "ALERT MODEL HOME DIDSET...")
        }
    }
    var notificationContainer:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        if !isFromNotification{
            requestHeadline()
        }else{
            setViewControllerForNotification()
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
        DispatchQueue.main.async {[weak self] in
            self?.playerView?.webView?.scrollView.contentInset = UIEdgeInsets.zero
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFromNotification{
            DispatchQueue.main.async {[weak self] in
                self?.playerView?.webView?.scrollView.contentInset = UIEdgeInsets.zero
                self?.videoContainer?.setNeedsLayout()
                self?.playerView?.setNeedsDisplay()
                self?.homeCollectionView?.reloadData()
            }
        }
        
    }
    
    func requestAlertBasedOnPush(){
        progressIndicator?.startAnimating()
        RequestHelper.requestAlertList(params:["function":"arsip_bencana","id":pushId],callback: {[weak self] isSuccess,errorReason,alertItems in
            DispatchQueue.main.async {[weak self] in
                self?.progressIndicator?.stopAnimating()
                self?.progressIndicator?.removeFromSuperview()
                if isSuccess{
                    let detailAlertVC = self?.storyboard?.instantiateViewController(withIdentifier: "DetailAlertViewController") as! DetailAlertViewController
                    detailAlertVC.alertModel = alertItems?.alertModel.first
                    self?.navigationController?.pushViewController(detailAlertVC, animated: true)
                }else{
                    AlertHelper.showErrorAlert(message: errorReason ?? "")
                }
            }
        })
        
    }
    
    func requestDetailVideoBasedOnPush(){
        RequestHelper.requestListBasedOnCategory(params: ["function":"video","id":pushId], callback: { isSuccess, errorReason,listVideo in
            DispatchQueue.main.async {[weak self] in
                if isSuccess{
                    let detailVC = self?.storyboard?.instantiateViewController(withIdentifier: "DetailContentViewController") as! DetailContentViewController
                    detailVC.video = listVideo?.videos.first
                    self?.navigationController?.pushViewController(detailVC, animated: true)
                }
            }
        })
        
    }
    
    func setViewControllerForNotification(){
        if pushType.lowercased() == Constants.pushHeadline{
            requestDetailVideoBasedOnPush()
        }else if pushType.lowercased() == Constants.pushAlert{
            requestAlertBasedOnPush()
        }
    }
    
    
    lazy var longitude:CLLocationDegrees = 0
    lazy var latitude:CLLocationDegrees = 0
    lazy var zoomScale:Float = 15
    func getLongLatFromGoogleMapsURL(urlString:String){
        let regexp = "/@(-?\\d+\\.\\d+,-?\\d+\\.\\d+,\\d+)"
        if let range = alertModel.googleMaps!.range(of: regexp, options: String.CompareOptions.regularExpression){
            let resultLonglat = alertModel.googleMaps!.substring(with: range)
            let resultLongLatFix = resultLonglat.replacingOccurrences(of:"/@", with: "")
            let splitLongLat = resultLongLatFix.components(separatedBy: ",")
            if splitLongLat.count > 1{
                longitude = (splitLongLat[1] as NSString).doubleValue
                latitude = (splitLongLat[0] as NSString).doubleValue
            }
            if splitLongLat.count > 2{
                zoomScale = Float((splitLongLat[2] as NSString).doubleValue)
            }
        }
    }
    func setupMap(){
        if let _  = alertModel{
            //typeLabel?.text = alertModel.type ?? ""
            //addressLabel?.text = alertModel.address ?? ""
            if let _longLat  = alertModel.longlat{
                if _longLat != ""{
                    let splitLongLat = _longLat.components(separatedBy: "/")
                    if splitLongLat.count > 1{
                        longitude = (splitLongLat[0] as NSString).doubleValue
                        latitude = (splitLongLat[1] as NSString).doubleValue
                    }
                }
            }
            
            if longitude == 0 && latitude == 0{
                getLongLatFromGoogleMapsURL(urlString: alertModel.googleMaps)
                
            }
        }
        
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoomScale)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        notificationContainer.addSubview(mapView)
        mapView.snp.makeConstraints({make in
            make.top.equalTo(notificationContainer)
            make.left.right.equalTo(notificationContainer)
            make.height.equalTo(notificationContainer).offset(-50)
        })
        mapView.center = notificationContainer.center
        //mapContainer = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        marker.title = alertModel.address
        //marker.snippet = alertModel.address
        marker.map = mapView
    }
    func setCollectionView(){
        progressIndicator = UIActivityIndicatorView()
        homeCollectionView.register(UINib(nibName: "LeftCellCV", bundle: nil), forCellWithReuseIdentifier: "LeftCellCV")
        homeCollectionView.register(UINib(nibName: "RightCellCV", bundle: nil), forCellWithReuseIdentifier: "RightCellCV")
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
        DispatchQueue.main.async {[weak self] in
            self?.playerView?.webView?.scrollView.contentInset = UIEdgeInsets.zero
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //playerView?.stopVideo()
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
