//
//  NomadLifeWorkAddView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 7..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class NomadAddView: UIView {

    @IBOutlet var subView: UIView!
    @IBOutlet var endTime: UILabel!
    @IBOutlet var contentSummary: UILabel!
    @IBOutlet var contentSummaryValue: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var addButton: UIButton!
    
    var timer: Timer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.applyGradient([UIColor(red: 251/255, green: 242/255, blue: 241/255, alpha: 1), UIColor(red: 238/255, green: 195/255, blue: 191/255, alpha: 1)])
        subView.layer.borderColor = UIColor.lightGray.cgColor
        subView.layer.borderWidth = 1
        addButton.applyGradient([UIColor(red: 128/255, green: 184/255, blue: 223/255, alpha: 1), UIColor(red: 178/255, green: 216/255, blue: 197/255, alpha: 1)])
        addButton.layer.cornerRadius = 5
        getTimeOfDate()
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(getTimeOfDate), userInfo: nil, repeats: true)
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        timer.invalidate()
    }
    
    @objc func getTimeOfDate(){
        //리스트 완료 시각...
        //지금은 현재시각 뜨게 해놓음
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "HH:mm"
        endTime.text = dateFormatter.string(from: today)
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "NomadAddView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    
    @IBAction func clickAdd(_ sender: UIButton) {
//        if(textField.text?.isEmpty)! { return }
//        let parentViewController = self.parentViewController() as! NomadViewController
//        parentViewController.tableView.reloadData()
    }
    @IBAction func clickCalendar(_ sender: UIButton) {
    }
    @IBAction func clickHashtag(_ sender: UIButton) {
        let currentText = textField.text!
        textField.text = currentText + "#"
    }
}
