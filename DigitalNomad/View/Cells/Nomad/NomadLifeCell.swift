//
//  NomadLifeCell.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 7..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import BEMCheckBox

class NomadLifeCell: UICollectionViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var content: UILabel!
    @IBOutlet var checkBox: BEMCheckBox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkBox.onAnimationType = .fill
        checkBox.offAnimationType = .fill
        checkBox.onCheckColor = .white
        checkBox.onTintColor = checkBox.tintColor
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 1
        // Initialization code
    }

    @IBAction func clickCheckBox(_ sender: BEMCheckBox) {
        let parentViewController = self.parentViewController() as! NomadViewController
        if(sender.on){
            checkBox.applyGradient([#colorLiteral(red: 0.5019607843, green: 0.7215686275, blue: 0.8745098039, alpha: 1), #colorLiteral(red: 0.6980392157, green: 0.8470588235, blue: 0.7725490196, alpha: 1)])
            checkBox.layer.sublayers?.first?.cornerRadius = checkBox.frame.height / 2
            
        } else {
            checkBox.layer.sublayers?.removeFirst()
        }
        let isFinished = reloadContentSummaryValue(controller: parentViewController)
        if(isFinished){
            //변경 화면
            let parentViewController = self.parentViewController() as! NomadViewController
            let changeView = NomadChangeView.instanceFromXib()
            changeView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            changeView.frame = parentViewController.view.frame
            parentViewController.view.addSubview(changeView)
        }
    }
    
    func reloadContentSummaryValue(controller: NomadViewController) -> Bool{
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
            return rows == completeRows
        } else {
            let lifeView = controller.centerView.subviews.first as! NomadLifeView
            let rows = lifeView.collectionView.numberOfItems(inSection: 0) - 1
            let completeRows = { () -> Int in
                var completes = 0
                var row = 0
                while let cell = lifeView.collectionView.cellForItem(at: IndexPath(item: row, section: 0)) as? NomadLifeCell {
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
            return rows == completeRows
        }
    }
}
