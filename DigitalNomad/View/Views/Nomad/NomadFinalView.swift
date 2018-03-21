//
//  NomadChangeView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 10..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class NomadFinalView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    class func instanceFromXib() -> UIView {
        return UINib(nibName: "NomadFinalView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    @IBAction func clickDismiss(_ sender: UIButton) {
        self.removeFromSuperview()
    }
}
