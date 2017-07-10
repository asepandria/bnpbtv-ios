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

class DetailAlertViewController: UIViewController {
   
    @IBOutlet weak var mapContainer: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var detailTypeLabel: UILabel!
    
    var alertModel:AlertModel!
    var longitude:CLLocationDegrees!
    var latitude:CLLocationDegrees!
    
    @IBOutlet weak var eartQuakeLabelHint: UILabel!
    @IBOutlet weak var earthQuakeLabelScale: UILabel!
    
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
            typeLabel?.text = alertModel.type ?? ""
            detailTypeLabel?.text = alertModel.type ?? ""
            addressLabel?.text = alertModel.address ?? ""
            if let _longLat  = alertModel.longlat{
                let splitLongLat = _longLat.components(separatedBy: "/")
                if splitLongLat.count > 1{
                    longitude = (splitLongLat[0] as NSString).doubleValue
                    latitude = (splitLongLat[1] as NSString).doubleValue
                }
            }
            if alertModel.scale == ""{
                eartQuakeLabelHint.isHidden = true
                earthQuakeLabelScale.isHidden = true
            }else{
                earthQuakeLabelScale.text = alertModel.scale
            }
        }
        
        if longitude == nil{
            longitude = 0
        }
        if latitude == nil{
            latitude = 0
        }
        setupMap()
    }
    func setupMap(){
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapContainer.addSubview(mapView)
        mapView.snp.makeConstraints({make in
            make.top.equalTo(mapContainer)
            make.left.right.equalTo(mapContainer)
            make.height.equalTo(mapContainer).offset(-50)
        })
        //mapContainer = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }

    @IBAction func backAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func searchAction(_ sender: UIBarButtonItem) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    deinit {
        printLog(content: "DETAIL ALERT DEINIT...")
    }
    
}
