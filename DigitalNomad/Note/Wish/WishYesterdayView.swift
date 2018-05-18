//
//  WishYesterdayView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 18..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

protocol WishYesterdayViewDelegate {
    func touchUpExitButton()
}

class WishYesterdayView: UIView {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var dateLabel: UILabel!
    var delegate: WishYesterdayViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableView.register(UINib(nibName: "WishYesterdayCell", bundle: nil), forCellReuseIdentifier: "wishYesterdayCell")
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "WishYesterdayView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }

    @IBAction func touchUpExitButton(_ sender: UIButton) {
        delegate?.touchUpExitButton()
    }
}
