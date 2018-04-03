//
//  MyPageDetailImageCell.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 6..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseStorage
import Firebase

class MyPageDetailImageCell: UITableViewCell, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var myImage: UIImageView!
    var realm: Realm!
    var userInfo: UserInfo!
    var imagePicker = UIImagePickerController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        realm = try! Realm()
        userInfo = realm.objects(UserInfo.self).last
        myImage.image = UIImage(data: userInfo.image)
        myImage.layer.borderColor = UIColor.black.cgColor
        myImage.layer.borderWidth = 3
        myImage.layer.masksToBounds = false
        myImage.layer.cornerRadius = myImage.frame.height / 2
        myImage.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func changeMyImage(_ sender: UIButton) {
        if(UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.parentViewController()?.present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            myImage.contentMode = .scaleAspectFit
            myImage.image = pickedImage
            try! realm.write{
                userInfo.image = UIImagePNGRepresentation(pickedImage)!
            }

            let imageName = "\(Int(NSDate.timeIntervalSinceReferenceDate*1000)).jpg"
            let riversRef = Storage.storage().reference().child("user_images").child(Auth.auth().currentUser!.uid).child(imageName)

            riversRef.putData(userInfo.image, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata.downloadURL
            }
            
        }
        self.parentViewController()?.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.parentViewController()?.dismiss(animated: true, completion: nil)
    }
}


