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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickContent(_ sender: UIButton) {
        let object = (realm.objects(ProjectInfo.self).last?.goalLists)!
        let query = NSPredicate(format: "todo = %@", (sender.titleLabel?.text)!)
        let result = object.filter("date = %@", Date()).filter(query).first!
        let textColor = sender.titleColor(for: .normal)
        if(textColor == .black){
            sender.setTitleColor(.blue, for: .normal)
            try! realm.write {
                result.importance = 1
            }
        } else if(textColor == .blue){
            sender.setTitleColor(.red, for: .normal)
            try! realm.write {
                result.importance = 2
            }
        } else if(textColor == .red){
            sender.setTitleColor(.black, for: .normal)
            try! realm.write {
                result.importance = 0
            }
        }
    }
    
    @IBAction func clickCheckBox(_ sender: BEMCheckBox) {
        let parentViewController = self.parentViewController() as! NomadViewController
        let object = (realm.objects(ProjectInfo.self).last?.goalLists)!
        if(sender.on){
            checkBox.applyGradient([#colorLiteral(red: 0.5019607843, green: 0.7215686275, blue: 0.8745098039, alpha: 1), #colorLiteral(red: 0.6980392157, green: 0.8470588235, blue: 0.7725490196, alpha: 1)])
            checkBox.layer.sublayers?.first?.cornerRadius = checkBox.frame.height / 2
            let strikethrough = StrikethroughView.instanceFromXib() as! StrikethroughView
            strikethrough.tag = 100
            content.sizeToFit()
            strikethrough.frame.size = content.frame.size
            content.addSubview(strikethrough)
            for i in 0..<object.count {
                let cell = (parentViewController.centerView.subviews.last as! NomadWorkView).tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! NomadWorkCell
                if(cell.checkBox == sender){
                    let todo = (cell.content.titleLabel?.text)!
                    let query = NSPredicate(format: "todo = %@", todo)
                    let result = object.filter("date = %@", Date()).filter(query).first!
                    try! realm.write{
                        result.status = true
                    }
                    break
                }
            }
        } else {
            checkBox.layer.sublayers?.removeFirst()
            content.viewWithTag(100)?.removeFromSuperview()
            for i in 0..<object.count {
                let cell = (parentViewController.centerView.subviews.last as! NomadWorkView).tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! NomadWorkCell
                if(cell.checkBox == sender){
                    let todo = (cell.content.titleLabel?.text)!
                    let query = NSPredicate(format: "todo = %@", todo)
                    let result = object.filter("date = %@", Date()).filter(query).first!
                    try! realm.write{
                        result.status = false
                    }
                    break
                }
            }
        }
        
        //FinalPage 여는 조건
        let project = realm.objects(ProjectInfo.self).last
        guard let goals = project?.goalLists else { return }
        guard let wishs = project?.wishLists else { return }
        for goal in goals{
            if(goal.status == false){
                return
            }
        }
        for wish in wishs{
            if(wish.status == false){
                return
            }
        }
        let finalView = NomadFinalView.instanceFromXib()
        finalView.alpha = 0
        self.parentViewController()?.view.addSubview(finalView)
        UIView.animate(withDuration: 0.5, animations: {
            finalView.alpha = 1
        })
        
    }
}
