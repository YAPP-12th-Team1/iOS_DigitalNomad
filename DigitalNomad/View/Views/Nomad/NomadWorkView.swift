//
//  NomadWorkView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 7..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class NomadWorkView: UIView {

    @IBOutlet var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.register(UINib(nibName: "NomadWorkCell", bundle: nil), forCellReuseIdentifier: "nomadWorkCell")
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "NomadWorkView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
}

extension NomadWorkView: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nomadWorkCell") as! NomadWorkCell
        //더미데이터
        switch(indexPath.row){
        case 0:
            cell.content.setTitle("이메일 수신확인", for: .normal)
        case 1:
            cell.content.setTitle("#계약 계약금 입금 확인", for: .normal)
        case 2:
            cell.content.setTitle("노마드 #칼럼 (디지털조선) 전송", for: .normal)
        default:
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //realmResults의 count
        return 3
    }
}
extension NomadWorkView: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NomadWorkView: DZNEmptyDataSetSource{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return nil
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return nil
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return nil
    }
}
extension NomadWorkView: DZNEmptyDataSetDelegate{
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
}
