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
    var selectedIndex: Int = -1
    
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
        if let image = UIImage(named: "wish\(indexPath.item)") {
            cell.card.image = image
        } else {
            cell.card.image = nil
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
}
extension NomadLifeCardView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //선택되었다는 것을 사용자에게 알려주기 위한 디자인이 들어가야 함. 지금은 알파값만 대충 바꿔줌
        selectedIndex = indexPath.item
        if let cell = collectionView.cellForItem(at: indexPath) as? NomadLifeCardCell {
            cell.card.alpha = 0.6
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? NomadLifeCardCell {
            cell.card.alpha = 1
        }
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