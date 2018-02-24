//
//  Research4ViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 2. 24..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class Research4ViewController: UIViewController {

    @IBOutlet var stackCafe: UIStackView!
    @IBOutlet var stackCenter: UIStackView!
    @IBOutlet var stackCoworking: UIStackView!
    @IBOutlet var stackNature: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackCafe.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(clickCafe)))
        stackCenter.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(clickCenter)))
        stackCoworking.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(clickCoworking)))
        stackNature.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(clickNature)))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func next(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "Research5ViewController") as! Research5ViewController
        self.navigationController?.show(controller, sender: self)
    }
    
    @objc func clickCafe() {
        UserDefaults.standard.set("cafe", forKey: "nomadWorkingPlace")
    }
    @objc func clickCenter() {
        UserDefaults.standard.set("center", forKey: "nomadWorkingPlace")
    }
    @objc func clickCoworking() {
        UserDefaults.standard.set("coworking", forKey: "nomadWorkingPlace")
    }
    @objc func clickNature() {
        UserDefaults.standard.set("nature", forKey: "nomadWorkingPlace")
    }

}
