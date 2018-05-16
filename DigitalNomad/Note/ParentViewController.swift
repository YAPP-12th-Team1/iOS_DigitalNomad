//
//  ParentViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 13..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {

    var goalViewController: GoalViewController?
    var wishViewController: WishViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.goalViewController = storyboard?.instantiateViewController(withIdentifier: "GoalViewController") as? GoalViewController
        self.wishViewController = storyboard?.instantiateViewController(withIdentifier: "WishViewController") as? WishViewController
        if UserDefaults.standard.bool(forKey: "isWishViewControllerFirst") {
            switchViewController(from: nil, to: wishViewController)
        } else {
            switchViewController(from: nil, to: goalViewController)
        }
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
}
