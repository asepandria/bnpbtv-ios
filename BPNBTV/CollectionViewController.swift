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
    var alertItems:AlertItemsModel!
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
    var isAlertList = false
    @IBOutlet weak var indexLabel: UILabel!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {[weak self] in
            self?.collectionView?.contentInset = UIEdgeInsets.zero
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //alertItems = AlertItemsModel()
        setCollectionView()
        
        if !isSearch{
            indexLabel?.text = "Index : "+selectedCategory.capitalized(with: Locale(identifier: "ID"))
            if !isAlertList{
                requestVideoItems(params: ["function":"video","page":"\(currentPage)","category":"\(selectedCategory)"])
            }else{
                requestAlertList()
            }
        }else{
            indexLabel?.text = "Index Pencarian : "+keyWord.capitalized(with: Locale(identifier: "ID"))
            requestVideoItems(params: ["function":"video","page":"\(currentPage)","keyword":"\(keyWord)"])
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var isRequestFinish = false
    func requestVideoItems(params:[String:String] = ["function":"video","page":"\(1)"]){
        RequestHelper.requestListBasedOnCategory(params: params, callback: {[weak self] (isSuccess,errorReason,videoItems) in
            DispatchQueue.main.async {
                self?.isRequestFinish = true
                self?.progressIndicator?.stopAnimating()
                self?.progressIndicator?.removeFromSuperview()
                
                if isSuccess{
                    //self?.printLog(content: "CONTENT : \(String(describing: videoItems))")
                    if let _videoItems = videoItems{
                        //self?.printLog(content: "Video Items Home : \(_videoItems)")
                        if let _ = self?.collectionVideoItems{
                            for _v in _videoItems.videos{
                                if let checkerIf = self?.collectionVideoItems.videos.contains(where: {$0.idVideo == _v.idVideo}){
                                    if !checkerIf{
                                        self?.collectionVideoItems.videos.append(_v)
                                    }
                                }
                            }
                        }else{
                            self?.collectionVideoItems = _videoItems
                        }
                        self?.totalCollectionVideo = (self?.collectionVideoItems.videos.count) ?? 0
                        self?.totalPage = (self?.collectionVideoItems.totalPage) ?? 0
                        self?.totalLimitVideos = (self?.collectionVideoItems.limit) ?? 0
                    }
                    self?.collectionView.reloadData()
                }else{
                    AlertHelper.showErrorAlert(message: errorReason ?? "")
                }
            }
            
        })
    }
    
    func requestAlertList(){
        RequestHelper.requestAlertList(callback: {[weak self] isSuccess,errorReason,alertItems in
            DispatchQueue.main.async {
                if isSuccess{
                    //self?.printLog(content: "ALERT LISt : \(alertItems)")
                    self?.alertItems = alertItems
                    self?.collectionView.reloadData()
                }else{
                    AlertHelper.showErrorAlert(message: errorReason ?? "")
                }
            }
        })
    }

    func setCollectionView(){
        progressIndicator = UIActivityIndicatorView()
        collectionView.register(UINib(nibName: "LeftCellCV", bundle: nil), forCellWithReuseIdentifier: "LeftCellCV")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsVerticalScrollIndicator = false
        
    }
}


extension CollectionViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isAlertList{
            guard let _alertItems = alertItems else{return 0}
            return _alertItems.alertModel.count
        }else{
            if let _ = collectionVideoItems{
                return totalCollectionVideo
            }else{
                return 0
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeftCellCV", for: indexPath) as! LeftCellCV
        if isAlertList{
            cell.hideIconPlay()
            cell.titleList?.text = alertItems.alertModel[indexPath.row].title ?? ""
            cell.contentList?.text = alertItems.alertModel[indexPath.row].description ?? ""
            if alertItems.alertModel[indexPath.row].imageSliderURLArr.count > 0{
                cell.imageList?.kf.setImage(with: URL(string: alertItems.alertModel[indexPath.row].imageSliderURLArr.first ?? ""))
            }else{
                cell.imageList?.kf.setImage(with: URL(string: alertItems.alertModel[indexPath.row].imageSliderSingle ?? ""))
            }
        }else{
            video = collectionVideoItems.videos[indexPath.row]
            cell.titleList?.text = video.judulEN
            if (video.summaryEN.characters.count > 80){
                cell.contentList?.text = video.summaryEN.substring(to: video.summaryEN.index(video.summaryEN.startIndex, offsetBy: 80)) + "..."
            }else{
                cell.contentList?.text = video.summaryEN
            }
            cell.imageList?.kf.setImage(with: URL(string: video.imageUrl ?? ""))
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor.bnpbLightGrayColor()
        progressIndicator?.stopAnimating()
        progressIndicator?.removeFromSuperview()
        if !isAlertList{
            if(indexPath.row == collectionVideoItems.videos.count - 1 && totalCollectionVideo < totalLimitVideos){
                //printLog(content: "Load More API...")
                currentPage += 1
                isRequestFinish = false
                //collectionView.reloadItems(at: [indexPath])
                requestVideoItems(params: ["function":"video","page":"\(currentPage)","category":"\(selectedCategory)"])
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        progressIndicator?.stopAnimating()
        progressIndicator?.removeFromSuperview()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((getScreenWidth() / 2) - 8)  , height: 200)
        
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
        if isAlertList{
            let detailAlertVC = storyBoard.instantiateViewController(withIdentifier: "DetailAlertViewController") as! DetailAlertViewController
            detailAlertVC.alertModel = alertItems.alertModel[indexPath.row]
            self.navigationController?.pushViewController(detailAlertVC, animated: true)
        }else{
            
            let detailVC = storyBoard.instantiateViewController(withIdentifier: "DetailContentViewController") as! DetailContentViewController
            detailVC.video = collectionVideoItems.videos[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
            //present(detailVC, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        /*if isRequestFinish{
            return CGSize.zero
        }else{
            return CGSize(width: getScreenWidth(), height: 30)
        }*/
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
