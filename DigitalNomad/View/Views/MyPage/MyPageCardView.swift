//
//  MyPageCardView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 6..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import RealmSwift

class MyPageCardView: UIView {

    @IBOutlet var title: UILabel!
    @IBOutlet var content: UILabel!
    var realm: Realm!
    var wishListInfo: WishListInfo!

    override func awakeFromNib() {
        super.awakeFromNib()
        getLifeContent()
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "MyPageCardView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    
    @objc func getLifeContent(){
        realm = try! Realm()
        let totalGoalNum = realm.objects(WishListInfo.self).count
        let done = realm.objects(WishListInfo.self).filter("status==true").count
        content.text =  String(done) + "/" + String(totalGoalNum)
    }

}
