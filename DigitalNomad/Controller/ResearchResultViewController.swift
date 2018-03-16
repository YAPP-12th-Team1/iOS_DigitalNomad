//
//  ResearchResultViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 2. 24..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class ResearchResultViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func findMoreInfo(_ sender: UIButton) {
        //위키백과 링크
    }
    
    @IBAction func start(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Nomad", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NomadViewController") as! NomadViewController
        present(controller, animated: true, completion: nil)
    }
}

