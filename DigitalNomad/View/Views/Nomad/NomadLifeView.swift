//
//  NomadLifeView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 7..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import BEMCheckBox

class NomadLifeView: UIView {

    @IBOutlet var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: "NomadLifeCell", bundle: nil), forCellWithReuseIdentifier: "nomadLifeCell")
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: width / 4, height: width / 4)
        layout.minimumLineSpacing = 5
        collectionView.collectionViewLayout = layout
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "NomadLifeView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    @objc func clickCheckBox(_ sender: BEMCheckBox) {
        if(sender.on){
            sender.applyGradient([#colorLiteral(red: 0.5019607843, green: 0.7215686275, blue: 0.8745098039, alpha: 1), #colorLiteral(red: 0.6980392157, green: 0.8470588235, blue: 0.7725490196, alpha: 1)])
            sender.layer.sublayers?.first?.cornerRadius = sender.frame.height / 2
        } else {
            sender.layer.sublayers?.removeFirst()
        }
    }
}

extension NomadLifeView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nomadLifeCell", for: indexPath) as! NomadLifeCell
        let width = UIScreen.main.bounds.width
        cell.containerView.frame.size = CGSize(width: width / 4, height: width / 4)
        cell.frame.size = CGSize(width: width / 4, height: width / 4)
        cell.containerView.layer.cornerRadius = cell.containerView.frame.height / 2
        //더미데이터
        switch(indexPath.item){
        case 0:
            cell.content.text = "캠핑"
        case 1:
            cell.content.text = "수영"
        default:
            cell.content.text = ""
            cell.checkBox.isHidden = true
            cell.imageView.image = #imageLiteral(resourceName: "addImageSample")
            cell.imageView.frame = cell.containerView.frame
            //데이터 추가하는 로직
            return cell
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //전체 요소 + 1
        return 3
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
extension NomadLifeView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch(indexPath.item){
        default:
            break
        }
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? NomadLifeCell {
                cell.containerView.backgroundColor = .lightGray
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? NomadLifeCell {
                cell.containerView.backgroundColor = .white
            }
        }
    }
}
