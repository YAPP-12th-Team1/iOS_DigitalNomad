//
//  NomadLifeViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 6..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import RealmSwift
import Firebase

class NomadViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var centerView: UIView!
    @IBOutlet var labelToday: UILabel!
    @IBOutlet var labelDays: UILabel!
    @IBOutlet var underView: UIView!
    var workView: NomadWorkView! = nil
    var lifeView: NomadLifeView! = nil
    var realm: Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        //더미데이터 쌓는 코드 어느정도 완료되면 아래 줄을 없애자
        let _ = DummyData()
        
        //앱 실행 시 일하는 중인지 삶하는 중인지 구분함
        if(UserDefaults.standard.bool(forKey: "isNomadLifeView")){
            lifeView = NomadLifeView.instanceFromXib() as! NomadLifeView
            lifeView.frame.size = centerView.frame.size
            centerView.addSubview(lifeView)
            
        } else {
            workView = NomadWorkView.instanceFromXib() as! NomadWorkView
            workView.frame.size = centerView.frame.size
            centerView.addSubview(workView)
        }
        labelDays.layer.cornerRadius = 5
        labelDays.applyGradient([#colorLiteral(red: 0.5019607843, green: 0.7215686275, blue: 0.8745098039, alpha: 1), #colorLiteral(red: 0.6980392157, green: 0.8470588235, blue: 0.7725490196, alpha: 1)])
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        leftSwipe.direction = .left
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        rightSwipe.direction = .right
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        upSwipe.direction = .up
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        downSwipe.direction = .down
        centerView.addGestureRecognizer(leftSwipe)
        centerView.addGestureRecognizer(rightSwipe)
        centerView.addGestureRecognizer(upSwipe)
        centerView.addGestureRecognizer(downSwipe)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        let calendar = Calendar(identifier: .gregorian)
        let today = Date()
        let todayFormatter = DateFormatter()
        todayFormatter.locale = Locale(identifier: "ko_KR")
        todayFormatter.dateFormat = "yyyy년 M월 d일 eeee"
        let yesterdayFormatter = DateFormatter()
        yesterdayFormatter.locale = Locale(identifier: "ko_KR")
        yesterdayFormatter.dateFormat = "M/d"
        let yesterday = yesterdayFormatter.string(from: calendar.date(byAdding: DateComponents(day: -1), to: today)!)
        
        labelToday.text = "오늘 \(todayFormatter.string(from: today))"
        labelDays.text = "n일차"
        
        if(underView.layer.sublayers != nil){
            underView.layer.sublayers?.removeFirst()
        }

        if(!underView.subviews.isEmpty){
            underView.subviews.first?.removeFromSuperview()
        }
        
        if(centerView.subviews.last is NomadWorkView) {
            //분홍색 계열 (색A, 일)
            UserDefaults.standard.set(false, forKey: "isNomadLifeView")
            let addView = NomadAddView.instanceFromXib() as! NomadAddView
            addView.frame.size = underView.frame.size
            
            workView = centerView.subviews.last as! NomadWorkView
            
            let refresh = UIRefreshControl()
            workView.tableView.refreshControl = refresh
            refresh.attributedTitle = NSAttributedString(string: "더 당기면 카드형 노트로 전환됩니다")
            refresh.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
            
            searchBar.barTintColor = #colorLiteral(red: 0.9529411765, green: 0.6705882353, blue: 0.6274509804, alpha: 1)
            self.tabBarController?.tabBar.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.6705882353, blue: 0.6274509804, alpha: 1)
            addView.applyGradient([#colorLiteral(red: 0.9843137255, green: 0.9490196078, blue: 0.9450980392, alpha: 1), #colorLiteral(red: 0.9333333333, green: 0.7647058824, blue: 0.7490196078, alpha: 1)])
//            let rows = workView.tableView.numberOfRows(inSection: 0)
//            let completeRows = { () -> Int in
//                var completes = 0
//                var row = 0
//                while let cell = workView.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? NomadWorkCell {
//                    if(cell.checkBox.on){
//                        completes += 1
//                    }
//                    row += 1
//                }
//                return completes
//            }()
            addView.yesterday.text = yesterday
            addView.textField.placeholder = "할 일, #해시태그"
//            if let firstCell = (workView.tableView.cellForRow(at: IndexPath(row: 0, section: 0))) {
//                let realCell = firstCell as! NomadWorkCell
//                if(rows == 1){
//                    addView.contentSummary.text = (realCell.content.titleLabel?.text)!
//                } else {
//                    addView.contentSummary.text = "\((realCell.content.titleLabel?.text)!) 외 \(rows-1)개"
//                }
//            } else {
//                addView.contentSummary.text = "추가해주세요."
//            }
            if(!UserDefaults.standard.bool(forKey: "isFirstNomadWorkExecute")){
                if(self.view.subviews.last is NomadWorkTutorialView){
                    self.view.subviews.last?.removeFromSuperview()
                }
                let tutorial = NomadWorkTutorialView.instanceFromXib()
                tutorial.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                tutorial.frame = self.view.frame
                self.view.addSubview(tutorial)
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.underView.frame.origin.y = self.view.frame.height - 49 - self.underView.frame.height
            })
            underView.addSubview(addView)
        } else {
            //보라색 계열 (색B, 삶)
            UserDefaults.standard.set(true, forKey: "isNomadLifeView")
            let addView = NomadAddView.instanceFromXib() as! NomadAddView
            addView.frame.size = underView.frame.size
            
            lifeView = centerView.subviews.last as! NomadLifeView
            
            let refresh = UIRefreshControl()
            refresh.attributedTitle = NSAttributedString(string: "더 당기면 리스트형 노트로 전환됩니다")
            refresh.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
            lifeView.collectionView.refreshControl = refresh
            
            searchBar.barTintColor = #colorLiteral(red: 0.7607843137, green: 0.7333333333, blue: 0.8235294118, alpha: 1)
            self.tabBarController?.tabBar.backgroundColor = #colorLiteral(red: 0.7607843137, green: 0.7333333333, blue: 0.8235294118, alpha: 1)
            addView.applyGradient([#colorLiteral(red: 0.9843137255, green: 0.9568627451, blue: 0.9529411765, alpha: 1), #colorLiteral(red: 0.7882352941, green: 0.7647058824, blue: 0.8431372549, alpha: 1)])
//            let rows = lifeView.collectionView.numberOfItems(inSection: 0) - 1
//            let completeRows = { () -> Int in
//                var completes = 0
//                var row = 0
//                while let cell = lifeView.collectionView.cellForItem(at: IndexPath(item: row, section: 0)) as? NomadLifeCell {
//                    if(cell.checkBox.on){
//                        completes += 1
//                    }
//                    row += 1
//                }
//                return completes
//            }()
            addView.yesterday.text = yesterday
            addView.textField.placeholder = "하고 싶은 카드를 추가해보세요"
//            if let firstContent = (lifeView.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as! NomadLifeCell).content.text {
//                addView.contentSummary.text = "\(firstContent) 외 \(rows-1)개"
//            }
            if(!UserDefaults.standard.bool(forKey: "isFirstNomadLifeExecute")){
                if(self.view.subviews.last is NomadLifeTutorialView){
                    self.view.subviews.last?.removeFromSuperview()
                }
                let tutorial = NomadLifeTutorialView.instanceFromXib()
                tutorial.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                tutorial.frame = self.view.frame
                self.view.addSubview(tutorial)
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.underView.frame.origin.y = self.view.frame.height - (self.tabBarController?.tabBar.frame.height)! - (self.underView.frame.height - addView.subView.frame.height)
            })
            underView.addSubview(addView)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func refresh(){
        if(centerView.subviews.last is NomadWorkView){
            centerView.subviews.last?.removeFromSuperview()
            let lifeView = NomadLifeView.instanceFromXib() as! NomadLifeView
            lifeView.frame.size = centerView.frame.size
            centerView.addSubview(lifeView)
            lifeView.layoutIfNeeded()
        } else {
            centerView.subviews.last?.removeFromSuperview()
            let workView = NomadWorkView.instanceFromXib() as! NomadWorkView
            workView.frame.size = centerView.frame.size
            centerView.addSubview(workView)
        }
        viewWillAppear(true)
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer){
        if(searchBar.isFirstResponder || (underView.subviews.last! as! NomadAddView).textField.isFirstResponder){
            return
        }
        let animation = CATransition()
        animation.duration = 0.5
        animation.type = kCATransitionPush
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        if(gesture.direction == .left){
            animation.subtype = kCATransitionFromRight
            centerView.layer.add(animation, forKey: "swipeLeft")
        } else if(gesture.direction == .right){
            animation.subtype = kCATransitionFromLeft
            centerView.layer.add(animation, forKey: "swipeUp")
        } else if(gesture.direction == .up){
            animation.subtype = kCATransitionFromTop
            centerView.layer.add(animation, forKey: "swipeDown")
        } else if(gesture.direction == .down){
            animation.subtype = kCATransitionFromBottom
            centerView.layer.add(animation, forKey: "swipeRight")
        }
        if(centerView.subviews.last is NomadWorkView){
            centerView.subviews.last?.removeFromSuperview()
            let lifeView = NomadLifeView.instanceFromXib() as! NomadLifeView
            lifeView.frame.size = centerView.frame.size
            centerView.addSubview(lifeView)
            lifeView.layoutIfNeeded()
        } else {
            centerView.subviews.last?.removeFromSuperview()
            let workView = NomadWorkView.instanceFromXib() as! NomadWorkView
            workView.frame.size = centerView.frame.size
            centerView.addSubview(workView)
        }
        viewWillAppear(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        if(searchBar.isFirstResponder){
            return
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height - (self.tabBarController?.tabBar.frame.height)!)
            }
            if(centerView.subviews.last is NomadLifeView){
                let addView = underView.subviews.last as! NomadAddView
                underView.frame.origin.y -= addView.subView.frame.height
            }
        }
    }
    @objc func keyboardWillHide(_ notification: Notification){
        if(searchBar.isFirstResponder){
            return
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += (keyboardSize.height - (self.tabBarController?.tabBar.frame.height)!)
            }
            if(centerView.subviews.last is NomadLifeView){
                let addView = underView.subviews.last as! NomadAddView
                underView.frame.origin.y += addView.subView.frame.height
            }
        }
    }
}

extension NomadViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(centerView.subviews.last is NomadWorkView){
            let workView = centerView.subviews.last as! NomadWorkView
            if(!searchText.isEmpty){
                let temps = realm.objects(ProjectInfo.self).last!.goalLists.filter("todo CONTAINS[c] '" + searchText + "'")
                let result = List<GoalListInfo>()
                for temp in temps{
                    result.append(temp)
                }
                workView.object = result
            } else {
                workView.object = realm.objects(ProjectInfo.self).last!.goalLists
            }
            workView.tableView.reloadData()
        } else {
//            let lifeView = centerView.subviews.last as! NomadLifeView
//            lifeView.object = realm.objects(ProjectInfo.self).last!.wishLists.filter("todo CONTAINS[c] '" + searchText + "'")
//            lifeView.collectionView.reloadData()
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        return
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

