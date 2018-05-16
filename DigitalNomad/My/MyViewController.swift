//
//  MyViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 14..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import FSPagerView
import RealmSwift
import Firebase
import SDWebImage
import Toaster
import MessageUI
import Tags

class MyViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet var hashtagView: TagsView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(UINib(nibName: "MeetUpCell", bundle: nil), forCellWithReuseIdentifier: "meetUpCell")
        }
    }
    @IBOutlet var listLabel: UILabel!
    @IBOutlet var cardLabel: UILabel!
    
    //MARK:- 프로퍼티
    var realm: Realm!
    var popup: PopupMeetUpView!
    var userInfo: UserInfo?
    var emailInfo: EmailInfo?
    
    //MARK:- 기본 메소드
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        self.userInfo = realm.objects(UserInfo.self).last ?? nil
        self.emailInfo = realm.objects(EmailInfo.self).last ?? nil
        
        //밋업 카드 관련 초기화
        self.pagerView.itemSize = CGSize(width: 276, height: 250)
        self.pagerView.transformer = FSPagerViewTransformer(type: .linear)
        
        //해시태그 뷰 초기화
        self.hashtagView.tagFont = UIFont.systemFont(ofSize: 13, weight: .medium)
        self.hashtagView.lineBreakMode = .byTruncatingTail
        
        //프로필 이미지 뷰 초기화
        self.profileImageView.image = UIImage(data: (realm.objects(UserInfo.self).last?.image)!)?.circleMasked
        self.profileImageView.layer.shadowColor = UIColor.black.cgColor
        self.profileImageView.layer.shadowRadius = 3
        self.profileImageView.layer.shadowOffset = .zero
        self.profileImageView.layer.shadowOpacity = 1
        
        //제스쳐 등록
        self.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchUpProfileImageView(_:))))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //MARK: 리스트, 카드, 해시태그 라벨 초기화
        self.listLabel.text = {
            guard let objects = self.realm.objects(ProjectInfo.self).last?.goalLists else { return nil }
            let entire = objects.count
            let complete = objects.filter("status = true").count
            return "\(complete)/\(entire)"
        }()
        self.cardLabel.text = {
            guard let objects = self.realm.objects(ProjectInfo.self).last?.wishLists else { return nil }
            let entire = objects.count
            let complete = objects.filter("status = true").count
            return "\(complete)/\(entire)"
        }()
        self.initializeHashtag()
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
    
    @IBAction func touchUpSettingButton(_ sender: UIButton) {
        guard let next = storyboard?.instantiateViewController(withIdentifier: "MyDetailViewController") as? MyDetailViewController else { return }
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func initializeHashtag() {
        self.hashtagView.removeAll()
        guard let goalLists = realm.objects(ProjectInfo.self).last?.goalLists.filter("todo contains '#'") else { return }
        var hashtagDict = [String: Int]()
        for goalList in goalLists {
            let todo = goalList.todo
            if todo[todo.startIndex] != "#" { continue }
            guard let frequency = todo.components(separatedBy: " ").first else { return }
            if let number = hashtagDict[frequency] {
                hashtagDict[frequency] = number + 1
            } else {
                hashtagDict[frequency] = 0
            }
        }
        let sortedArray = hashtagDict.sorted { $0.1 > $1.1 }
        var count = 0
        for element in sortedArray {
            self.hashtagView.append(element.key)
            count += 1
            if count == 3 { break }
        }
    }
}

//MARK:- 밋업 셀 커스텀 델리게이트 구현
extension MyViewController: MeetUpCellDelegate {
    func touchUpMeetupButton() {
        let currentIndex = self.pagerView.currentIndex
        guard let cell = pagerView(self.pagerView, cellForItemAt: currentIndex) as? MeetUpCell else { return }
        popup = PopupMeetUpView.instanceFromXib() as? PopupMeetUpView ?? nil
        popup.delegate = self
        popup.receiver = "\(cell.nameLabel.text ?? "") (\(cell.jobLabel.text ?? ""))"
        popup.sender = self.userInfo?.nickname
        popup.title = self.emailInfo?.title
        popup.layoutSubviews()
        popup.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        popup.frame = self.view.bounds
        self.view.addSubview(popup)
        popup.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.popup.alpha = 1
        }
    }
}

//MARK:- 밋업 팝업 뷰 커스텀 델리게이트 구현
extension MyViewController: PopupMeetUpViewDelegate {
    func touchUpSendButton() {
        removePopup()
        let mailViewController = configureMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailViewController, animated: true, completion: nil)
        } else {
            Toast(text: "이메일읇 보낼 수 없습니다.", delay: 0, duration: Delay.short).show()
        }
    }
    func touchUpCancelButton() {
        removePopup()
    }
    func removePopup() {
        UIView.animate(withDuration: 0.3, animations: {
            self.popup.alpha = 0
        }) { _ in
            self.popup.removeFromSuperview()
        }
    }
    func configureMailComposeViewController() -> MFMailComposeViewController {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        let imageData = UIImagePNGRepresentation(#imageLiteral(resourceName: "testImage.png")) ?? nil
        let imageString = imageData?.base64EncodedString() ?? ""
        let body = "<html><body><p>반가워요! Co-working을 실천하고 싶어서 메일 드렸습니다.</p><p>-이 메일은 유목민 App에서 발송되었습니다.-</p><p><b><img src='data:image/png;base64,\(String(describing: imageString) )'></b></p></body></html>"
        mail.setMessageBody(body, isHTML: true)
        return mail
    }
}

//MARK:- 밋업 카드 관련 데이터 소스 구현
extension MyViewController: FSPagerViewDataSource {
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "meetUpCell", at: index) as? MeetUpCell else { return FSPagerViewCell() }
        cell.delegate = self
        return cell
    }
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 1
    }
}

//MARK:- 밋업 카드 관련 델리게이트 구현
extension MyViewController: FSPagerViewDelegate {
    
}

//MARK:- 이미지 피커 컨트롤러 델리게이트 구현
extension MyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

//MARK:- 메일 보내기 델리게이트 구현
extension MyViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        self.popup?.removeFromSuperview()
    }
}
