//
//  NomadLifeView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 7..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import BEMCheckBox
import RealmSwift

class NomadLifeView: UIView {

    @IBOutlet var collectionView: UICollectionView!
    var realm: Realm!
    var object: Results<WishListInfo>!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        realm = try! Realm()
        object = realm.objects(ProjectInfo.self).last!.wishLists.filter("date = '" + todayDate() + "'")
        collectionView.register(UINib(nibName: "NomadLifeCell", bundle: nil), forCellWithReuseIdentifier: "nomadLifeCell")
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: width / 4, height: width / 4)
        layout.minimumLineSpacing = 5
        collectionView.collectionViewLayout = layout
        collectionView.alwaysBounceVertical = true
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "NomadLifeView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
}

extension NomadLifeView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nomadLifeCell", for: indexPath) as! NomadLifeCell
        let width = UIScreen.main.bounds.width
        cell.containerView.frame.size = CGSize(width: width / 4, height: width / 4)
        cell.frame.size = CGSize(width: width / 4, height: width / 4)
        cell.containerView.layer.cornerRadius = cell.containerView.frame.height / 2
        if(indexPath.item != object.count){
            let result = object[indexPath.item]
            cell.content.text = result.todo
            cell.imageView.image = UIImage()
            if(result.status){
                cell.checkBox.setOn(true, animated: false)
            } else {
                cell.checkBox.setOn(false, animated: false)
            }
            if(cell.checkBox.layer.sublayers?.count == 4){
                cell.checkBox.layer.sublayers?.removeFirst()
            }
            if(result.status){
                cell.checkBox.on = true
                cell.checkBox.applyGradient([#colorLiteral(red: 0.5019607843, green: 0.7215686275, blue: 0.8745098039, alpha: 1), #colorLiteral(red: 0.6980392157, green: 0.8470588235, blue: 0.7725490196, alpha: 1)])
                cell.checkBox.layer.sublayers?.first?.cornerRadius = cell.checkBox.frame.height / 2
            } else {
                cell.checkBox.on = false
            }
        } else {
            cell.content.text = nil
            cell.checkBox.isHidden = true
            cell.imageView.image = #imageLiteral(resourceName: "addImageSample")
            cell.imageView.frame = cell.containerView.frame
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return object.count + 1
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
extension NomadLifeView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.item == collectionView.numberOfItems(inSection: 0) - 1){
            let parentViewController = self.parentViewController() as! NomadViewController
            if(parentViewController.searchBar.isFirstResponder){
                parentViewController.searchBar.endEditing(true)
            }
            let addView = parentViewController.underView.subviews.last as! NomadAddView
            addView.textField.becomeFirstResponder()
        } else {
            let alert = UIAlertController(title: nil, message: "삭제할까요?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "예", style: .default, handler: { (action) in
                let todo = (collectionView.cellForItem(at: indexPath) as! NomadLifeCell).content.text!
                let query = NSPredicate(format: "todo = %@", todo)
                let result = self.object.filter("date = '" + todayDate() + "'").filter(query)
                try! self.realm.write{
                    self.realm.delete(result)
                }
                collectionView.reloadData()
                collectionView.layoutIfNeeded()
            })
            let noAction = UIAlertAction(title: "아니오", style: .cancel)
            alert.addAction(noAction)
            alert.addAction(yesAction)
            self.parentViewController()?.present(alert, animated: true, completion: nil)
            
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
