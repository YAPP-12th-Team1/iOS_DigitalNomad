//
//  NomadWorkTutorialView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 7..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class NomadWorkTutorialView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(clickView))
        self.addGestureRecognizer(gesture)
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "NomadWorkTutorialView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    
    @objc func clickView(){
        self.removeFromSuperview()
    }
}
