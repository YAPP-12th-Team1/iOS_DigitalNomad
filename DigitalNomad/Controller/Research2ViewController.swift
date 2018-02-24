//
//  Research2ViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 2. 24..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class Research2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func changeSliderValue(_ sender: UISlider) {
        let value = Int(sender.value.rounded())
        UserDefaults.standard.set(value, forKey: "nomadPeriod")
    }
    @IBAction func next(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "Research3ViewController") as! Research3ViewController
        self.navigationController?.show(controller, sender: self)
    }
}
