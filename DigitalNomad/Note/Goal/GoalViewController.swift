//
//  NoteViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 13..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import BEMCheckBox
import SnapKit
import RealmSwift
import SwipeCellKit

class GoalViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet var searchBar: UITextField!
    @IBOutlet var addTodoTextField: UITextField!
    @IBOutlet var hashtagButton: UIButton!
    @IBOutlet var addTodoButton: UIButton!
    @IBOutlet var addView: UIView!
    @IBOutlet var tableView: UITableView!
    
    //MARK:- AddView bottom layout constraint
    @IBOutlet var addViewBottom: NSLayoutConstraint!
    
    //MARK:- 프로퍼티
    var realm: Realm!
    var object: Results<GoalListInfo>!
    
    //MARK:- 기본 메소드
    override func viewDidLoad() {
        super.viewDidLoad()
        self.realm = try! Realm()
        
        //데이터 초기화
        self.object = realm.objects(ProjectInfo.self).last?.goalLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd])
        
        //서치바 텍스트 보여지는 패딩 설정
        self.searchBar.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: self.searchBar.frame.height))
        self.searchBar.leftViewMode = .always
        self.addTodoTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: self.hashtagButton.frame.width + (self.hashtagButton.frame.origin.x - self.addTodoTextField.frame.origin.x) + 8, height: 0))
        self.addTodoTextField.leftViewMode = .always
        
        //타겟 등록
        self.addTodoButton.addTarget(self, action: #selector(self.touchUpAddButton(_:)), for: .touchUpInside)
        self.hashtagButton.addTarget(self, action: #selector(self.touchUpHashtagButton(_:)), for: .touchUpInside)
        self.searchBar.addTarget(self, action: #selector(self.searchBarDidChange(_:)), for: .editingChanged)
        self.addTodoTextField.addTarget(self, action: #selector(self.searchBarDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    //MARK:- 사용자 정의 메소드
    //MARK: 키보드 출현 여부에 따른 뷰 이동 처리 메소드
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
    
    //MARK: 버튼 입력에 따른 처리 메소드
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
    
    @objc func touchUpAddButton(_ sender: UIButton) {
        //일정 등록
        guard let text = self.addTodoTextField.text else { return }
        if text.isEmpty { return }
        addGoalList(text)
        try! realm.write {
            realm.objects(ProjectInfo.self).last?.goalLists.append(realm.objects(GoalListInfo.self).last!)
        }
        self.object = realm.objects(ProjectInfo.self).last?.goalLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd])
        if self.object.count == 1 {
            self.tableView.reloadData()
        } else {
            self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
        }
        self.addTodoTextField.text = nil
        self.addTodoTextField.endEditing(true)
    }
    
    @objc func searchBarDidChange(_ sender: UITextField) {
        //공백이 입력되면 그것을 지운다. 서치바가 현재 리스폰더이면 일정 검색
        if sender.text! == " " {
            sender.text = nil
            return
        }
        if sender == self.searchBar {
            let keyword = sender.text!
            if !keyword.isEmpty {
                self.object = realm.objects(ProjectInfo.self).last?.goalLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd]).filter("todo CONTAINS[c] '" + keyword + "'")
                self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
            } else {
                self.object = realm.objects(ProjectInfo.self).last?.goalLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd])
                self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
            }
        }
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
}

//MARK:- 텍스트필드 델리게이트 구현
extension GoalViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

//MARK:- 셀 커스텀 델리게이트 구현
extension GoalViewController: GoalCellDelegate {
    func clickCheckBox(_ sender: BEMCheckBox, todo: UIButton) {
        let id = sender.tag
        let query = NSPredicate(format: "id = %d", id)
        guard let result = self.object?.filter(query).first else { return }
        let text = todo.titleLabel?.text ?? ""
        let attrText = NSMutableAttributedString(string: text)
        if sender.on {
            attrText.addAttributes([
                .strikethroughStyle : 2,
                .strikethroughColor: UIColor.black], range: NSRange(location: 0, length: text.count))
            try! realm.write {
                result.status = true
            }
        } else {
            attrText.addAttributes([.strikethroughStyle : 0], range: NSRange(location: 0, length: text.count))
            try! realm.write {
                result.status = false
            }
        }
        switch result.importance {
        case 0:
            attrText.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: text.count))
        case 1:
            attrText.addAttribute(.foregroundColor, value: UIColor.blue, range: NSRange(location: 0, length: text.count))
        case 2:
            attrText.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: 0, length: text.count))
        default:
            break
        }
        todo.setAttributedTitle(attrText, for: .normal)
        self.presentCompleteViewController()
    }
    
    func clickTodoButton(_ sender: UIButton) {
        let id = sender.tag
        let query = NSPredicate(format: "id = %d", id)
        guard let result = self.object.filter(query).first else { return }
        guard let attrText = sender.attributedTitle(for: .normal) else { return }
        let mutableText = NSMutableAttributedString(attributedString: attrText)
        switch result.importance {
        case 0:
            mutableText.addAttribute(.foregroundColor, value: UIColor.blue, range: NSRange(location: 0, length: attrText.length))
            try! realm.write {
                result.importance = 1
            }
        case 1:
            mutableText.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: 0, length: attrText.length))
            try! realm.write {
                result.importance = 2
            }
        case 2:
            mutableText.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: attrText.length))
            try! realm.write {
                result.importance = 0
            }
        default:
            return
        }
        sender.setAttributedTitle(mutableText, for: .normal)
    }
}

