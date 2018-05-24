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
    @IBOutlet var upperViewAspectRatio: NSLayoutConstraint!
    @IBOutlet var searchBar: UITextField!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var slideDownView: UIImageView!
    @IBOutlet var slideDownLabel: UILabel!
    @IBOutlet var addView: UIView!
    @IBOutlet var addTodoButton: UIButton!
    @IBOutlet var hashtagButton: UIButton!
    @IBOutlet var addTodoTextField: UITextField!
    @IBOutlet var summaryView: UIView!
    @IBOutlet var completeTimeLabel: UILabel!
    @IBOutlet var yesterdayLabel: UILabel!
    @IBOutlet var summaryButton: UIButton!
    @IBOutlet var panView: UIView!
    
    //MARK:- AddView bottom layout constraint
    @IBOutlet var addViewBottom: NSLayoutConstraint!
    
    //MARK:- 프로퍼티
    var realm: Realm!
    var todayObject: Results<WishListInfo>!
    var yesterdayObject: Results<WishListInfo>!
    var popup: WishYesterdayView!
    
    //MARK:- 기본 메소드
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        self.todayObject = realm.objects(ProjectInfo.self).last?.wishLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd])
        self.yesterdayObject = realm.objects(ProjectInfo.self).last?.wishLists.filter("date BETWEEN %@", [Date.yesterdayStart, Date.yesterdayEnd])
        
        //컬렉션 뷰 태그 설정 : 메인 0번 카드뷰 1번
        self.collectionView.tag = 0
        
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
        flowLayout.sectionHeadersPinToVisibleBounds = true
        let quarter = self.collectionView.frame.width / 4
        flowLayout.itemSize = CGSize(width: quarter - 40, height: quarter - 20)
        self.collectionView.collectionViewLayout = flowLayout
        
        //타겟 등록
        self.addTodoButton.addTarget(self, action: #selector(self.touchUpAddButton(_:)), for: .touchUpInside)
        self.hashtagButton.addTarget(self, action: #selector(self.touchUpHashtagButton(_:)), for: .touchUpInside)
        self.searchBar.addTarget(self, action: #selector(self.searchBarDidChange(_:)), for: .editingChanged)
        self.addTodoTextField.addTarget(self, action: #selector(self.searchBarDidChange(_:)), for: .editingChanged)
        self.summaryButton.addTarget(self, action: #selector(self.touchUpSummaryButton(_:)), for: .touchUpInside)
        
        //스와이프 제스처 등록
        self.panView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.panUpperView(_:))))
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
            self.summaryView.isHidden = false
            self.setYesterdaySummary()
            self.setYesterdayLabel()
        }
        self.completeTimeLabel.text = UserDefaults.standard.string(forKey: "completeTime") ?? nil
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
                self.todayObject = realm.objects(ProjectInfo.self).last?.wishLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd]).filter("todo CONTAINS[c] '" + keyword + "'")
                self.collectionView.reloadSections(IndexSet(0...0))
            } else {
                self.todayObject = realm.objects(ProjectInfo.self).last?.wishLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd])
                self.collectionView.reloadSections(IndexSet(0...0))
            }
        }
    }
    
    @objc func touchUpAddButton(_ sender: UIButton) {
        guard let text = self.addTodoTextField.text else { return }
        if text.isEmpty { return }
        guard let cardView = self.view.subviews.last as? CardView else { return }
        if let selectedIndexPath = cardView.collectionView.indexPathsForSelectedItems?.first {
            addWishList(text, selectedIndexPath.item)
        } else {
            addWishList(text)
        }
        try! realm.write {
            realm.objects(ProjectInfo.self).last?.wishLists.append(realm.objects(WishListInfo.self).last!)
        }
        self.todayObject = realm.objects(ProjectInfo.self).last?.wishLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd])
        if self.todayObject.count == 1 {
            self.collectionView.reloadData()
        } else {
            self.collectionView.reloadSections(IndexSet(0...0))
        }
        self.addTodoTextField.text = nil
        self.addTodoTextField.endEditing(true)
        if self.view.subviews.last is CardView {
            self.view.subviews.last?.removeFromSuperview()
        }
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
    
    //MARK: 화면 전환
    @objc func panUpperView(_ gesture: UIPanGestureRecognizer) {
        let initialAspectRatio: CGFloat = 98.0 / 375.0
        let distance = self.view.frame.width * initialAspectRatio
        func initialize() {
            self.upperViewAspectRatio.constant = 0
            self.slideDownView.alpha = 0
            self.slideDownLabel.alpha = 0
        }
        switch gesture.state {
        case .changed:
            let y = gesture.translation(in: self.view).y + distance
            if y < distance { return }
            let alpha: CGFloat = (y - 98) / 102
            self.upperViewAspectRatio.constant = y - distance
            self.slideDownView.alpha = alpha
            self.slideDownLabel.alpha = alpha
            if y >= 200 {
                guard let parent = self.parent as? ParentViewController else { return }
                parent.switchViewController(from: parent.wishViewController, to: parent.goalViewController)
                UserDefaults.standard.set(false, forKey: "isWishViewControllerFirst")
                initialize()
            }
        case .ended:
            initialize()
        default:
            break
        }
    }
    
    @objc func touchUpSummaryButton(_ sender: UIButton) {
        popup = WishYesterdayView.instanceFromXib() as? WishYesterdayView
        popup.delegate = self
        popup.tableView.delegate = self
        popup.tableView.dataSource = self
        popup.tableView.emptyDataSetSource = self
        popup.tableView.tag = 2
        popup.dateLabel.text = self.yesterdayLabel.text
        popup.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        popup.frame = self.view.bounds
        self.view.addSubview(popup)
        popup.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.popup.alpha = 1
        }
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
        guard let yesterday = realm.objects(ProjectInfo.self).last?.wishLists.filter("date BETWEEN %@", [Date.yesterdayStart, Date.yesterdayEnd]) else { return }
        var text: String?
        switch yesterday.count {
        case 0:
            text = "어제 등록한 노트가 없습니다."
        case 1:
            text = yesterday.first?.todo
        default:
            text = (yesterday.first?.todo ?? "") + " 및 \(yesterday.count - 1)개"
        }
        self.summaryButton.setTitle(text, for: .normal)
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
        if self.view.subviews.last is CardView {
            self.view.subviews.last?.removeFromSuperview()
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.searchBar { return }
        let cardView = CardView.instanceFromXib() as! CardView
        cardView.collectionView.delegate = self
        cardView.collectionView.dataSource = self
        cardView.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: "kind", withReuseIdentifier: "cardHeaderView")
        cardView.collectionView.tag = 1
        self.view.addSubview(cardView)
        cardView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(113)
            make.bottom.equalTo(self.addView.snp.top)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        cardView.collectionView.reloadData()
    }
}

