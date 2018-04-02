//
//  NomadLifeTutorialView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 7..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class NomadLifeTutorialView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(clickView))
        self.addGestureRecognizer(gesture)
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "NomadLifeTutorialView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }

    @objc func clickView(){
        UserDefaults.standard.set(true, forKey: "isFirstNomadLifeExecute")
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
