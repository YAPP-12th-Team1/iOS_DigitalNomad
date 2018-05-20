//
//  EnrollViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 19..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import AKPickerView_Swift

class EnrollViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var enrollButton: UIButton!
    
    //MARK:- 프로퍼티
    let coworkingTitles = ["직업", "소개말", "밋업 목적"]
    var recommendedPlace: String?
    let enrollInfo = EnrollInfo.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //유목지, 일수 먼저 저장
        self.enrollInfo.address = recommendedPlace
        self.enrollInfo.days = 7
        
        //등록 버튼 초기화
        self.enrollButton.isEnabled = false
        self.enrollButton.addTarget(self, action: #selector(touchUpEnrollButton(_:)), for: .touchUpInside)
    }
    
    @objc func touchUpEnrollButton(_ sender: UIButton) {
        //개인정보 저장, 파이어베이스 업로드
        addProject(self.enrollInfo.days!)
        if self.enrollInfo.isCoworking! {
            addUser(address: self.enrollInfo.address!, day: self.enrollInfo.days!, purpose: self.enrollInfo.purpose!, job: self.enrollInfo.job!, introducing: self.enrollInfo.introducing!, meetupPurpose: self.enrollInfo.meetupPurpose!, emailTitle: self.enrollInfo.emailTitle!, emailContent: self.enrollInfo.emailContent!)
            addEmail(self.enrollInfo.emailTitle!, self.enrollInfo.emailContent!)
        } else {
            addUser(address: self.enrollInfo.address!, day: self.enrollInfo.days!, purpose: self.enrollInfo.purpose!)
            addEmail("", "")
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let next = storyboard.instantiateViewController(withIdentifier: "TabBarController")
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = next
    }
    
    //MARK: 등록 버튼 활성화 여부 결정
    func validateEnrollButton() {
        guard let isCoworking = self.enrollInfo.isCoworking else { return }
        if isCoworking {
            if self.enrollInfo.address != nil && self.enrollInfo.days != nil && self.enrollInfo.purpose != nil && self.enrollInfo.job != nil && self.enrollInfo.introducing != nil && self.enrollInfo.meetupPurpose != nil && self.enrollInfo.emailTitle != nil && self.enrollInfo.emailContent != nil {
                self.enrollButton.isEnabled = true
            } else {
                self.enrollButton.isEnabled = false
            }
        } else {
            if self.enrollInfo.address != nil && self.enrollInfo.days != nil && self.enrollInfo.purpose != nil {
                self.enrollButton.isEnabled = true
            } else {
                self.enrollButton.isEnabled = false
            }
        }
    }
}

//MARK:- 수평 피커 뷰 데이터소스 구현
extension EnrollViewController: AKPickerViewDataSource {
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return 30
    }
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        return "\(item + 1)일"
    }
}

//MARK:- 수평 피커 뷰 델리게이트 구현
extension EnrollViewController: AKPickerViewDelegate {
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        self.enrollInfo.days = item + 1
        self.validateEnrollButton()
    }
}

//MARK:- 텍스트 필드 델리게이트 구현
extension EnrollViewController: UITextFieldDelegate {
    func inputTextFieldInfo(_ textField: UITextField) {
        let text = textField.text!
        switch textField.tag {
        case 0:
            self.enrollInfo.address = text
        case 1:
            self.enrollInfo.purpose = text
        case 2:
            self.enrollInfo.job = text
        case 3:
            self.enrollInfo.introducing = text
        case 4:
            self.enrollInfo.meetupPurpose = text
        case 5:
            self.enrollInfo.emailTitle = text
        default:
            break
        }
        self.validateEnrollButton()
        textField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputTextFieldInfo(textField)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputTextFieldInfo(textField)
    }
}

extension EnrollViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "내용을 입력해주세요." {
            textView.text = nil
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.enrollInfo.emailContent = textView.text
        self.validateEnrollButton()
    }
}

//MARK:- 유목민 연결 셀 커스텀 델리게이트 구현
extension EnrollViewController: ConnectCellDeleagte {
    func touchUpYesButton() {
        self.enrollInfo.isCoworking = true
        self.tableView.reloadData()
        self.validateEnrollButton()
    }
    func touchUpNoButton() {
        self.enrollInfo.isCoworking = false
        self.tableView.reloadData()
        self.validateEnrollButton()
    }
}

//MARK:- 테이블 뷰 데이터 소스 구현
extension EnrollViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as? LocationCell else { return UITableViewCell() }
            cell.locationTextField.tag = 0
            cell.locationTextField.text = self.enrollInfo.address
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as? DateCell else { return UITableViewCell() }
            cell.pickerView.delegate = self
            cell.pickerView.dataSource = self
            cell.pickerView.selectItem(self.enrollInfo.days! - 1)
            cell.pickerView.reloadData()
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "purposeCell", for: indexPath) as? PurposeCell else { return UITableViewCell() }
            cell.purposeTextField.tag = 1
            cell.purposeTextField.text = self.enrollInfo.purpose
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "connectCell", for: indexPath) as? ConnectCell else { return UITableViewCell() }
            cell.delegate = self
            
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "coworkingCell", for: indexPath) as? CoworkingCell else { return UITableViewCell() }
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "직업"
                cell.contentTextField.tag = 2
                cell.contentTextField.text = self.enrollInfo.job
            case 1:
                cell.titleLabel.text = "소개말"
                cell.contentTextField.tag = 3
                cell.contentTextField.text = self.enrollInfo.introducing
            case 2:
                cell.titleLabel.text = "밋업 목적"
                cell.contentTextField.tag = 4
                cell.contentTextField.text = self.enrollInfo.meetupPurpose
            default:
                break
            }
            return cell
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath) as? EmailCell else { return UITableViewCell() }
            cell.titleTextField.tag = 5
            cell.contentTextView.tag = 6
            cell.titleTextField.text = self.enrollInfo.emailTitle
            cell.contentTextView.text = self.enrollInfo.emailContent == nil ? "내용을 입력해주세요." : nil
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        case 3: return 1
        case 4: return 3
        case 5: return 1
        default: return 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let isCoworking = self.enrollInfo.isCoworking else { return 4 }
        return isCoworking ? 6 : 4
    }
}

//MARK:- 테이블 뷰 델리게이트 구현
extension EnrollViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 91
        case 1: return 89
        case 2: return 96
        case 3: return 154
        case 4: return 50
        case 5: return 154
        default: return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 17
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 17))
        view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        return view
    }
}


