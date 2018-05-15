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
    @IBOutlet var addView: UIView!
    @IBOutlet var addTodoButton: UIButton!
    @IBOutlet var hashtagButton: UIButton!
    @IBOutlet var addTodoTextField: UITextField!
    @IBOutlet var summaryView: UIView!
    @IBOutlet var completeTimeLabel: UILabel!
    @IBOutlet var yesterdayLabel: UILabel!
    @IBOutlet var summaryButton: UIButton!
    
    //MARK:- AddView bottom layout constraint
    @IBOutlet var addViewBottom: NSLayoutConstraint!
    
    //MARK:- 프로퍼티
    var realm: Realm!
    var object: Results<WishListInfo>!
    
    //MARK:- 기본 메소드
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        object = realm.objects(ProjectInfo.self).last?.wishLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd])
        
        //텍스트 필드 텍스트 보여지는 패딩 설정
        self.searchBar.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: self.searchBar.frame.height))
        self.searchBar.leftViewMode = .always
        self.addTodoTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: self.hashtagButton.frame.width + (self.hashtagButton.frame.origin.x - self.addTodoTextField.frame.origin.x) + 8, height: 0))
        self.addTodoTextField.leftViewMode = .always
        
        //컬렉션뷰 플로우 레이아웃 설정
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        let quarter = self.collectionView.frame.width / 4
        flowLayout.itemSize = CGSize(width: quarter - 40, height: quarter - 20)
        self.collectionView.collectionViewLayout = flowLayout
        
        //타겟 등록
        self.addTodoButton.addTarget(self, action: #selector(self.touchUpAddButton(_:)), for: .touchUpInside)
        self.hashtagButton.addTarget(self, action: #selector(self.touchUpHashtagButton(_:)), for: .touchUpInside)
        self.searchBar.addTarget(self, action: #selector(self.searchBarDidChange(_:)), for: .editingChanged)
        self.addTodoTextField.addTarget(self, action: #selector(self.searchBarDidChange(_:)), for: .editingChanged)
        self.summaryButton.addTarget(self, action: #selector(self.touchUpSummaryButton(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        self.postponePreviousWishes()
        self.collectionView.reloadData()
        if realm.objects(ProjectInfo.self).last?.date.dateInterval == 1 {
            self.summaryView.isHidden = true
        } else {
            self.summaryView.isHidden = true
            self.setYesterdaySummary()
            self.setYesterdayLabel()
        }
    }
    
    //MARK:- 사용자 정의 메소드
    @objc func keyboardWillShow(_ notification: Notification) {
        if self.searchBar.isFirstResponder { return }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            self.addView.frame.origin.y = self.view.frame.height - 49 - keyboardHeight
            self.addViewBottom.constant = keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if self.searchBar.isFirstResponder { return }
        self.addView.frame.origin.y = self.view.frame.height - 49
        self.addViewBottom.constant = 49
    }
    
    @objc func touchUpPlus(_ gesture: UITapGestureRecognizer) {
        self.addTodoTextField.becomeFirstResponder()
    }
    
    @objc func searchBarDidChange(_ sender: UITextField) {
        if sender.text! == " " {
            sender.text = nil
            return
        }
        if sender == self.searchBar {
            let keyword = sender.text!
            if !keyword.isEmpty {
                self.object = realm.objects(ProjectInfo.self).last?.wishLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd]).filter("todo CONTAINS[c] '" + keyword + "'")
                self.collectionView.reloadSections(IndexSet(0...0))
            } else {
                self.object = realm.objects(ProjectInfo.self).last?.wishLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd])
                self.collectionView.reloadSections(IndexSet(0...0))
            }
        }
    }
    
    @objc func touchUpAddButton(_ sender: UIButton) {
        guard let text = self.addTodoTextField.text else { return }
        if text.isEmpty { return }
        addWishList(text, -1)
        try! realm.write {
            realm.objects(ProjectInfo.self).last?.wishLists.append(realm.objects(WishListInfo.self).last!)
        }
        self.object = realm.objects(ProjectInfo.self).last?.wishLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd])
        self.collectionView.reloadSections(IndexSet(0...0))
