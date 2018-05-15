//
//  GoalCell.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 13..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import BEMCheckBox
import SwipeCellKit

protocol GoalCellDelegate {
    func touchUpCheckBox(_ sender: BEMCheckBox, todo: UIButton)
    func touchUpTodoButton(_ sender: UIButton)
}

class GoalCell: SwipeTableViewCell {

    var goalCellDelegate: GoalCellDelegate?
    @IBOutlet var checkBox: BEMCheckBox!
    @IBOutlet var todoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.checkBox.onAnimationType = .fill
        self.checkBox.offAnimationType = .fill
    }
    
    //GoalViewController에 구현체 있음
    @IBAction func clickCheckBox(_ sender: BEMCheckBox) {
        goalCellDelegate?.touchUpCheckBox(sender, todo: self.todoButton)
    }
    
    //GoalViewController에 구현체 있음
    @IBAction func clickTodoButton(_ sender: UIButton) {
        goalCellDelegate?.touchUpTodoButton(sender)
    }
}
