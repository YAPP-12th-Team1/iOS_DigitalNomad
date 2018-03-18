//
//  MyPageListView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 6..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import RealmSwift

class MyPageListView: UIView {

    @IBOutlet var title: UILabel!
    @IBOutlet var content: UILabel!
    var realm: Realm!
    var goalListInfo: GoalListInfo!

  
    override func awakeFromNib() {
        super.awakeFromNib()
        getWorkContent()
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "MyPageListView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    
    @objc func getWorkContent(){
        realm = try! Realm()
        let totalGoalNum = realm.objects(GoalListInfo.self).count
        let done = realm.objects(GoalListInfo.self).filter("status==true").count
        content.text =  String(done) + "/" + String(totalGoalNum)
    }
}
