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
        textField.autocorrectionType = .no
        textField.addTarget(self, action: #selector(clickReturnButton), for: .editingDidEndOnExit)
        textField.addTarget(self, action: #selector(textFieldEditing), for: .editingChanged)
        subView.layer.borderColor = UIColor.lightGray.cgColor
        subView.layer.borderWidth = 1
        addButton.applyGradient([#colorLiteral(red: 0.5019607843, green: 0.7215686275, blue: 0.8745098039, alpha: 1), #colorLiteral(red: 0.6980392157, green: 0.8470588235, blue: 0.7725490196, alpha: 1)])
        addButton.layer.cornerRadius = 5
        getTimeOfDate()
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(getTimeOfDate), userInfo: nil, repeats: true)
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        timer.invalidate()
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "NomadAddView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
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
    
    @objc func clickReturnButton(){
        textField.resignFirstResponder()
    }
    
    @objc func textFieldEditing(){
        //# 후에 공백 안됨
        //아 귀찮다
        let text = textField.text!
        guard let lastChar = text.last else { return }
        if(lastChar == " "){
            if(text.count == 1){
                textField.text = ""
                return
            }
        }
            
        
    }
    
    @IBAction func clickAdd(_ sender: UIButton) {
//        if(textField.text?.isEmpty)! { return }
//        let parentViewController = self.parentViewController() as! NomadViewController
//        parentViewController.tableView.reloadData()
    }
    @IBAction func clickCalendar(_ sender: UIButton) {
        
    }
    
    @IBAction func clickHashtag(_ sender: UIButton) {
        //# 중복입력 안됨
        let currentText = textField.text!
        guard let lastChar = currentText.last else {
            textField.text! = "#"
            return
        }
        if(lastChar != "#"){
            textField.text! += "#"
        }
    }
}
