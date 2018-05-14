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
    func clickCheckBox(_ sender: BEMCheckBox, todo: UIButton)
    func clickTodoButton(_ sender: UIButton)
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func clickCheckBox(_ sender: BEMCheckBox) {
        goalCellDelegate?.clickCheckBox(sender, todo: self.todoButton)
    }
    
    @IBAction func clickTodoButton(_ sender: UIButton) {
        goalCellDelegate?.clickTodoButton(sender)
    }
}
