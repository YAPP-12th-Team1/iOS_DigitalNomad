//
//  MyDetailViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 14..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class MyDetailViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    //MARK:- 프로퍼티
    var realm: Realm!
    var userInfo: UserInfo!
    var emailInfo: EmailInfo!
    let coworkingTitles = ["직업", "소개말", "밋업 목적"]
    
    //MARK:- 기본 메소드
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        
        //UI 초기화
        self.userInfo = realm.objects(UserInfo.self).last
        self.emailInfo = realm.objects(EmailInfo.self).last
        self.nameLabel.text = self.userInfo.nickname
        self.profileImageView.image = (self.navigationController?.viewControllers.first as? MyViewController)?.profileImageView.image
        
        //제스처 등록
        self.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchUpProfileImageView(_:))))
    }
    
    //MARK:- 사용자 정의 메소드
    @objc func touchUpProfileImageView(_ gesture: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = .photoLibrary
            controller.allowsEditing = true
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    //MARK: 이전 화면으로 돌아가기
    @IBAction func touchUpBackButton(_ sender: UIButton) {
        guard let previousViewController = self.navigationController?.viewControllers.first as? MyViewController else { return }
        previousViewController.profileImageView.image = self.profileImageView.image
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: 닉네임 바꾸기
    @IBAction func touchUpEditButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "닉네임 변경", message: "닉네임을 변경합니다.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "닉네임"
            textField.autocorrectionType = .no
        }
        let yesAction = UIAlertAction(title: "확인", style: .default) { (action) in
            guard let text = alert.textFields?.first?.text else { return }
            try! self.realm.write {
                self.userInfo.nickname = text
            }
            Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).updateChildValues(["nickname": text])
            self.nameLabel.text = text
        }
        let noAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: 파이어베이스에 정보 업데이트
    func updateFirebaseInfo(key: String, value: Any) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).updateChildValues([key: value])
    }
    
    //MARK: 파이어베이스에 이메일 관련 정보 업데이트
    func updateFirebaseEmail(key: String, value: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).child("emailInfo").updateChildValues([key: value])
    }
}

//MARK:- 텍스트 필드 델리게이트 구현
extension MyDetailViewController: UITextFieldDelegate {
    func updateUserInfo(_ textField: UITextField) {
        let text = textField.text!
        switch textField.tag {
        case 0:
            updateFirebaseInfo(key: "job", value: text)
            try! realm.write {
                self.userInfo.job = text
            }
        case 1:
            updateFirebaseInfo(key: "introducing", value: text)
            try! realm.write {
                self.userInfo.introducing = text
            }
        case 2:
            updateFirebaseInfo(key: "purpose", value: text)
            try! realm.write {
                self.userInfo.purpose = text
            }
        case 3:
            updateFirebaseEmail(key: "title", value: text)
            try! realm.write {
                 self.emailInfo.title = text
            }
        default:
            break
        }
        textField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateUserInfo(textField)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateUserInfo(textField)
    }
}

//MARK:- 텍스트 뷰 델리게이트 구현
extension MyDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = -100
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
        try! realm.write {
            self.emailInfo.context = textView.text
        }
        updateFirebaseEmail(key: "context", value: textView.text)
    }
}

//MARK- 코워킹 셀 커스텀 델리게이트 구현
extension MyDetailViewController: Section2CoworkingCellDelegate {
    func changeCoworkingSwitchValue(_ sender: UISwitch) {
        if sender.isOn {
            try! realm.write {
                self.userInfo.cowork = true
            }
            self.updateFirebaseInfo(key: "cowork", value: true)
        } else {
            try! realm.write {
                self.userInfo.cowork = false
            }
            self.updateFirebaseInfo(key: "cowork", value: false)
        }
        self.tableView.reloadData()
    }
}

