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
        //일단 여기는 넘어감 바로 본 화면으로 넘어간다
//        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
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
        popup.view.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            popup.view.alpha = 1
        }) { _ in
            self.view.addSubview(popup)
        }
    }
    
    @IBAction func clickExperiencedNomad(_ sender: UIButton) {
        //위랑 이거랑 뭔 차이임
    }
}
