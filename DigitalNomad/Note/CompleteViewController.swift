//
//  CompleteViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 13..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import Lottie

class CompleteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let animationView = LOTAnimationView(name: "Task_Complete")
        self.view.addSubview(animationView)
        animationView.play()
    }
}