//MARK:- 테이블 뷰 데이터 소스 구현
extension MyDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "section1Cell", for: indexPath) as? Section1Cell else { return UITableViewCell() }
            if indexPath.row == 0 {
                cell.titleLabel.text = "이메일"
                cell.contentLabel.text = self.userInfo.email
            } else {
                cell.titleLabel.text = "유목 장소"
                cell.contentLabel.text = self.userInfo.address
            }
            return cell
        case 1:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "section2CoworkingCell", for: indexPath) as? Section2CoworkingCell else { return UITableViewCell() }
                cell.delegate = self
                if self.userInfo.cowork {
                    cell.coworkingSwitch.setOn(true, animated: false)
                } else {
                    cell.coworkingSwitch.setOn(false, animated: false)
                }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "section2Cell", for: indexPath) as? Section2Cell else { return UITableViewCell() }
                switch indexPath.row {
                case 1:
                    cell.contentTextField.tag = 0
                    cell.titleLabel.text = "직업"
                    cell.contentTextField.text = self.userInfo.job
                case 2:
                    cell.contentTextField.tag = 1
                    cell.titleLabel.text = "소개말"
                    cell.contentTextField.text = self.userInfo.introducing
                case 3:
                    cell.contentTextField.tag = 2
                    cell.titleLabel.text = "밋업 목적"
                    cell.contentTextField.text = self.userInfo.purpose
                default:
                    break
                }
                return cell
            }
        case 2:
            if self.userInfo.cowork {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "section3Cell", for: indexPath) as? Section3Cell else { return UITableViewCell() }
                cell.titleTextField.tag = 3
                cell.contentTextView.tag = 4
                cell.titleTextField.text = self.emailInfo.title
                cell.contentTextView.text = self.emailInfo.context
                return cell
            } else {
                return tableView.dequeueReusableCell(withIdentifier: "initializeCell", for: indexPath)
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "section3Cell", for: indexPath) as? Section3Cell else { return UITableViewCell() }
            cell.titleTextField.tag = 3
            cell.contentTextView.tag = 4
            cell.titleTextField.text = self.emailInfo.title
            cell.contentTextView.text = self.emailInfo.context
            return cell
        case 3:
            return tableView.dequeueReusableCell(withIdentifier: "initializeCell", for: indexPath)
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return self.userInfo.cowork ? 4 : 1
        case 2: return 1
        case 3: return 1
        default: return 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.userInfo.cowork ? 4 : 3
    }
}

extension MyDetailViewController: UITableViewDelegate {
    //MARK: 프로젝트 등록 화면으로 이동
    func presentInitializeAlert() {
        let alert = UIAlertController(title: "프로젝트 초기화", message: "프로젝트 등록 화면으로 이동합니다.", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "예", style: .default) { (action) in
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let next = storyboard.instantiateViewController(withIdentifier: "EnrollViewController")
            next.modalTransitionStyle = .flipHorizontal
            self.present(next, animated: true, completion: nil)
        }
        let noAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.userInfo.cowork {
            if indexPath.section == 3 {
                presentInitializeAlert()
            }
        } else {
            if indexPath.section == 2 {
                presentInitializeAlert()
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.userInfo.cowork {
            if indexPath.section != 2 { return 50 }
            return 154
        } else {
            return 50
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 18
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 18))
        view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        return view
    }
}

//MARK:- 이미지 피커 관련 델리게이트 구현
extension MyDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        self.profileImageView.image = image.circleMasked
        guard let result = realm.objects(UserInfo.self).last else { return }
        try! realm.write {
            result.image = UIImagePNGRepresentation(image)!
        }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let imageName = "\(uid)\(Int(NSDate.timeIntervalSinceReferenceDate * 1000))"
        let imageReference = Storage.storage().reference().child(imageName)
        imageReference.putData(result.image, metadata: nil) { (metadata, error) in
            if let error = error { print(error.localizedDescription) }
            else {
                imageReference.downloadURL(completion: { (url, _) in
                    guard let url = url else { return }
                    Database.database().reference().child("users").child(uid).updateChildValues([
                        "profileImage": String(describing: url)
                        ])
                })
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
