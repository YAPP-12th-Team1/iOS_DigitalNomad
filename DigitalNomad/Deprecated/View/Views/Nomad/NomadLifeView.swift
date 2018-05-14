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
        object = realm.objects(ProjectInfo.self).last!.wishLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd])
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
            cell.checkBox.tag = result.id
            cell.checkBox.isHidden = false
            let pictureIndex = result.pictureIndex
            cell.content.text = result.todo
            cell.imageView.image = { () -> UIImage? in
                if(pictureIndex == -1){
                    //아래에 기본 이미지 들어가야 할듯. 지금은 빈 상태
                    return nil
                } else {
                    return UIImage(named: "wish\(pictureIndex)")
                }
            }()
            if(cell.checkBox.layer.sublayers?.count == 4){
                cell.checkBox.layer.sublayers?.removeFirst()
            }
            if(result.status){
                cell.checkBox.setOn(true, animated: false)
                cell.checkBox.applyGradient([#colorLiteral(red: 0.5019607843, green: 0.7215686275, blue: 0.8745098039, alpha: 1), #colorLiteral(red: 0.6980392157, green: 0.8470588235, blue: 0.7725490196, alpha: 1)])
                cell.checkBox.layer.sublayers?.first?.cornerRadius = cell.checkBox.frame.height / 2
            } else {
                cell.checkBox.setOn(false, animated: false)
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
    func openFinalPage(){
//        let project = realm.objects(ProjectInfo.self).last
//        guard let goals = project?.goalLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd]) else { return }
//        guard let wishes = project?.wishLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd]) else { return }
//        let countOfGoals = goals.count
//        let countOfWishes = wishes.count
//        let completedGoals = goals.filter("status = true").count
//        let completedWishes = wishes.filter("status = true").count
//        if(countOfGoals != completedGoals || countOfWishes != completedWishes) { return }
//        let addView = (self.parentViewController() as! NomadViewController).underView.subviews.last as! NomadAddView
//        addView.endTime.text = Date().convertToTime()
//        UserDefaults.standard.set(Date().convertToTime(), forKey: "timeOfFinalPageOpened")
//        let finalView = NomadFinalView.instanceFromXib()
//        finalView.alpha = 0
//        self.parentViewController()?.view.addSubview(finalView)
//        UIView.animate(withDuration: 0.5, animations: {
//            finalView.alpha = 1
//        })
    }
}
extension NomadLifeView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.item == collectionView.numberOfItems(inSection: 0) - 1){
            //추가 버튼을 누르면...
            let parentViewController = self.parentViewController() as! NomadViewController
            if(parentViewController.searchBar.isFirstResponder){
                parentViewController.searchBar.endEditing(true)
            }
            let addView = parentViewController.underView.subviews.last as! NomadAddView
            addView.textField.becomeFirstResponder()
        } else {
            //이외의 버튼을 누르면...
            let alert = UIAlertController(title: nil, message: "삭제할까요?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "예", style: .default, handler: { (action) in
                let id = self.object[indexPath.item].id
                let query = NSPredicate(format: "id = %d", id)
                let result = self.object.filter(query).filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd])
                try! self.realm.write{
                    self.realm.delete(result)
                }
                collectionView.deleteItems(at: [indexPath])
                collectionView.layoutIfNeeded()
                self.openFinalPage()
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
