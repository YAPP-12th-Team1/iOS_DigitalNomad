//
//  CardView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 16..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class CardView: UIView {

    @IBOutlet var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.tag = 1
        self.collectionView.register(UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: "cardCell")
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "CardView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
}