//        if self.object.count == 1 {
//            self.collectionView.reloadData()
//        } else {
//            self.collectionView.reloadSections(IndexSet(0...0))
//        }
        self.addTodoTextField.text = nil
        self.addTodoTextField.endEditing(true)
    }
    
    @objc func touchUpHashtagButton(_ sender: UIButton) {
        //해시태그 중복 입력 방지
        let text = self.addTodoTextField.text ?? ""
        guard let lastChar = text.last else {
            self.addTodoTextField.text = "#"
            return
        }
        if lastChar != "#" {
            self.addTodoTextField.text! += "#"
        }
    }
    
    @objc func touchUpSummaryButton(_ sender: UIButton) {
        
    }
    
    //MARK: 어제 날짜 설정
    func setYesterdayLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M/dd"
        self.yesterdayLabel.text = dateFormatter.string(from: Date.yesterdayDate)
    }
    
    //MARK: 어제 요약 정보 설정
    func setYesterdaySummary() {
        guard let yesterday = realm.objects(ProjectInfo.self).last?.goalLists.filter("date BETWEEN %@", [Date.yesterdayStart, Date.yesterdayEnd]) else { return }
        var text: String?
        switch yesterday.count {
        case 0:
            text = "어제 등록한 노트가 없습니다."
        case 1:
            text = yesterday.first?.todo
        default:
            text = yesterday.first?.todo ?? "" + " 및 \(yesterday.count - 1)개"
        }
        self.summaryButton.setTitle(text, for: .normal)
    }
    
    //MARK: 완료 페이지 여는 조건
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
    
    //MARK: 자동 미루기
    func postponePreviousWishes() {
        guard let project = realm.objects(ProjectInfo.self).last else { return }
        let query = NSPredicate(format: "date < %@", Date.todayStart as NSDate)
        let wishes = project.wishLists.filter(query).filter("status = false")
        try! realm.write {
            for wish in wishes {
                wish.date = Date()
            }
        }
    }
}

//MARK:- 텍스트 필드 델리게이트 구현
extension WishViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

extension WishViewController: WishCellDelegate {
    func touchUpCheckBox(_ sender: BEMCheckBox) {
        let id = sender.tag
        let query = NSPredicate(format: "id = %d", id)
        guard let result = self.object.filter(query).first else { return }
        if sender.on {
            try! realm.write {
                result.status = true
            }
        } else {
            try! realm.write {
                result.status = false
            }
        }
        self.presentCompleteViewController()
    }
}

//MARK:- 컬렉션 뷰 데이터 소스 구현
extension WishViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wishCell", for: indexPath) as? WishCell else { return UICollectionViewCell() }
        cell.delegate = self
        let gesture = UITapGestureRecognizer(target: self, action: #selector(touchUpPlus(_:)))
        if indexPath.item == 0 {
            cell.todoImageView.image = #imageLiteral(resourceName: "Plus")
            cell.todoImageView.addGestureRecognizer(gesture)
            cell.todoLabel.text = nil
            cell.checkBox.isHidden = true
        } else {
            let result = self.object[indexPath.item - 1]
            cell.checkBox.tag = result.id
            cell.todoImageView.image = nil
            cell.todoImageView.removeGestureRecognizer(gesture)
            cell.todoLabel.text = result.todo
            cell.checkBox.isHidden = false
            if result.status {
                cell.checkBox.setOn(true, animated: false)
            } else {
                cell.checkBox.setOn(false, animated: false)
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.object.count + 1
    }
}

//MARK:- 컬렉션 뷰 델리게이트 구현
extension WishViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 { return }
        let alert = UIAlertController(title: nil, message: "삭제할까요?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "예", style: .destructive) { (action) in
            //목록 삭제
            let id = self.object[indexPath.item - 1].id
            let query = NSPredicate(format: "id = %d", id)
            let result = self.object.filter(query).filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd])
            try! self.realm.write {
                self.realm.delete(result)
            }
//            let indexPathOfSelectedItem = IndexPath(item: indexPath.item - 1, section: 0)
//            collectionView.deleteItems(at: [indexPathOfSelectedItem])
            collectionView.deleteItems(at: [indexPath])
//            collectionView.layoutIfNeeded()
        }
        let noAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }
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
        let separatorView = UIImageView(image: #imageLiteral(resourceName: "HorizontalLineBlue"))
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView.numberOfItems(inSection: 0) == 0 {
            return .zero
        } else {
            return CGSize(width: self.view.frame.width, height: 60)
        }
    }
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
