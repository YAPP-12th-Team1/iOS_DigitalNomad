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

class MyViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
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
        
        //해시태그 컬렉션 뷰 프로퍼티 설정
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: 10, height: 50)
        self.collectionView.collectionViewLayout = flowLayout
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
    }
    
    //MARK:- 사용자 정의 메소드
    @IBAction func touchUpSettingButton(_ sender: UIButton) {
        guard let next = storyboard?.instantiateViewController(withIdentifier: "MyDetailViewController") as? MyDetailViewController else { return }
        self.navigationController?.pushViewController(next, animated: true)
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

//MARK:- 컬렉션 뷰 데이터 소스 구현
extension MyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hashtagCell", for: indexPath) as? MyHashtagCell else { return UICollectionViewCell() }
        cell.hashtagLabel.text = "# 해시태애그"
        cell.hashtagLabel.frame.size.height = cell.frame.height
        cell.hashtagLabel.frame.size.width += 20
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
}

//MARK:- 컬렉션 뷰 델리게이트 구현
extension MyViewController: UICollectionViewDelegate {
    
}

//MARK:- 컬렉션 뷰 델리게이트 플로우 레이아웃 구현
extension MyViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        guard let label = (collectionView.cellForItem(at: indexPath) as! MyHashtagCell).hashtagLabel else { return .zero }
//        return label.frame.size
//    }
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

//MARK:- 메일 보내기 델리게이트 구현
extension MyViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        self.popup?.removeFromSuperview()
    }
}
