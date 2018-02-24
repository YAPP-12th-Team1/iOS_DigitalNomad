//
//  ScheduleViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 2. 24..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {

    @IBOutlet var graph: UIView!
    @IBOutlet var days: UICollectionView!
    @IBOutlet var totalSchedule: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewBorder(graph)
        setViewBorder(totalSchedule)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

func setViewBorder(_ view: UIView) {
    view.layer.borderColor = UIColor.black.cgColor
    view.layer.borderWidth = 2
    view.layer.cornerRadius = 20
}
