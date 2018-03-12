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

class NomadViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var centerView: UIView!
    @IBOutlet var labelToday: UILabel!
    @IBOutlet var labelDays: UILabel!
    @IBOutlet var underView: NomadAddView!
    var workView: NomadWorkView! = nil
    var lifeView: NomadLifeView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //아래 두 카테고리 중 한 부분만 실행해야 한다.
        
//        일 관련일 때는 테이블뷰
//        workView = NomadWorkView.instanceFromXib() as! NomadWorkView
//        workView.frame.size = centerView.frame.size
//        centerView.addSubview(workView)
        
        //삶 관련일 때는 컬렉션뷰
        lifeView = NomadLifeView.instanceFromXib() as! NomadLifeView
        lifeView.frame.size = centerView.frame.size
        centerView.addSubview(lifeView)
        
        labelDays.layer.cornerRadius = 5
        labelDays.applyGradient([#colorLiteral(red: 0.5019607843, green: 0.7215686275, blue: 0.8745098039, alpha: 1), #colorLiteral(red: 0.6980392157, green: 0.8470588235, blue: 0.7725490196, alpha: 1)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        if(underView.layer.sublayers != nil){
            underView.layer.sublayers?.removeFirst()
        }
        if(!underView.subviews.isEmpty){
            underView.subviews.first?.removeFromSuperview()
        }
        let view = NomadAddView.instanceFromXib() as! NomadAddView
        view.frame.size = underView.frame.size
        
        
        
        if(centerView.subviews.last is NomadWorkView) {
            //분홍색 계열 (색A, 일)
            workView = centerView.subviews.last as! NomadWorkView
            searchBar.barTintColor = #colorLiteral(red: 0.9529411765, green: 0.6705882353, blue: 0.6274509804, alpha: 1)
            self.tabBarController?.tabBar.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.6705882353, blue: 0.6274509804, alpha: 1)
            view.applyGradient([#colorLiteral(red: 0.9843137255, green: 0.9490196078, blue: 0.9450980392, alpha: 1), #colorLiteral(red: 0.9333333333, green: 0.7647058824, blue: 0.7490196078, alpha: 1)])
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
            view.contentSummaryValue.text = "\(completeRows)/\(rows)"
            view.textField.placeholder = "할 일, #해시태그"
            if let firstContent = (workView.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! NomadWorkCell).content.titleLabel?.text {
                view.contentSummary.text = "\(firstContent) 외 \(rows-1)개"
            }
            //튜토리얼 스크린 디버깅용
//            UserDefaults.standard.set(false, forKey: "isFirstNomadWorkExecute")
            if(!UserDefaults.standard.bool(forKey: "isFirstNomadWorkExecute")){
                let tutorial = NomadWorkTutorialView.instanceFromXib()
                tutorial.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                tutorial.frame = self.view.frame
                self.view.addSubview(tutorial)
                UserDefaults.standard.set(true, forKey: "isFirstNomadWorkExecute")
            }
        } else {
            //보라색 계열 (색B, 삶)
            lifeView = centerView.subviews.last as! NomadLifeView
            searchBar.barTintColor = #colorLiteral(red: 0.7607843137, green: 0.7333333333, blue: 0.8235294118, alpha: 1)
            self.tabBarController?.tabBar.backgroundColor = #colorLiteral(red: 0.7607843137, green: 0.7333333333, blue: 0.8235294118, alpha: 1)
            view.applyGradient([#colorLiteral(red: 0.9843137255, green: 0.9568627451, blue: 0.9529411765, alpha: 1), #colorLiteral(red: 0.7882352941, green: 0.7647058824, blue: 0.8431372549, alpha: 1)])
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
            view.contentSummaryValue.text = "\(completeRows)/\(rows)"
            view.textField.placeholder = "하고 싶은 카드를 추가해보세요"
            if let firstContent = (lifeView.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as! NomadLifeCell).content.text {
                view.contentSummary.text = "\(firstContent) 외 \(rows-1)개"
            }
            //튜토리얼 스크린 디버깅용
//            UserDefaults.standard.set(false, forKey: "isFirstNomadLifeExecute")
            if(!UserDefaults.standard.bool(forKey: "isFirstNomadLifeExecute")){
                let tutorial = NomadLifeTutorialView.instanceFromXib()
                tutorial.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                tutorial.frame = self.view.frame
                self.view.addSubview(tutorial)
                UserDefaults.standard.set(true, forKey: "isFirstNomadLifeExecute")
            }
        }
        underView.addSubview(view)
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년 M월 d일 eeee"
        labelToday.text = "오늘 \(dateFormatter.string(from: today))"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if(self.view.subviews.last is NomadWorkTutorialView || self.view.subviews.last is NomadLifeTutorialView){
            self.view.subviews.last?.removeFromSuperview()
        }
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        if(searchBar.isFirstResponder){
            return
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height - 49)
            }
        }
    }
    @objc func keyboardWillHide(_ notification: Notification){
        if(searchBar.isFirstResponder){
            return
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += (keyboardSize.height - 49)
            }
        }
    }
}

extension NomadViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        return
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

