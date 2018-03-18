//
//  PopupView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 6..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class PopupView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet var button: UIButton!
    @IBOutlet var receiver: UILabel!
    @IBOutlet var sender: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var message: UILabel!
    @IBOutlet var cancelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowOpacity = 1
        button.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 5
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "PopupView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    
    @IBAction func sendEmail(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    @IBAction func clickCancel(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
