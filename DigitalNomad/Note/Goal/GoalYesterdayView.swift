//
//  GoalYesterdayView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 18..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

protocol GoalYesterdayViewDelegate {
    func touchUpExitButton()
}

class GoalYesterdayView: UIView {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var dateLabel: UILabel!
    var delegate: GoalYesterdayViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableView.register(UINib(nibName: "GoalYesterdayCell", bundle: nil), forCellReuseIdentifier: "goalYesterdayCell")
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "GoalYesterdayView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    
    @IBAction func touchUpExitButton(_ sender: UIButton) {
        delegate?.touchUpExitButton()
    }
}
