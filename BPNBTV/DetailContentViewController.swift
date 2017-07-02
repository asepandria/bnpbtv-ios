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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
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


extension DetailContentViewController:UICollectionViewDelegate,
            UICollectionViewDataSource,
            UICollectionViewDelegateFlowLayout,
            DetailHeaderDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeftCellCV", for: indexPath) as! LeftCellCV
        cell.titleList?.text = video.judulEN
        if (video.summaryEN.characters.count > 80){
            cell.contentList?.text = video.summaryEN.substring(to: video.summaryEN.index(video.summaryEN.startIndex, offsetBy: 80)) + "..."
        }else{
            cell.contentList?.text = video.summaryEN
        }
        cell.imageList?.kf.setImage(with: URL(string: video.imageUrl ?? ""))
        return cell
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
        default:
            assert(false, "Unexpected element kind")
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
    }
}
