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

    @IBOutlet var tableView: UITableView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    var realm: Realm!
    var userInfo: UserInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        
        //UI 초기화
        self.userInfo = realm.objects(UserInfo.self).last
        self.nameLabel.text = self.userInfo.nickname
        self.profileImageView.image = (self.navigationController?.viewControllers.first as? MyViewController)?.profileImageView.image
        
        //제스처 등록
        self.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchUpProfileImageView(_:))))
    }
    
    @objc func touchUpProfileImageView(_ gesture: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = .photoLibrary
            controller.allowsEditing = true
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func touchUpBackButton(_ sender: UIButton) {
        guard let previousViewController = self.navigationController?.viewControllers.first as? MyViewController else { return }
        previousViewController.profileImageView.image = self.profileImageView.image
        self.navigationController?.popViewController(animated: true)
    }
    
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
}

//코워킹 셀 커스텀 델리게이트 구현
extension MyDetailViewController: Section2CoworkingCellDelegate {
    func changeCoworkingSwitchValue() {
        
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
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "section2Cell", for: indexPath) as? Section2Cell else { return UITableViewCell() }
                return cell
            }
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "section3Cell", for: indexPath) as? Section3Cell else { return UITableViewCell() }
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 4
        case 2:
            return 1
        default:
            return 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
}

extension MyDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != 2 {
            return 50
        }
        return 154
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 18
    }
}

//MARK:- 이미지 피커 관련 델리게이특 ㅜ현
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
                if let downloadURL = metadata?.downloadURL() {
                    Database.database().reference().child("users").child(uid).updateChildValues([
                        "profileImage": String(describing: downloadURL)
                        ])
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
