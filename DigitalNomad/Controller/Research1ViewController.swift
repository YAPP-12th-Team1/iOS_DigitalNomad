//
//  Research1ViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 2. 24..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class Research1ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeSliderValue(_ sender: UISlider) {
        let value = Int(sender.value.rounded())
        UserDefaults.standard.set(value, forKey: "nomadPlaceScale")
    }
    @IBAction func next(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "Research2ViewController") as! Research2ViewController
        self.navigationController?.show(controller, sender: self)
    }
}
