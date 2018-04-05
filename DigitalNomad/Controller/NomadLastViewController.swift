//
//  NomadLastViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 4. 6..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import RealmSwift
import DZNEmptyDataSet

/*
 여기로 넘어오기 전에 Goal인지 Wish인지 구분해서 뿌려줄 데이터를 구분할 필요가 있음
 -> UserDefaults.standard.bool(forKey: "isNomadLifeView")를 활용하자
 
 일단 이전 화면으로 돌아가는 버튼 하나 놔뒀고, 테이블뷰 셀 스타일은 기본으로 해놓음
 
 Date를 String으로 저장해놔서 데이터를 필터링하는게 좀 힘들긴 할듯
 위의 알고리즘만 좀 생각해서 대충 뿌려지는거 확인한 다음에 디자인 나오고 다시 작업하면 될듯
 */

class NomadLastViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var realm: Realm!
    var goals: Results<GoalListInfo>!
    var wishes: Results<WishListInfo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //realm = try! Realm()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickPrevious(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension NomadLastViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nomadLastCell")!
        cell.textLabel?.text = "\(indexPath.section) + \(indexPath.row)"
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "날짜?"
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}
extension NomadLastViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NomadLastViewController: DZNEmptyDataSetSource{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return nil
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "표시할 내용이 없습니다.")
        
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return nil
    }
}
extension NomadLastViewController: DZNEmptyDataSetDelegate{
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
}