//MARK:- 테이블 뷰 데이터 소스 구현
extension GoalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath) as? GoalCell else { return UITableViewCell() }
        cell.delegate = self
        cell.goalCellDelegate = self
        let result = self.object[indexPath.row]
        cell.checkBox.tag = result.id
        cell.todoButton.tag = result.id
        let text = result.todo
        let wholeRange = NSRange(location: 0, length: text.count)
        if result.status {
            cell.checkBox.setOn(true, animated: false)
            let attrText = NSMutableAttributedString(string: text, attributes: [
                .strikethroughStyle: 2,
                .strikethroughColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 14, weight: .regular)
                ])
            switch result.importance {
            case 0:
                attrText.addAttribute(.foregroundColor, value: UIColor.black, range: wholeRange)
            case 1:
                attrText.addAttribute(.foregroundColor, value: UIColor.blue, range: wholeRange)
            case 2:
                attrText.addAttribute(.foregroundColor, value: UIColor.red, range: wholeRange)
            default:
                break
            }
            cell.todoButton.setAttributedTitle(attrText, for: .normal)
        } else {
            cell.checkBox.setOn(false, animated: false)
            let attrText = NSMutableAttributedString(string: text, attributes: [
                .strikethroughStyle: 0,
                .font: UIFont.systemFont(ofSize: 14, weight: .regular)
                ])
            switch result.importance {
            case 0:
                attrText.addAttribute(.foregroundColor, value: UIColor.black, range: wholeRange)
            case 1:
                attrText.addAttribute(.foregroundColor, value: UIColor.blue, range: wholeRange)
            case 2:
                attrText.addAttribute(.foregroundColor, value: UIColor.red, range: wholeRange)
            default:
                break
            }
            cell.todoButton.setAttributedTitle(attrText, for: .normal)
            cell.todoButton.sizeToFit()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.object.count
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//MARK:- 테이블 뷰 델리게이트 구현
extension GoalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 60))
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
            .foregroundColor: UIColor.salmon
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
        daysLabel.backgroundColor = .salmon
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.object.count == 0 { return 0 }
        return 60
    }
}
//MARK:- 셀 스와이프 라이브러리 델리게이트 구현
extension GoalViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let result = self.object[indexPath.row]
        let postponeAction = SwipeAction(style: .default, title: nil) { (action, indexPath) in
            let id = result.id
            let query = NSPredicate(format: "id = %d", id)
            guard let postponeCell = self.object.filter(query).first else { return }
            let tomorrow = Date.tomorrowDate
            try! self.realm.write {
                postponeCell.date = tomorrow
            }
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
            self.presentCompleteViewController()
            action.fulfill(with: .delete)
        }
        let deleteAction = SwipeAction(style: .default, title: nil) { (action, indexPath) in
            try! self.realm.write {
                self.realm.delete(result)
            }
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
            self.presentCompleteViewController()
            action.fulfill(with: .delete)
        }
        postponeAction.image = #imageLiteral(resourceName: "hours24")
        postponeAction.backgroundColor = .aquamarine
        deleteAction.image = #imageLiteral(resourceName: "CellDelete")
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
        return [deleteAction, postponeAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .none
        options.transitionStyle = .border
        return options
    }
}

//MARK:- Empty Data Set Source 구현
extension GoalViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let title = NSAttributedString(string: "유목 생활 노트", attributes: [.font: UIFont.textStyle6, .foregroundColor: UIColor.darkPeach])
        return title
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let description = NSAttributedString(string: "유목 기간 동안 해야 할 일을 작성하세요.\n해시태그(#)와 중요도를 기반으로\n쉽게 검색하고 관리해 보세요!", attributes: [.font : UIFont.textStyle5, .foregroundColor: UIColor.darkPeach])
        return description
    }
}

//MARK:- Empty Data Set Delegate 구현
extension GoalViewController: DZNEmptyDataSetDelegate {
    
}