//MARK:- 어제 요약 정보 커스텀 델리게이트 구현
extension WishViewController: WishYesterdayViewDelegate {
    func touchUpExitButton() {
        UIView.animate(withDuration: 0.3, animations: {
            self.popup.alpha = 0
        }) { _ in
            self.popup.removeFromSuperview()
        }
    }
}

//MARK:- 셀 커스텀 델리게이트 구현
extension WishViewController: WishCellDelegate {
    func touchUpCheckBox(_ sender: BEMCheckBox) {
        let id = sender.tag
        let query = NSPredicate(format: "id = %d", id)
        guard let result = self.todayObject.filter(query).first else { return }
        if sender.on {
            try! realm.write {
                result.status = true
            }
        } else {
            try! realm.write {
                result.status = false
            }
        }
        (self.parent as? ParentViewController)?.presentCompleteViewController()
    }
}

//MARK:- 컬렉션 뷰 데이터 소스 구현
extension WishViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wishCell", for: indexPath) as? WishCell else { return UICollectionViewCell() }
            cell.delegate = self
            let gesture = UITapGestureRecognizer(target: self, action: #selector(touchUpPlus(_:)))
            if indexPath.item == 0 {
                cell.todoImageView.image = #imageLiteral(resourceName: "Plus")
                cell.todoImageView.addGestureRecognizer(gesture)
                cell.todoLabel.text = nil
                cell.checkBox.isHidden = true
            } else {
                let result = self.todayObject[indexPath.item - 1]
                cell.checkBox.tag = result.id
                cell.todoImageView.image = result.pictureIndex == -1 ? nil : UIImage(imageLiteralResourceName: "wish\(result.pictureIndex)")
                cell.todoImageView.removeGestureRecognizer(gesture)
                cell.todoLabel.text = result.todo
                cell.checkBox.isHidden = false
                if result.status {
                    cell.checkBox.setOn(true, animated: false)
                } else {
                    cell.checkBox.setOn(false, animated: false)
                }
                cell.checkBox.reload()
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as? CardCell else { return UICollectionViewCell() }
            cell.imageView.image = UIImage(imageLiteralResourceName: "wish\(indexPath.item)")
            if cell.isSelected {
                cell.backgroundImageView.layer.borderColor = UIColor.salmon.cgColor
                cell.backgroundImageView.layer.borderWidth = 2
            } else {
                cell.backgroundImageView.layer.borderWidth = 0
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return self.todayObject.count == 0 ? 0 : self.todayObject.count + 1
        } else {
            return 27
        }
        
    }
}

