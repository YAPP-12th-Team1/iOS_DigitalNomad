//
//  MyDetailViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 14..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class MyDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func touchUpBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
