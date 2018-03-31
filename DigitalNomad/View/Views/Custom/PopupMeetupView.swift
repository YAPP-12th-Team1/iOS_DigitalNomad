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

class PopupMeetupView: UIView,  MFMailComposeViewControllerDelegate {
    
    @IBOutlet var view: UIView!
    @IBOutlet var button: UIButton!
    @IBOutlet var receiver: UILabel!
    @IBOutlet var sender: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var message: UILabel!
    @IBOutlet var cancelButton: UIButton!
    var name: String = ""
    var email: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        
        let realm: Realm!
        realm = try! Realm()
        var userInfo: UserInfo!
        var emailInfo: EmailInfo!
        userInfo = realm.objects(UserInfo.self).first!
        emailInfo = realm.objects(EmailInfo.self).first!
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users/\(self.name)").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let nickname = value?["nickname"] as? String ?? ""
            print("name: ", self.name)
            print("nickname: ", nickname)
            self.email = value?["email"] as? String ?? ""
            
            self.sender.text = userInfo.nickname
            self.receiver.text = nickname
            self.title.text = emailInfo.title
            self.message.text = emailInfo.context
        })
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "PopupMeetupView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    
    //////*******************************************************************////////
    @IBAction func sendEmail(_ sender: Any) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.parentViewController()?.present(mailComposeViewController, animated: true, completion: nil)
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
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func clickCancel(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    
}

