//
//  NomadLifeWorkAddView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 7..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import RealmSwift
import Toaster

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
        self.endTime.text = UserDefaults.standard.string(forKey: "timeOfFinalPageOpened") ?? ""
        setContentSummary()
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "NomadAddView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    
    @objc func clickReturnButton(){
        if(self.parentViewController()?.view.subviews.last is NomadLifeCardView){
            self.parentViewController()?.view.subviews.last?.removeFromSuperview()
        }
        textField.resignFirstResponder()
    }
    
    @objc func textFieldEditing(){
        //처음에 공백 입력 안됨
        let text = textField.text!
        guard let lastChar = text.last else { return }
        if(lastChar == " "){
            if(text.count == 1){
                textField.text = ""
                return
            }
        }
    }
    
    @objc func setContentSummary() {
        if(!UserDefaults.standard.bool(forKey: "isNomadLifeView")){
            let yesterdayGoals = realm.objects(ProjectInfo.self).last!.goalLists.filter("date BETWEEN %@", [Date.yesterdayStart, Date.yesterdayEnd])
            var text = ""
            switch(yesterdayGoals.count){
            case 0:
                text = "어제 등록한 Goal이 없습니다."
            case 1:
                text = yesterdayGoals.first!.todo
            default:
                text = yesterdayGoals.first!.todo + " 및 \(yesterdayGoals.count - 1)개"
            }
            contentSummary.setTitle(text, for: .normal)
        } else {
            let yesterdayWishes = realm.objects(ProjectInfo.self).last!.wishLists.filter("date BETWEEN %@", [Date.yesterdayStart, Date.yesterdayEnd])
            var text = ""
            switch(yesterdayWishes.count){
            case 0:
                text = "어제 등록한 Goal이 없습니다."
            case 1:
                text = yesterdayWishes.first!.todo
            default:
                text = yesterdayWishes.first!.todo + " 및 \(yesterdayWishes.count - 1)개"
            }
            contentSummary.setTitle(text, for: .normal)
        }
    }
    
    @IBAction func clickAdd(_ sender: UIButton) {
        if(textField.text?.isEmpty)! { return }
        let parentViewController = self.parentViewController() as! NomadViewController
        if(parentViewController.centerView.subviews.last is NomadWorkView){
            //Goal 화면에서
            addGoalList(textField.text!)
            try! realm.write{
                realm.objects(ProjectInfo.self).last!.goalLists.append(realm.objects(GoalListInfo.self).last!)
            }
            (parentViewController.centerView.subviews.last as! NomadWorkView).tableView.reloadData()
        } else {
            //Wish 화면에서
            if(self.parentViewController()?.view.subviews.last is NomadLifeCardView){
                //카드를 선택하고 추가 버튼을 눌렀을 때
                let cardView = self.parentViewController()?.view.subviews.last as! NomadLifeCardView
                let selectedIndex = cardView.selectedIndex
                addWishList(textField.text!, selectedIndex)
                try! realm.write{
                    realm.objects(ProjectInfo.self).last!.wishLists.append(realm.objects(WishListInfo.self).last!)
                }
                self.parentViewController()?.view.subviews.last?.removeFromSuperview()
            } else {
                //카드를 선택하지 않고 추가 버튼을 눌렀을 때
                addWishList(textField.text!)
                try! realm.write{
                    realm.objects(ProjectInfo.self).last!.wishLists.append(realm.objects(WishListInfo.self).last!)
                }
            }
            (parentViewController.centerView.subviews.last as! NomadLifeView).collectionView.reloadData()
        }
        textField.text = nil
        textField.endEditing(true)
        //여기서 viewWillAppear()를 매번 호출해주어야 할까? 나중에 생각해보자.
        parentViewController.viewWillAppear(true)
    }
    
    @IBAction func clickContentSummary(_ sender: UIButton) {
        //어제자 테이블뷰 띄우는 코드
        let parent = self.parentViewController() as! NomadViewController
        let sub = parent.view.subviews.last
        if(sub is NomadWorkView){
           let countOfGoals = realm.objects(ProjectInfo.self).last!.goalLists.filter("date < %@", Date.todayStart).count
            if(countOfGoals == 0) {
                Toast(text: "표시할 정보가 없습니다.", duration: Delay.short).show()
                return
            }
        } else {
            let countOfWishes = realm.objects(ProjectInfo.self).last!.wishLists.filter("date < %@", Date.todayStart).count
            if(countOfWishes == 0) {
                Toast(text: "표시할 정보가 없습니다.", duration: Delay.short).show()
                return
            }
        }
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
        //해시태그의 중복입력 방지
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
