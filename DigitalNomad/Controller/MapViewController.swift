//
//  MapViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 2. 24..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, MTMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView: MTMapView = MTMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        
        //mapView.daumMapApiKey = "YOUR_DAUM_API_KEY"
        mapView.delegate = self
        mapView.baseMapType = .standard
        self.view.addSubview(mapView)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
