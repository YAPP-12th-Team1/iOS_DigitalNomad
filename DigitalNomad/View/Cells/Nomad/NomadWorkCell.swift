//
//  NomadLifeWorkCell.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 7..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import BEMCheckBox

class NomadWorkCell: UITableViewCell {

    @IBOutlet var checkBox: BEMCheckBox!
    @IBOutlet var content: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkBox.onAnimationType = .fill
        checkBox.offAnimationType = .fill
        checkBox.onCheckColor = .white
        checkBox.onTintColor = checkBox.tintColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickContent(_ sender: UIButton) {
        let textColor = sender.titleColor(for: .normal)
        if(textColor == .black){
            sender.setTitleColor(.blue, for: .normal)
        } else if(textColor == .blue){
            sender.setTitleColor(.red, for: .normal)
        } else if(textColor == .red){
            sender.setTitleColor(.black, for: .normal)
        }
    }
    
    @IBAction func clickCheckBox(_ sender: BEMCheckBox) {
        let parentViewController = self.parentViewController() as! NomadViewController
        if(sender.on){
            checkBox.applyGradient([UIColor(red: 128/255, green: 184/255, blue: 223/255, alpha: 1), UIColor(red: 178/255, green: 216/255, blue: 197/255, alpha: 1)])
            checkBox.layer.sublayers?.first?.cornerRadius = checkBox.frame.height / 2
            let strikethrough = StrikethroughView.instanceFromXib() as! StrikethroughView
            strikethrough.tag = 100
            content.sizeToFit()
            strikethrough.frame.size = content.frame.size
            content.addSubview(strikethrough)
        } else {
            checkBox.layer.sublayers?.removeFirst()
            content.viewWithTag(100)?.removeFromSuperview()
        }
        reloadContentSummaryValue(controller: parentViewController)
    }
    
    func reloadContentSummaryValue(controller: NomadViewController){
        if(controller.centerView.subviews.first is NomadWorkView){
            let workView = controller.centerView.subviews.first as! NomadWorkView
            let rows = workView.tableView.numberOfRows(inSection: 0)
            let completeRows = { () -> Int in
                var completes = 0
                var row = 0
                while let cell = workView.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? NomadWorkCell {
                    if(cell.checkBox.on){
                        completes += 1
                    }
                    row += 1
                }
                return completes
            }()
            if let underView = controller.underView.subviews.first as? NomadAddView{
                underView.contentSummaryValue.text = "\(completeRows)/\(rows)"
            }
        } else {
            let lifeView = controller.centerView.subviews.first as! NomadLifeView
            let rows = lifeView.collectionView.numberOfItems(inSection: 0) - 1
            let completeRows = { () -> Int in
                var completes = 0
                var row = 0
                while let cell = lifeView.collectionView.cellForItem(at: IndexPath(row: row, section: 0)) as? NomadLifeCell {
                    if(cell.checkBox.on){
                        completes += 1
                    }
                    row += 1
                }
                return completes
            }()
            if let underView = controller.underView.subviews.first as? NomadAddView{
                underView.contentSummaryValue.text = "\(completeRows)/\(rows)"
            }
        }
    }
}