//MARK:- 컬렉션 뷰 델리게이트 구현
extension WishViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            if indexPath.item == 0 { return }
            let alert = UIAlertController(title: nil, message: "삭제할까요?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "예", style: .destructive) { (action) in
                //목록 삭제
                let id = self.todayObject[indexPath.item - 1].id
                let query = NSPredicate(format: "id = %d", id)
                let result = self.todayObject.filter(query).filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd])
                try! self.realm.write {
                    self.realm.delete(result)
                }
                if self.todayObject.count == 0 {
                    collectionView.reloadData()
                } else {
                    collectionView.deleteItems(at: [indexPath])
                }
                (self.parent as? ParentViewController)?.presentCompleteViewController()
            }
            let noAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
            alert.addAction(noAction)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            guard let item = collectionView.cellForItem(at: indexPath) as? CardCell else { return }
            item.backgroundImageView.layer.borderWidth = 2
            item.backgroundImageView.layer.borderColor = UIColor.salmon.cgColor
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            guard let item = collectionView.cellForItem(at: indexPath) as? CardCell else { return }
            item.backgroundImageView.layer.borderWidth = 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView.tag == 0 {
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
        } else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: "kind", withReuseIdentifier: "cardHeaderView", for: indexPath)
        }
    }
}

//MARK:- 컬렉션 뷰 델리게이트 플로우 레이아웃 구현
extension WishViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView.tag == 0 {
            if collectionView.numberOfItems(inSection: 0) == 0 {
                return .zero
            } else {
                return CGSize(width: self.view.frame.width, height: 60)
            }
        } else {
            return CGSize(width: 0, height: 26)
        }
    }
}

//MARK:- 어제 요약 정보 테이블뷰 데이터소스 구현
extension WishViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "wishYesterdayCell", for: indexPath) as? WishYesterdayCell else { return UITableViewCell() }
        let result = self.yesterdayObject[indexPath.row]
        cell.todoLabel.text = result.todo
        cell.cardImageView.image = result.pictureIndex == -1 ? nil : UIImage(imageLiteralResourceName: "wish\(result.pictureIndex)")
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.yesterdayObject.count
    }
}

//MARK:- 어제 요약 정보 테이블뷰 델리게이트 구현
extension WishViewController: UITableViewDelegate {
    
}

//MARK:- Empty Data Set Source 구현
extension WishViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if scrollView.tag != 2 {
            let title = NSAttributedString(string: "유목 생활 노트", attributes: [.font: UIFont.textStyle6, .foregroundColor: UIColor.aquamarine])
            return title
        } else {
            return nil
        }
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if scrollView.tag != 2 {
            let description = NSAttributedString(string: "유목 기간 동안 하고 싶은 일을 체크하세요.\n쉽고 편리하게 카드를 추가하고\n낯선 공간에서의 즐거움을 느껴보세요!", attributes: [.font : UIFont.textStyle5, .foregroundColor: UIColor.aquamarine])
            return description
        } else {
            let description = NSAttributedString(string: "어제 등록한 노트가 없습니다.", attributes: [.font : UIFont.textStyle5, .foregroundColor: UIColor.aquamarine])
            return description
        }
    }
}

//MARK:- Empty Data Set Delegate 구현
extension WishViewController: DZNEmptyDataSetDelegate {
    
}
