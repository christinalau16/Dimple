//
//  AdViewController.swift
//  Dimple
//
//  Created by Christina Lau on 8/2/17.
//  Copyright © 2017 Christina Lau. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdViewController: UIViewController, GADBannerViewDelegate  {

    var bannerView: GADBannerView!
    let request = GADRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        self.view.addSubview(bannerView)
        bannerView.adUnitID = "ca-app-pub-8403286037753535/4976165527"
        bannerView.rootViewController = self
        
        bannerView.load(request)
        bannerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bannerView.load(request)
    }

    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        view.addSubview(bannerView)
    }
}
