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
        realm = try! Realm()
        getWorkContent()
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "MyPageListView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    
    func getWorkContent(){
        let totalGoalNum = realm.objects(ProjectInfo.self).last!.goalLists.count
        let done = realm.objects(ProjectInfo.self).last!.goalLists.filter("status = true").count
        self.content.text = "\(done) / \(totalGoalNum)"
    }
}
