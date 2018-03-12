//
//  NomadChangeView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 10..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class NomadChangeView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    class func instanceFromXib() -> UIView {
        return UINib(nibName: "NomadChangeView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    
    @IBAction func clickChange(_ sender: UIButton) {
        let parentViewController = self.parentViewController() as! NomadViewController
        if(parentViewController.centerView.subviews.last is NomadWorkView){
            parentViewController.centerView.subviews.last?.removeFromSuperview()
            let lifeView = NomadLifeView.instanceFromXib() as! NomadLifeView
            lifeView.frame.size = parentViewController.centerView.frame.size
            parentViewController.centerView.addSubview(lifeView)
            //킬링파트!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            lifeView.layoutIfNeeded()
            
        } else {
            parentViewController.centerView.subviews.last?.removeFromSuperview()
            let workView = NomadWorkView.instanceFromXib() as! NomadWorkView
            workView.frame.size = parentViewController.centerView.frame.size
            parentViewController.centerView.addSubview(workView)
        }
        self.removeFromSuperview()
        parentViewController.viewWillAppear(true)
    }
    @IBAction func clickCancel(_ sender: UIButton) {
        self.removeFromSuperview()
    }
}
