//
//  StartViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 20..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    var popup: PopupStartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func clickFirstNomad(_ sender: UIButton) {
        popup = PopupStartView.instanceFromXib() as! PopupStartView
        popup.delegate = self
        popup.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        popup.frame = self.view.frame
        self.view.addSubview(popup)
        popup.view.alpha = 0
        popup.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.popup.alpha = 1
            self.popup.view.alpha = 1
        }
    }
    
    @IBAction func clickExperiencedNomad(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let next = storyboard.instantiateViewController(withIdentifier: "EnrollViewController")
        present(next, animated: true)
    }
}

extension StartViewController: PopupStartViewDelegate {
    func touchUpSkipButton() {
        self.popup.removeFromSuperview()
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EnrollViewController")
        self.present(controller, animated: true, completion: nil)
    }
    func touchUpRecommendButton() {
        self.popup.removeFromSuperview()
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ResearchViewController")
        self.present(controller, animated: true, completion: nil)
    }
}
