//
//  MyPageListView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 6..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class MyPageListView: UIView {

    @IBOutlet var title: UILabel!
    @IBOutlet var content: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "MyPageListView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
}
