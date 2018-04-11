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
        realm = try! Realm()
        getWishContent()
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "MyPageCardView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    
    func getWishContent(){
        let totalWishNum = realm.objects(ProjectInfo.self).last!.wishLists.count
        let done = realm.objects(ProjectInfo.self).last!.wishLists.filter("status==true").count
        content.text = "\(done) / \(totalWishNum)"
    }

}
