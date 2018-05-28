//
//  ParentViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 13..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class ParentViewController: UIViewController {

    var goalViewController: GoalViewController?
    var wishViewController: WishViewController?
    var realm: Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        self.goalViewController = storyboard?.instantiateViewController(withIdentifier: "GoalViewController") as? GoalViewController
        self.wishViewController = storyboard?.instantiateViewController(withIdentifier: "WishViewController") as? WishViewController
        if UserDefaults.standard.bool(forKey: "isWishViewControllerFirst") {
            switchViewController(from: nil, to: wishViewController)
        } else {
            switchViewController(from: nil, to: goalViewController)
        }
        
        //N일차 파이어베이스 갱신
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).updateChildValues([
            "day": try! Realm().objects(ProjectInfo.self).last?.date.dateInterval ?? 1
            ])
        
        //프로젝트 기한 종료시 알려주기
        noticeProjectEnded()
    }
    
    //MARK: 프로젝트 기한 종료시 알려주기
    func noticeProjectEnded() {
        let projectDay = self.realm.objects(ProjectInfo.self).last?.day ?? 1
        let currentDay = self.realm.objects(ProjectInfo.self).last?.date.dateInterval ?? 1
        if projectDay < currentDay {
            let alert = UIAlertController(title: "프로젝트 종료 알림", message: "프로젝트가 종료되었습니다.", preferredStyle: .alert)
            let initializeAction = UIAlertAction(title: "프로젝트 초기화", style: .default) { (action) in
                let storyboard = UIStoryboard(name: "Start", bundle: nil)
                let next = storyboard.instantiateViewController(withIdentifier: "EnrollViewController")
                next.modalTransitionStyle = .flipHorizontal
                self.present(next, animated: true, completion: nil)
            }
            let noAction = UIAlertAction(title: "계속하기", style: .cancel) { action in
                let alert = UIAlertController(title: "", message: "마이페이지 설정에서 프로젝트를 초기화할 수 있습니다.", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            alert.addAction(initializeAction)
            alert.addAction(noAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: 뷰 컨트롤러 전환
    func switchViewController(from fromVC: UIViewController?, to toVC: UIViewController?) {
        UIView.transition(with: view, duration: 0.4, options: [.curveEaseInOut, .transitionCurlDown], animations: {
            if fromVC != nil {
                fromVC?.willMove(toParentViewController: nil)
                fromVC?.view.removeFromSuperview()
                fromVC?.removeFromParentViewController()
            }
            if toVC != nil {
                self.addChildViewController(toVC!)
                self.view.addSubview(toVC!.view)
                toVC?.didMove(toParentViewController: self)
            }
        }, completion: nil)
        if toVC is GoalViewController {
            self.tabBarController?.tabBar.tintColor = .salmon
        } else {
            self.tabBarController?.tabBar.tintColor = .aquamarine
        }
    }
    
    //MARK: 완료 페이지 여는 조건
    func presentCompleteViewController(){
        let project = realm.objects(ProjectInfo.self).last
        guard let goals = project?.goalLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd]) else { return }
        guard let wishes = project?.wishLists.filter("date BETWEEN %@", [Date.todayStart, Date.todayEnd]) else { return }
        let entireGoals = goals.count
        let entireWishes = wishes.count
        let completedGoals = goals.filter("status = true").count
        let completedWishes = wishes.filter("status = true").count
        if entireGoals != completedGoals || entireWishes != completedWishes { return }
        let completeTime = Date().convertToTime()
        self.goalViewController?.completeTimeLabel?.text = completeTime
        self.wishViewController?.completeTimeLabel?.text = completeTime
        UserDefaults.standard.set(completeTime, forKey: "completeTime")
        guard let completeViewController = storyboard?.instantiateViewController(withIdentifier: "CompleteViewController") else { return }
        completeViewController.modalTransitionStyle = .crossDissolve
        self.present(completeViewController, animated: true, completion: nil)
    }
}
