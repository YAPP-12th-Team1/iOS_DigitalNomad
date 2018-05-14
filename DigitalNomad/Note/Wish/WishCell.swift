//
//  WishCell.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 13..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import BEMCheckBox

protocol WishCellDelegate {
    func touchUpCheckBox()
}

class WishCell: UICollectionViewCell {
    
    
    @IBOutlet var todoImageView: UIImageView!
    @IBOutlet var todoLabel: UILabel!
    @IBOutlet var checkBox: BEMCheckBox!
    var delegate: WishCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.checkBox.onAnimationType = .fill
        self.checkBox.offAnimationType = .fill
    }
    
    //WishViewController에 구현체 있음
    @IBAction func touchUpCheckBox(_ sender: BEMCheckBox) {
        delegate?.touchUpCheckBox()
    }
}
