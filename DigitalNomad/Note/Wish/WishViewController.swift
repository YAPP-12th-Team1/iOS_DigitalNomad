//
//  WishViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 13..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import RealmSwift
import BEMCheckBox
import SnapKit

class WishViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet var searchBar: UITextField!
    @IBOutlet var collectionView: UICollectionView!
    var realm: Realm!
    
    //MARK:- 기본 메소드
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        //서치바 텍스트 보여지는 패딩 설정
        self.searchBar.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: self.searchBar.frame.height))
        self.searchBar.leftViewMode = .always
        
        //컬렉션뷰 플로우 레이아웃 설정
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        flowLayout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 60)
        let quarter = self.collectionView.frame.width / 4
        flowLayout.itemSize = CGSize(width: quarter - 20, height: quarter * 1.5)
        self.collectionView.collectionViewLayout = flowLayout
    }
    
    //MARK:- 사용자 정의 메소드
    
    //완료 페이지 여는 조건
    func presentCompleteViewController(){
        let project = realm.objects(ProjectInfo.self).last
        guard let goals = project?.goalLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd]) else { return }
        guard let wishes = project?.wishLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd]) else { return }
        let entireGoals = goals.count
        let entireWishes = wishes.count
        let completedGoals = goals.filter("status = true").count
        let completedWishes = wishes.filter("status = true").count
        if entireGoals != completedGoals || entireWishes != completedWishes { return }
        guard let completeViewController = storyboard?.instantiateViewController(withIdentifier: "CompleteViewController") else { return }
        completeViewController.modalTransitionStyle = .crossDissolve
        self.present(completeViewController, animated: true, completion: nil)
    }
}

//MARK:- 텍스트 필드 델리게이트 구현
extension WishViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

//MARK:- 컬렉션 뷰 데이터 소스 구현
extension WishViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wishCell", for: indexPath) as? WishCell else { return UICollectionViewCell() }
        if indexPath.item == 0 {
            cell.todoImageView.image = #imageLiteral(resourceName: "Plus")
            cell.todoLabel.text = nil
        } else {
            
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}

//MARK:- 컬렉션 뷰 델리게이트 구현
extension WishViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "wishHeaderView", for: indexPath)
        header.frame = CGRect(x: 0, y: 0, width: self.collectionView.frame.width, height: 60)
        header.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //MARK: 오늘 날짜 표시
        let todayLabel = UILabel()
        let todayText = Date.todayDateToString
        let todaySplit = todayText.split(separator: " ")
        let monthString = todaySplit[1].description
        let dayString = todaySplit[2].description
        let monthLocation: Int = {
            if monthString.count == 2 {
                return 7
            } else if monthString.count == 3 {
                return 8
            } else {
                return -1
            }
        }()
        let dayLocation: Int = {
            if dayString.count == 2 {
                return monthLocation + 3
            } else if dayString.count == 3 {
                return monthLocation + 4
            } else {
                return -1
            }
        }()
        let attrToday = NSMutableAttributedString(string: todayText, attributes: [
            .font: UIFont.systemFont(ofSize: 22.0, weight: .medium),
            .foregroundColor: UIColor.aquamarine
            ])
        attrToday.addAttribute(.font, value: UIFont(name: "AppleSDGothicNeo-Medium", size: 22.0)!, range: NSRange(location: 4, length: 1))
        attrToday.addAttribute(.font, value: UIFont(name: "AppleSDGothicNeo-Medium", size: 22.0)!, range: NSRange(location: monthLocation, length: 1))
        attrToday.addAttribute(.font, value: UIFont(name: "AppleSDGothicNeo-Medium", size: 22.0)!, range: NSRange(location: dayLocation, length: 1))
        todayLabel.attributedText = attrToday
        header.addSubview(todayLabel)
        todayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(header.snp.left).offset(33)
            make.centerY.equalTo(header.snp.centerY)
        }
        //MARK: n일차 표시
        let daysLabel = UILabel()
        header.addSubview(daysLabel)
        daysLabel.snp.makeConstraints { (make) in
            make.right.equalTo(header.snp.right).offset(-33)
            make.left.equalTo(todayLabel.snp.right).offset(8)
            make.centerY.equalTo(todayLabel.snp.centerY)
            make.top.equalTo(todayLabel.snp.top)
            make.bottom.equalTo(todayLabel.snp.bottom)
        }
        guard let savedDate = realm.objects(ProjectInfo.self).last?.date else { return UICollectionReusableView() }
        let daysText = "\(savedDate.dateInterval)일차"
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let attrDays = NSMutableAttributedString(string: daysText, attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: UIColor.white,
            .paragraphStyle: style
            ])
        let daysCount = daysText.count
        let daysLocation = daysCount - 2
        attrDays.addAttribute(.font, value: UIFont(name: "AppleSDGothicNeo-Medium", size: 14)!, range: NSRange(location: daysLocation, length: 2))
        daysLabel.attributedText = attrDays
        daysLabel.layer.cornerRadius = 15
        daysLabel.clipsToBounds = true
        daysLabel.backgroundColor = .aquamarine
        //MARK: 분리선 표시
        let separatorView = UIImageView(image: #imageLiteral(resourceName: "NoteLine"))
        header.addSubview(separatorView)
        separatorView.snp.makeConstraints { (make) in
            make.height.equalTo(2)
            make.width.equalTo(header.snp.width)
            make.bottom.equalTo(header.snp.bottom)
        }
        return header
    }
}

//MARK:- 컬렉션 뷰 델리게이트 플로우 레이아웃 구현
extension WishViewController: UICollectionViewDelegateFlowLayout {
    
}

//MARK:- Empty Data Set Source 구현
extension WishViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let title = NSAttributedString(string: "유목 생활 노트", attributes: [.font: UIFont.textStyle6, .foregroundColor: UIColor.aquamarine])
        return title
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let description = NSAttributedString(string: "유목 기간 동안 하고 싶은 일을 체크하세요.\n쉽고 편리하게 카드를 추가하고\n낯선 공간에서의 즐거움을 느껴보세요!", attributes: [.font : UIFont.textStyle5, .foregroundColor: UIColor.aquamarine])
        return description
    }
}

//MARK:- Empty Data Set Delegate 구현
extension WishViewController: DZNEmptyDataSetDelegate {
    
}
