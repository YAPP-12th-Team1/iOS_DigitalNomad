//
//  StartViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 20..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clickFirstNomad(_ sender: UIButton) {
        let popup = PopupStartView.instanceFromXib() as! PopupStartView
        popup.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        popup.frame = self.view.frame
        self.view.addSubview(popup)
        popup.view.alpha = 0
        popup.alpha = 0
        UIView.animate(withDuration: 0.3) {
            popup.alpha = 1
            popup.view.alpha = 1
        }
    }
    
    @IBAction func clickExperiencedNomad(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let next = storyboard.instantiateViewController(withIdentifier: "ResearchViewController")
        present(next, animated: true)
    }
}
