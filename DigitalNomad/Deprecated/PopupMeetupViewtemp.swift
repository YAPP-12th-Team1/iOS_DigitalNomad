//
//  PopupView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 6..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import MessageUI
import Toaster

class PopupMeetupView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet var button: UIButton!
    @IBOutlet var receiver: UILabel!
    @IBOutlet var sender: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var message: UILabel!
    @IBOutlet var cancelButton: UIButton!
    var realm: Realm!
    var name: String = ""
    var email: String = ""
    
    var 상대방이름: String = ""
    var 내이름: String = ""
    var 이메일제목: String = ""
    var 이메일내용: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        realm = try! Realm()
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowOpacity = 1
        button.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users/\(self.name)").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let nickname = value?["nickname"] as? String ?? ""
            self.email = value?["email"] as? String ?? ""
        })
        //이메일을 비동기로 받아오기 때문에 메일 보내기를 눌렀을 때 받는 사람에 이메일이 누락되는 경우가 있음.
        //일단 토스트 띄우는 걸로 처리하긴 했는데 동기화 가능하면 해주세요.
        receiver.text = 상대방이름
        sender.text = 내이름
        title.text = 이메일제목
        message.text = 이메일내용
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "PopupMeetupView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    
    //////*******************************************************************////////
    @IBAction func sendEmail(_ sender: Any) {
        if(self.email.isEmpty){
            Toast(text: "잠시 후 다시 시도해 주세요.", duration: Delay.short).show()
            return
        }
        ToastCenter.default.cancelAll()
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
//            self.parentViewController()?.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([email])
        mailComposerVC.setSubject("[유목민]Co-working 신청")
        
        let image = UIImage(named:"testImage") // Your Image
        let imageData = UIImagePNGRepresentation(image!) ?? nil
        let base64String = imageData?.base64EncodedString() ?? "" // Your String Image
        let emailBody = "<html><body><p>반가워요! Co-working을 실천하고 싶어서 메일 드렸습니다.</p><p>-이 메일은 유목민 App에서 발송되었습니다.-</p><p><b><img src='data:image/png;base64,\(String(describing: base64String) )'></b></p></body></html>"
        
        mailComposerVC.setMessageBody(emailBody, isHTML:true)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "오류", message: "이메일을 보낼 수 없습니다.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
//        self.parentViewController()?.present(alert, animated: true)
    }
    
    @IBAction func clickCancel(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}

extension PopupMeetupView: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        self.removeFromSuperview()
    }
}

