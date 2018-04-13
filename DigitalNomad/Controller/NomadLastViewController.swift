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
    let isNomadLifeView = UserDefaults.standard.bool(forKey: "isNomadLifeView")
    var enrolledDate: Date!
    let dateFormatter = DateFormatter()
    var dateCount = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        enrolledDate = realm.objects(ProjectInfo.self).last!.date
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        if(isNomadLifeView) {
            wishes = realm.objects(ProjectInfo.self).last!.wishLists.filter("date < %@", Date.todayStart).sorted(byKeyPath: "date")
            var count = 0
            var tempDate = ""
            var isFirst = true
            for wish in wishes{
                let date = dateFormatter.string(from: wish.date)
                if(tempDate != date){
                    tempDate = date
                    if(isFirst){
                        isFirst = false
                    } else {
                        dateCount.append(count)
                        count = 0
                    }
                }
                count += 1
            }
            dateCount.append(count)
            
        } else {
            goals = realm.objects(ProjectInfo.self).last!.goalLists.filter("date < %@", Date.todayStart).sorted(byKeyPath: "date")
            var count = 0
            var tempDate = ""
            var isFirst = true
            for goal in goals{
                let date = dateFormatter.string(from: goal.date)
                if(tempDate != date){
                    tempDate = date
                    if(isFirst){
                        isFirst = false
                    } else {
                        dateCount.append(count)
                        count = 0
                    }
                }
                count += 1
            }
            dateCount.append(count)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func clickPrevious(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension NomadLastViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nomadLastCell")!
        var rowIndex = 0
        if(indexPath.section > 0){
            for i in 1...indexPath.section {
                rowIndex += dateCount[i-1]
            }
        }
        rowIndex += indexPath.row
        if(isNomadLifeView){
            let object = wishes[rowIndex]
            let pictureIndex = object.pictureIndex
            cell.imageView?.image = pictureIndex == -1 ? UIImage() : UIImage(named: "wish\(pictureIndex)")
            cell.textLabel?.text = object.todo
        } else {
            let object = goals[rowIndex]
            cell.textLabel?.text = object.todo
        }
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var index = 0
        for i in 0...section{
            index += dateCount[i]
        }
        if(isNomadLifeView){
            return dateFormatter.string(from: wishes[index-1].date)
        } else {
            return dateFormatter.string(from: goals[index-1].date)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return dateCount.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateCount[section]
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
