//
//  UITextField+.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 2. 24..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

extension UITextField {
    func addBorderBottom(height: CGFloat) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = UIColor.lightGray.cgColor
        self.layer.addSublayer(border)
    }
}
