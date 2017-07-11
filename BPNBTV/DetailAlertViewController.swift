//
//  DetailAlertViewController.swift
//  BPNBTV
//
//  Created by Raditya on 7/10/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import UIKit
import GoogleMaps
import SideMenu
import ImageSlideshow
import Social
class DetailAlertViewController: UIViewController {
   
    @IBOutlet weak var mapContainer: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var detailTypeLabel: UILabel!
    
    var alertModel:AlertModel!
    var longitude:CLLocationDegrees = 0
    var latitude:CLLocationDegrees = 0
    var zoomScale:Float = 15
    
    @IBOutlet weak var eartQuakeLabelHint: UILabel!
    @IBOutlet weak var earthQuakeLabelScale: UILabel!
    //@IBOutlet weak var contentLabelHeightConstraint: NSLayoutConstraint!
    //@IBOutlet weak var slideShowHeightConstraint: NSLayoutConstraint!
    //@IBOutlet weak var scrollContainerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollContainer: UIScrollView!
    @IBOutlet weak var innerScrollContainer: UIView!
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var imageAlert:UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupSlideShow(){
        slideShow.activityIndicator = DefaultActivityIndicator()
        slideShow.backgroundColor = UIColor.black
        slideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        if alertModel.imageSliderURLArr.count > 0{
            var kfSource = [KingfisherSource]()
            imageAlert = UIImageView()
            imageAlert.frame = CGRect(x: 0, y: 0, width: getScreenWidth()/4, height: getScreenWidth()/4)
            imageAlert.kf.setImage(with: URL(string: alertModel.imageSliderURLArr.first ?? ""))
            for aim in alertModel.imageSliderURLArr{
                kfSource.append(KingfisherSource(url: URL(string: aim)!))
            }
            slideShow.setImageInputs(kfSource)
            
        }else{
            slideShow.setImageInputs([KingfisherSource(url:URL(string:alertModel.imageSliderSingle)!)])
        }
        
        
    }
    func setupView(){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: getScreenWidth()/3))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "bnpbtv")
        imageView.image = image
        navigationItem.titleView = imageView
        
        if let _  = alertModel{
            setupSlideShow()
            titleLabel?.text = alertModel.title ?? ""
            let tempLabel = UILabel()
            tempLabel.frame = CGRect(x: 0, y: 0, width: getScreenWidth()/2, height: CGFloat.greatestFiniteMagnitude)
            tempLabel.numberOfLines = 0
            tempLabel.font = UIFont(name: "Helvetica", size: 13)
            tempLabel.text = alertModel.description ?? ""
            tempLabel.sizeToFit()
            //scontentLabel.translatesAutoresizingMaskIntoConstraints = false
            contentLabel.text = (alertModel.description ?? "") + "asiiiiiiiiuuuuuu"
            contentLabel.numberOfLines = 0
            
            typeLabel?.text = alertModel.type ?? ""
            detailTypeLabel?.text = alertModel.type ?? ""
            addressLabel?.text = alertModel.address ?? ""
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
            if alertModel.scale == ""{
                eartQuakeLabelHint.isHidden = true
                earthQuakeLabelScale.isHidden = true
            }else{
                earthQuakeLabelScale.text = alertModel.scale
            }
            DispatchQueue.main.async {[weak self] in
                self?.contentLabel.frame.size.height = tempLabel.frame.height
                self?.contentLabel.setNeedsLayout()
                self?.contentLabel.setNeedsDisplay()
                
                //self?.innerScrollContainer.translatesAutoresizingMaskIntoConstraints = false
                self?.scrollContainer.contentSize.height = (self?.slideShow.frame.height)! + (self?.titleLabel.frame.height)! + (self?.contentLabel.frame.height)!
                self?.scrollContainer.setNeedsLayout()
            }
            
            //scrollContainer.resizeScrollViewContentSize()
            
        }
        setupMap()
    }
    
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
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoomScale)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapContainer.addSubview(mapView)
        mapView.snp.makeConstraints({make in
            make.top.equalTo(mapContainer)
            make.left.right.equalTo(mapContainer)
            make.height.equalTo(mapContainer).offset(-50)
        })
        mapView.center = mapContainer.center
        //mapContainer = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        marker.title = alertModel.address
        //marker.snippet = alertModel.address
        marker.map = mapView
    }

    @IBAction func backAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func searchAction(_ sender: UIBarButtonItem) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    
    
    @IBAction func shareAction(_ sender: UIButton) {
        switch sender.tag{
        case ShareButtonTag.Facebook.rawValue:
            //printLog(content: "Share Facebook")
            if let vc = SLComposeViewController(forServiceType:SLServiceTypeFacebook){
                vc.add(imageAlert?.image)
                vc.add(URL(string: alertModel.shortURL))
                vc.setInitialText(alertModel.title)
                self.present(vc, animated: true, completion: nil)
            }
        case ShareButtonTag.Twitter.rawValue:
            //printLog(content: "Share Twitter")
            if let vc = SLComposeViewController(forServiceType:SLServiceTypeTwitter){
                vc.add(imageAlert?.image)
                vc.add(URL(string: alertModel.shortURL))
                vc.setInitialText(alertModel.title)
                self.present(vc, animated: true, completion: nil)
            }
        case ShareButtonTag.More.rawValue:
            //printLog(content: "Share More")
            let shareJudul = alertModel.title ?? ""
            let activityVC = UIActivityViewController(activityItems: [shareJudul,URL(string: alertModel.shortURL ?? "") as Any,imageAlert.image as Any], applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.assignToContact,
                                                UIActivityType.addToReadingList,
                                                UIActivityType.print,
                                                UIActivityType.openInIBooks,
                                                UIActivityType.saveToCameraRoll]
            present(activityVC, animated: true, completion: nil)
            
        default:
            break
        }
    }
    
    deinit {
        printLog(content: "DETAIL ALERT DEINIT...")
    }
}

