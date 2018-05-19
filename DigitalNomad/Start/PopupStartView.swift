//
//  PopupStartView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 21..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

protocol PopupStartViewDelegate {
    func touchUpSkipButton()
    func touchUpRecommendButton()
}

class PopupStartView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet var buttonSkip: UIButton!
    @IBOutlet var buttonRecommendation: UIButton!
    var delegate: PopupStartViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 1
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "PopupStartView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    
    @IBAction func clickSkip(_ sender: UIButton) {
        delegate?.touchUpSkipButton()
    }
    
    @IBAction func clickRecommendation(_ sender: UIButton) {
        delegate?.touchUpRecommendButton()
    }
}
