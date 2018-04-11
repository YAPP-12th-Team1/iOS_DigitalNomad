//
//  StrikethroughView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 7..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class StrikethroughView: UIView {

    @IBOutlet var label: UILabel!
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "StrikethroughView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    

}
