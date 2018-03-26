//
//  NomadLifeCardView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 22..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class NomadLifeCardView: UIView {

    @IBOutlet var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        collectionView.register(UINib(nibName: "NomadLifeCardCell", bundle: nil), forCellWithReuseIdentifier: "nomadLifeCardCell")
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "NomadLifeCardView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
}

extension NomadLifeCardView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nomadLifeCardCell", for: indexPath) as! NomadLifeCardCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}
extension NomadLifeCardView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? NomadLifeCardCell {
                cell.view.backgroundColor = #colorLiteral(red: 0.831372549, green: 0.831372549, blue: 0.831372549, alpha: 1)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? NomadLifeCardCell {
                cell.view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
            }
        }
    }
}
