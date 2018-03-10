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
}
