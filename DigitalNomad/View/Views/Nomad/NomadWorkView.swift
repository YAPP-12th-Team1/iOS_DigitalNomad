//
//  NomadWorkView.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 7..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import RealmSwift

class NomadWorkView: UIView {

    @IBOutlet var tableView: UITableView!
    var realm: Realm!
    var object: Results<GoalListInfo>!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        realm = try! Realm()
        object = realm.objects(ProjectInfo.self).last!.goalLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd])
        tableView.register(UINib(nibName: "NomadWorkCell", bundle: nil), forCellReuseIdentifier: "nomadWorkCell")
    }
    
    class func instanceFromXib() -> UIView {
        return UINib(nibName: "NomadWorkView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
}

extension NomadWorkView: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nomadWorkCell") as! NomadWorkCell
        let result = object[indexPath.row]
        cell.content.setTitle(result.todo, for: .normal)
        cell.content.sizeToFit()
        cell.content.tag = result.id
        cell.checkBox.tag = result.id
        switch(result.importance){
        case 0:
            cell.content.setTitleColor(.black, for: .normal)
        case 1:
            cell.content.setTitleColor(.blue, for: .normal)
        case 2:
            cell.content.setTitleColor(.red, for: .normal)
        default:
            break
        }
        if(cell.checkBox.layer.sublayers?.count == 4){
            cell.checkBox.layer.sublayers?.removeFirst()
            cell.content.viewWithTag(100)?.removeFromSuperview()
        }
        if(result.status){
            //체크박스 체크되어있게
            cell.checkBox.setOn(true, animated: false)
            cell.checkBox.applyGradient([#colorLiteral(red: 0.5019607843, green: 0.7215686275, blue: 0.8745098039, alpha: 1), #colorLiteral(red: 0.6980392157, green: 0.8470588235, blue: 0.7725490196, alpha: 1)])
            cell.checkBox.layer.sublayers?.first?.cornerRadius = cell.checkBox.frame.height / 2
            let strikethrough = StrikethroughView.instanceFromXib() as! StrikethroughView
            strikethrough.tag = 100
            cell.content.sizeToFit()
            strikethrough.frame.size = cell.content.frame.size
            cell.content.addSubview(strikethrough)
        } else {
            //체크박스 체크 안되어있게
            cell.checkBox.setOn(false, animated: false)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return object.count
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let result = object[indexPath.row]
        let delete = UITableViewRowAction(style: .destructive, title: "삭제") { action, index in
            try! self.realm.write{
                self.realm.delete(result)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.openFinalPage()
        }
        let postpone = UITableViewRowAction(style: .normal, title: "미루기") { (action, index) in
            let id = result.id
            let query = NSPredicate(format: "id = %d", id)
            let postponeCell = self.object.filter(query).first!
            let tomorrow = Date.tomorrowDate
            try! self.realm.write{
                postponeCell.date = tomorrow
            }
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.top)
            self.openFinalPage()
        }
        if(result.status) {
            return [delete]
        } else {
            return [delete, postpone]
        }
    
    }
    
    func openFinalPage(){
        let project = realm.objects(ProjectInfo.self).last
        guard let goals = project?.goalLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd]) else { return }
        guard let wishes = project?.wishLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd]) else { return }
        let countOfGoals = goals.count
        let countOfWishes = wishes.count
        let completedGoals = goals.filter("status = true").count
        let completedWishes = wishes.filter("status = true").count
        if(countOfGoals != completedGoals || countOfWishes != completedWishes) { return }
        let addView = (self.parentViewController() as! NomadViewController).underView.subviews.last as! NomadAddView
        addView.endTime.text = Date().convertToTime()
        UserDefaults.standard.set(Date().convertToTime(), forKey: "timeOfFinalPageOpened")
        let finalView = NomadFinalView.instanceFromXib()
        finalView.alpha = 0
        self.parentViewController()?.view.addSubview(finalView)
        UIView.animate(withDuration: 0.5, animations: {
            finalView.alpha = 1
        })
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
        let parent = self.parentViewController() as! NomadViewController
        if(parent.searchBar.isFirstResponder) {
            return NSAttributedString(string: "검색 결과가 없습니다.")
        } else {
            return NSAttributedString(string: "목표를 추가하세요.")
        }
        
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
