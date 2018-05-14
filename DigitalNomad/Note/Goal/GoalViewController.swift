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
        
        //텍스트필드 텍스트 보여지는 패딩 설정
        self.searchBar.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: self.searchBar.frame.height))
        self.searchBar.leftViewMode = .always
        self.addTodoTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: self.hashtagButton.frame.width + (self.hashtagButton.frame.origin.x - self.addTodoTextField.frame.origin.x) + 8, height: 0))
        self.addTodoTextField.leftViewMode = .always
        
        //타겟 등록
        self.addTodoButton.addTarget(self, action: #selector(self.clickAddButton(_:)), for: .touchUpInside)
        self.hashtagButton.addTarget(self, action: #selector(self.clickHashtagButton(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    //MARK:- 키보드 출현에 따른 뷰 이동 메소드
    @objc func keyboardWillShow(_ notification: Notification) {
        if self.searchBar.isFirstResponder { return }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            self.addView.frame.origin.y = self.view.frame.height - 49 - keyboardHeight
            self.addViewBottom.constant += keyboardHeight - 49
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if self.searchBar.isFirstResponder { return }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            self.addView.frame.origin.y  = self.view.frame.height - 49
            self.addViewBottom.constant = 49
        }
    }
    
    //MARK:- 버튼 입력에 따른 처리 메소드
    @objc func clickHashtagButton(_ sender: UIButton) {
        let text = self.addTodoTextField.text ?? ""
        guard let lastChar = text.last else {
            self.addTodoTextField.text = "#"
            return
        }
        if lastChar != "#" {
            self.addTodoTextField.text! += "#"
        }
    }
    
    @objc func clickAddButton(_ sender: UIButton) {
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
        if sender.on {
            let attrText = NSAttributedString(string: text, attributes: [
                NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle,
                NSAttributedStringKey.strikethroughColor: UIColor.black
                ])
            todo.setAttributedTitle(attrText, for: .normal)
            try! realm.write {
                result.status = true
            }
        } else {
            let attrText = NSAttributedString(string: text, attributes: [
                NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleNone,
                ])
            todo.setAttributedTitle(attrText, for: .normal)
            try! realm.write {
                result.status = false
            }
        }
    }
    
    func clickTodoButton(_ sender: UIButton) {
        let id = sender.tag
        let query = NSPredicate(format: "id = %d", id)
        guard let result = self.object?.filter(query).first else { return }
        switch result.importance {
        case 0:
            sender.setTitleColor(.blue, for: .normal)
            try! realm.write {
                result.importance = 1
            }
        case 1:
            sender.setTitleColor(.red, for: .normal)
            try! realm.write {
                result.importance = 2
            }
        case 2:
            sender.setTitleColor(.black, for: .normal)
            try! realm.write {
                result.importance = 0
            }
        default:
            return
        }
    }
}

//MARK:- 테이블 뷰 데이터 소스 구현
extension GoalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath) as? GoalCell else { return UITableViewCell() }
        cell.delegate = self
        cell.goalCellDelegate = self
        guard let result = self.object?[indexPath.row] else { return UITableViewCell() }
        cell.checkBox.tag = result.id
        cell.todoButton.tag = result.id
        let text = result.todo
        let wholeRange = NSRange(location: 0, length: text.count)
        if result.status {
            cell.checkBox.setOn(true, animated: false)
            let attrText = NSMutableAttributedString(string: text, attributes: [
                .strikethroughStyle: NSUnderlineStyle.styleSingle,
                .strikethroughColor: UIColor.black
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
                NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleNone
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
        return self.object?.count ?? -1
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//MARK:- 테이블 뷰 델리게이트 구현
extension GoalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        header.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //MARK: 오늘 날짜 표시
        let todayLabel = UILabel()
        let todayText = "2018년 5월 26일"
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
            make.left.greaterThanOrEqualTo(todayLabel.snp.right).offset(16)
            make.centerY.equalTo(todayLabel.snp.centerY)
            make.top.equalTo(todayLabel.snp.top)
            make.bottom.equalTo(todayLabel.snp.bottom)
        }
        let daysText = "1일차"
        let attrDays = NSMutableAttributedString(string: daysText, attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: UIColor.white,
        
            ])
        let daysCount = daysText.count
        let daysLocation = daysCount - 2
        attrDays.addAttribute(.font, value: UIFont(name: "AppleSDGothicNeo-Medium", size: 14)!, range: NSRange(location: daysLocation, length: 2))
        daysLabel.attributedText = attrDays
        daysLabel.layer.cornerRadius = 10
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
        if self.object?.count == 0 { return 0 }
        return 60
    }
}
//MARK:- 셀 스와이프 라이브러리 델리게이트 구현
extension GoalViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        guard let result = self.object?[indexPath.row] else { return nil }
        let postponeAction = SwipeAction(style: .default, title: nil) { (action, indexPath) in
            //미루기
            action.fulfill(with: .delete)
        }
        let deleteAction = SwipeAction(style: .destructive, title: "삭제") { (action, indexPath) in
            //삭제
            try! self.realm.write {
                self.realm.delete(result)
            }
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            if self.object.count == 0 {
                self.tableView.reloadData()
            }
            action.fulfill(with: .delete)
        }
        postponeAction.image = #imageLiteral(resourceName: "hours24")
        postponeAction.backgroundColor = .aquamarine
//        deleteAction.image =
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
