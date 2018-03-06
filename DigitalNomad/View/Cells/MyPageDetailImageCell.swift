//
//  MyPageDetailImageCell.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 6..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class MyPageDetailImageCell: UITableViewCell {

    @IBOutlet var myImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
    }
}

