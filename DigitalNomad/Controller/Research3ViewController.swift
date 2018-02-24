//
//  Research3ViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 2. 24..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class Research3ViewController: UIViewController {

    @IBOutlet var stackSea: UIStackView!
    @IBOutlet var stackMountain: UIStackView!
    @IBOutlet var stackIsland: UIStackView!
    @IBOutlet var stackAround: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        stackSea.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(clickSea)))
        stackMountain.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(clickMountain)))
        stackIsland.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(clickIsland)))
        stackAround.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(clickAround)))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func next(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "Research4ViewController") as! Research4ViewController
        self.navigationController?.show(controller, sender: self)

    }
    
    @objc func clickSea() {
        UserDefaults.standard.set("sea", forKey: "nomadFavorite")
    }
    @objc func clickMountain() {
        UserDefaults.standard.set("mountain", forKey: "nomadFavorite")
    }
    @objc func clickIsland() {
        UserDefaults.standard.set("island", forKey: "nomadFavorite")
    }
    @objc func clickAround() {
        UserDefaults.standard.set("around", forKey: "nomadFavorite")
    }
}
