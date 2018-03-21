//
//  PopupStartView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 21..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class PopupStartView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet var buttonSkip: UIButton!
    @IBOutlet var buttonRecommendation: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 1
        buttonSkip.layer.cornerRadius = 5
        buttonRecommendation.layer.cornerRadius = 5
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "PopupStartView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    
    @IBAction func clickSkip(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EnrollmentViewController")
        self.parentViewController()?.present(controller, animated: true, completion: nil)
        self.removeFromSuperview()
    }
    
    @IBAction func clickRecommendation(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ResearchViewController")
        self.parentViewController()?.present(controller, animated: true, completion: nil)
        self.removeFromSuperview()
    }
}
