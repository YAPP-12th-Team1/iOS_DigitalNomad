//
//  ResearchDetailViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 2. 24..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class Research5ViewController: UIViewController {

    @IBOutlet var stackLibrary: UIStackView!
    @IBOutlet var stackReligion: UIStackView!
    @IBOutlet var stackMuseum: UIStackView!
    @IBOutlet var stackHistoric: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackLibrary.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(clickLibrary)))
        stackReligion.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(clickReligion)))
        stackMuseum.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(clickMuseum)))
        stackHistoric.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(clickHistoric)))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func researchEnd(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ResearchResultViewController") as! ResearchResultViewController
        //controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    @objc func clickLibrary() {
        UserDefaults.standard.set("library", forKey: "nomadRest")
    }
    @objc func clickReligion() {
        UserDefaults.standard.set("religion", forKey: "nomadRest")
    }
    @objc func clickMuseum() {
        UserDefaults.standard.set("museum", forKey: "nomadRest")
    }
    @objc func clickHistoric() {
        UserDefaults.standard.set("historic", forKey: "nomadRest")
    }

}
