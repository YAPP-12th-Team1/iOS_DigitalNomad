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
            "day": try! Realm().objects(ProjectInfo.self).last?.date.dateInterval
            ])
    }
    
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
        self.goalViewController?.completeTimeLabel.text = completeTime
        self.wishViewController?.completeTimeLabel.text = completeTime
        UserDefaults.standard.set(completeTime, forKey: "completeTime")
        guard let completeViewController = storyboard?.instantiateViewController(withIdentifier: "CompleteViewController") else { return }
        completeViewController.modalTransitionStyle = .crossDissolve
        self.present(completeViewController, animated: true, completion: nil)
    }
}
