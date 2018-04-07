//
//  NomadLifeCell.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 7..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import BEMCheckBox
import RealmSwift

class NomadLifeCell: UICollectionViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var content: UILabel!
    @IBOutlet var checkBox: BEMCheckBox!
    var realm: Realm!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        realm = try! Realm()
        checkBox.onAnimationType = .fill
        checkBox.offAnimationType = .fill
        checkBox.onCheckColor = .white
        checkBox.onTintColor = checkBox.tintColor
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 1
        // Initialization code
    }

    @IBAction func clickCheckBox(_ sender: BEMCheckBox) {
        let parentViewController = self.parentViewController() as! NomadViewController
        let object = (realm.objects(ProjectInfo.self).last?.wishLists)!
        if(sender.on){
            checkBox.applyGradient([#colorLiteral(red: 0.5019607843, green: 0.7215686275, blue: 0.8745098039, alpha: 1), #colorLiteral(red: 0.6980392157, green: 0.8470588235, blue: 0.7725490196, alpha: 1)])
            checkBox.layer.sublayers?.first?.cornerRadius = checkBox.frame.height / 2
            for i in 0..<object.count{
                let cell = (parentViewController.centerView.subviews.last as! NomadLifeView).collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as! NomadLifeCell
                if(cell.checkBox == sender){
                    let todo = cell.content.text!
                    let query = NSPredicate(format: "todo = %@", todo)
                    let result = object.filter("date BETWEEN %@", [todayStart, todayEnd]).filter(query).first!
                    try! realm.write{
                        result.status = true
                    }
                }
            }
        } else {
            checkBox.layer.sublayers?.removeFirst()
            for i in 0..<object.count{
                let cell = (parentViewController.centerView.subviews.last as! NomadLifeView).collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as! NomadLifeCell
                if(cell.checkBox == sender){
                    let todo = cell.content.text!
                    let query = NSPredicate(format: "todo = %@", todo)
                    let result = object.filter("date BETWEEN %@", [todayStart, todayEnd]).filter(query).first!
                    try! realm.write{
                        result.status = false
                    }
                    break
                }
            }
        }
        
        //FinalPage 여는 조건
        openFinalPage()
        
    }
    func openFinalPage(){
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
