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
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var activityIndicatorLabel: UILabel!
    
    //MARK:- 프로퍼티
    var realm: Realm!
    var popup: PopupMeetUpView!
    var userInfo: UserInfo?
    var emailInfo: EmailInfo?
    
    //MARK:- 밋업 카드 초기화를 위한 프로퍼티
    var meetupKeys = [String]()
    var meetupData = [(nickname: String, job: String, day: Int, address: String, introducing: String, image: UIImage?)]()
    var emails = [String]()
    
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
        
        //밋업 카드 비동기 작업 시작
        self.activityIndicator.startAnimating()
        self.activityIndicatorLabel.isHidden = false
        self.initializeMeetUpView()
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
    @IBAction func touchUpSettingButton(_ sender: UIButton) {
        guard let next = storyboard?.instantiateViewController(withIdentifier: "MyDetailViewController") as? MyDetailViewController else { return }
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func initializeMeetUpView() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Database.database().reference().child("users").observeSingleEvent(of: .value) { (snapshot) in
            //본인 제외 코워킹 설정 되어 있는 사람의 키값 빼옴
            guard let keys = snapshot.value as? NSDictionary else { return }
            for key in keys {
                guard let newKey = key.key as? String else { return }
                guard let uid = Auth.auth().currentUser?.uid else { return }
                if newKey != uid {
                    guard let newValue = key.value as? NSMutableDictionary else { return }
                    if newValue["cowork"] != nil {
                        self.meetupKeys.append(newKey)
                    }
                }
            }
            for meetupKey in self.meetupKeys {
                Database.database().reference().child("users/\(meetupKey)").observeSingleEvent(of: .value, with: { (snapshot) in
                    OperationQueue().addOperation {
                        guard let value = snapshot.value as? NSDictionary else { return }
                        let nickname = value["nickname"] as? String ?? ""
                        let job = value["job"] as? String ?? ""
                        let day = value["day"] as? Int ?? 0
                        let address = value["address"] as? String ?? ""
                        let introducing = value["introducing"] as? String ?? ""
                        let email = value["email"] as? String ?? ""
                        var image: UIImage? = nil
                        if let profileImageData = value["profileImage"] as? String {
                            guard let imageReference = URL(string: profileImageData) else { return }
                            do {
                                let imageData = try Data(contentsOf: imageReference)
                                image = UIImage(data: imageData)
                            } catch { print(error.localizedDescription) }
                        }
                        self.meetupData.append((nickname: nickname, job: job, day: day, address: address, introducing: introducing, image: image))
                        self.emails.append(email)
                        if meetupKey == self.meetupKeys.last! {
                            OperationQueue.main.addOperation {
                                self.pagerView.reloadData()
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                                self.activityIndicatorLabel.isHidden = true
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            }
                        }
                    }
                })
            }
        }
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
        if !(userInfo?.cowork)! {
            Toast(text: "코워킹 공개를 허용해 주세요.", delay: 0, duration: Delay.short).show()
            return
        }
        let currentIndex = self.pagerView.currentIndex
        guard let cell = pagerView(self.pagerView, cellForItemAt: currentIndex) as? MeetUpCell else { return }
        popup = PopupMeetUpView.instanceFromXib() as? PopupMeetUpView ?? nil
        popup.delegate = self
        popup.receiver = "\(cell.nameLabel.text ?? "") (\(cell.jobLabel.text ?? ""))"
        popup.sender = self.userInfo?.nickname
        popup.title = self.emailInfo?.title
        popup.email = self.emails[currentIndex]
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
    func touchUpSendButton(_ email: String?) {
        removePopup()
        let mailViewController = configureMailComposeViewController(email)
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
    func configureMailComposeViewController(_ email: String?) -> MFMailComposeViewController {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients([email ?? ""])
        mail.setSubject("[유목민] Co-Working 신청")
        let imageData = UIImagePNGRepresentation(#imageLiteral(resourceName: "testImage.png")) ?? nil
        let imageString = imageData?.base64EncodedString() ?? ""
        var body = ""
        if let message = self.emailInfo?.context {
            body += "\(message)\n\n\n"
        }
        body += "<html><body><p>반가워요! Co-working을 실천하고 싶어서 메일 드렸습니다.</p><p>-이 메일은 유목민 App에서 발송되었습니다.-</p><p><b><img src='data:image/png;base64,\(String(describing: imageString) )'></b></p></body></html>"
        mail.setMessageBody(body, isHTML: true)
        return mail
    }
}

//MARK:- 밋업 카드 관련 데이터 소스 구현
extension MyViewController: FSPagerViewDataSource {
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "meetUpCell", at: index) as? MeetUpCell else { return FSPagerViewCell() }
        cell.delegate = self
        let data = self.meetupData[index]
        cell.profileImageView.image = data.image?.circleMasked ?? #imageLiteral(resourceName: "ProfileMeetupNone")
        cell.jobLabel.text = data.job
        cell.nameLabel.text = data.nickname
        cell.daysLabel.text = "\(data.day)일차"
        cell.distanceLabel.text = data.address
        cell.titleLabel.text = "\" \(data.introducing) \""
        return cell
    }
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.meetupData.count
    }
}

//MARK:- 밋업 카드 관련 델리게이트 구현
extension MyViewController: FSPagerViewDelegate {
    
}

//MARK:- 메일 보내기 델리게이트 구현
extension MyViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        self.popup?.removeFromSuperview()
    }
}
