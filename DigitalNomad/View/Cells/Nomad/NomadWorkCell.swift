//
//  NomadLifeWorkCell.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 7..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import BEMCheckBox
import RealmSwift

class NomadWorkCell: UITableViewCell {

    @IBOutlet var checkBox: BEMCheckBox!
    @IBOutlet var content: UIButton!
    var realm: Realm!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        realm = try! Realm()
        checkBox.onAnimationType = .fill
        checkBox.offAnimationType = .fill
        checkBox.onCheckColor = .white
        checkBox.onTintColor = checkBox.tintColor
    }
    
    @IBAction func clickContent(_ sender: UIButton) {
        let object = (realm.objects(ProjectInfo.self).last?.goalLists)!
        let id = sender.tag
        let query = NSPredicate(format: "id = %d", id)
        let result = object.filter(query).first!
        switch(result.importance){
        case 0:
            sender.setTitleColor(.blue, for: .normal)
            try! realm.write{
                result.importance = 1
            }
        case 1:
            sender.setTitleColor(.red, for: .normal)
            try! realm.write{
                result.importance = 2
            }
        case 2:
            sender.setTitleColor(.black, for: .normal)
            try! realm.write{
                result.importance = 0
            }
        default:
            break
        }
    }
    
    @IBAction func clickCheckBox(_ sender: BEMCheckBox) {
        let object = (realm.objects(ProjectInfo.self).last?.goalLists)!
        let id = sender.tag
        let query = NSPredicate(format: "id = %d", id)
        let result = object.filter(query).first!
        if(sender.on){
            checkBox.applyGradient([#colorLiteral(red: 0.5019607843, green: 0.7215686275, blue: 0.8745098039, alpha: 1), #colorLiteral(red: 0.6980392157, green: 0.8470588235, blue: 0.7725490196, alpha: 1)])
            checkBox.layer.sublayers?.first?.cornerRadius = checkBox.frame.height / 2
            let strikethrough = StrikethroughView.instanceFromXib() as! StrikethroughView
            strikethrough.tag = 100
            content.sizeToFit()
            strikethrough.frame.size = content.frame.size
            content.addSubview(strikethrough)
            try! realm.write {
                result.status = true
            }
        } else {
            checkBox.layer.sublayers?.removeFirst()
            content.viewWithTag(100)?.removeFromSuperview()
            try! realm.write {
                result.status = false
            }
        }
        openFinalPage()
    }
    
    func openFinalPage(){
        let project = realm.objects(ProjectInfo.self).last
        guard let goals = project?.goalLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd]) else { return }
        guard let wishes = project?.wishLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd]) else { return }
        let countOfGoals = goals.count
        let countOfWishes = wishes.count
        let completedGoals = goals.filter("status = true").count
        let completedWishes = wishes.filter("status = true").count
        if(countOfGoals != completedGoals || countOfWishes != completedWishes) { return }
        let addView = (self.parentViewController() as! NomadViewController).underView.subviews.last as! NomadAddView
        addView.endTime.text = Date().convertToTime()
        UserDefaults.standard.set(Date().convertToTime(), forKey: "timeOfFinalPageOpened")
        let finalView = NomadFinalView.instanceFromXib()
        finalView.alpha = 0
        self.parentViewController()?.view.addSubview(finalView)
        UIView.animate(withDuration: 0.5, animations: {
            finalView.alpha = 1
        })
    }
}

