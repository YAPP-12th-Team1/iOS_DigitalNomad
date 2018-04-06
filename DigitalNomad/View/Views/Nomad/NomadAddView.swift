//
//  NomadLifeWorkAddView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 7..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import RealmSwift

class NomadAddView: UIView {

    @IBOutlet var subView: UIView!
    @IBOutlet var endTime: UILabel!
    @IBOutlet var contentSummary: UIButton!
    @IBOutlet var yesterday: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var buttonCard: UIButton!
    var realm: Realm!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        realm = try! Realm()
        textField.autocorrectionType = .no
        textField.addTarget(self, action: #selector(clickReturnButton), for: .editingDidEndOnExit)
        textField.addTarget(self, action: #selector(textFieldEditing), for: .editingChanged)
        contentSummary.addTarget(self, action: #selector(clickContentSummary), for: .touchUpInside)
        subView.layer.borderColor = UIColor.lightGray.cgColor
        subView.layer.borderWidth = 1
        addButton.applyGradient([#colorLiteral(red: 0.5019607843, green: 0.7215686275, blue: 0.8745098039, alpha: 1), #colorLiteral(red: 0.6980392157, green: 0.8470588235, blue: 0.7725490196, alpha: 1)])
        addButton.layer.cornerRadius = 5
        getTimeOfDate()
        setContentSummary()
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "NomadAddView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    
    @objc func getTimeOfDate(){
        //리스트 완료 시각
        if(!UserDefaults.standard.bool(forKey: "isNomadLifeView")){
            //workList
            let yesterdayWork = realm.objects(ProjectInfo.self).last!.goalLists.filter("date = %@", yesterdayDate())
            if let last = yesterdayWork.last {
                let yesterdayTime = formatForTime(date: last.date)
                endTime.text = yesterdayTime
                
            } else {
                endTime.text = ""
            }
        } else {
            //wishList
            let yesterdayWork = realm.objects(ProjectInfo.self).last!.wishLists.filter("date = %@", yesterdayDate())
            if let last = yesterdayWork.last {

                let yesterdayTime = formatForTime(date: last.date)
                endTime.text = yesterdayTime
            } else {
                endTime.text = ""
            }
        }
    }
    
    @objc func clickReturnButton(){
        if(self.parentViewController()?.view.subviews.last is NomadLifeCardView){
            self.parentViewController()?.view.subviews.last?.removeFromSuperview()
        }
        textField.resignFirstResponder()
    }
    
    @objc func textFieldEditing(){
        //# 후에 공백 안됨
        let text = textField.text!
        guard let lastChar = text.last else { return }
        if(lastChar == " "){
            if(text.count == 1){
                textField.text = ""
                return
            }
        }
        //해시태그 이후 공백
    }
    
    @objc func setContentSummary() {
        let yesterday = yesterdayDate()
        if(!UserDefaults.standard.bool(forKey: "isNomadLifeView")){
            print("WorkCardView")
            //workList
            let yesterdayWork = realm.objects(ProjectInfo.self).last!.goalLists.filter("date = %@", yesterdayDate())
            if let first = yesterdayWork.first {
                let text = first.todo + " 및 " + String(yesterdayWork.count) + "개"
                contentSummary.setTitle(text, for: .normal)
            } else {
                let text = "어제 등록한 Goal이 없습니다."
                contentSummary.setTitle(text, for: .normal)
            }
        } else {
            print("LifeCardView")
            //wishList
            let yesterdayWork = realm.objects(ProjectInfo.self).last!.wishLists.filter("date = %@", yesterdayDate())
            if let first = yesterdayWork.first {
                let text = first.todo + " 및 " + String(yesterdayWork.count) + "개"
                contentSummary.setTitle(text, for: .normal)
            } else {
                let text = "어제 등록한 Wish가 없습니다."
                contentSummary.setTitle(text, for: .normal)
            }
        }
    }
    
    @IBAction func clickAdd(_ sender: UIButton) {
        //GoalListInfo나 WishListInfo에 내용 추가하는 코드
        if(textField.text?.isEmpty)! { return }
        let parentViewController = self.parentViewController() as! NomadViewController
        if(parentViewController.centerView.subviews.last is NomadWorkView){
 
            addGoalList(textField.text!)
            try! realm.write{
                realm.objects(ProjectInfo.self).last!.goalLists.append(realm.objects(GoalListInfo.self).last!)
            }
            
            (parentViewController.centerView.subviews.last as! NomadWorkView).tableView.reloadData()
        } else {
            addWishList(textField.text!)
            try! realm.write{
                realm.objects(ProjectInfo.self).last!.wishLists.append(realm.objects(WishListInfo.self).last!)
            }
            (parentViewController.centerView.subviews.last as! NomadLifeView).collectionView.reloadData()
        }
        textField.text = nil
        textField.endEditing(true)
        parentViewController.viewWillAppear(true)
    }
    
    @IBAction func clickContentSummary(_ sender: UIButton) {
        //어제자 테이블뷰 띄우는 코드
        let storyboard = UIStoryboard(name: "Nomad", bundle: nil)
        let next = storyboard.instantiateViewController(withIdentifier: "NomadLastViewController")
        parentViewController()?.present(next, animated: true, completion: nil)
    }

    @IBAction func clickCard(_ sender: UIButton) {
        //카드를 띄우자
        let cardView = NomadLifeCardView.instanceFromXib() as! NomadLifeCardView
        cardView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 100)
        cardView.frame.origin.y = UIScreen.main.bounds.height - 49 - self.frame.height - 100
        self.parentViewController()?.view.addSubview(cardView)
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
    @IBAction func clickUnderScore(_ sender: UIButton) {
        textField.text! += "_"
    }
   
    
    
}
