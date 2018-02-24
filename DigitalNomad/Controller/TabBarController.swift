//
//  TabBarController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 2. 24..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let tabOne  = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        let tabOneBarItem = UITabBarItem(title: "지도", image: UIImage(), tag: 0)
        tabOne.tabBarItem = tabOneBarItem
        
        let tabTwo = UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "ScheduleViewController") as! ScheduleViewController
        let tabTwoBarItem = UITabBarItem(title: "일정", image: UIImage(), tag: 1)
        tabTwo.tabBarItem = tabTwoBarItem
        
        let tabThree = UIStoryboard(name: "Add", bundle: nil).instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        let tabThreeBarItem = UITabBarItem(title: "+", image: UIImage(), tag: 2)
        tabThree.tabBarItem = tabThreeBarItem
        
        let tabFour = UIStoryboard(name: "Finance", bundle: nil).instantiateViewController(withIdentifier: "FinanceViewController") as! FinanceViewController
        let tabFourBarItem = UITabBarItem(title: "재정", image: UIImage(), tag: 3)
        tabFour.tabBarItem = tabFourBarItem
        
        let tabFive = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "MyPageViewController") as! MyPageViewController
        let tabFiveBarItem = UITabBarItem(title: "내정보", image: UIImage(), tag: 4)
        tabFive.tabBarItem = tabFiveBarItem
        
        self.viewControllers = [tabOne, tabTwo, tabThree, tabFour, tabFive]
        self.selectedIndex = 0
     
        if(!UserDefaults.standard.bool(forKey: "isFirst")){
            loadTutorialScreen()
            UserDefaults.standard.set(true, forKey: "isFirst")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadTutorialScreen() {
        let storyboard = UIStoryboard(name: "Tutorial", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(controller, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
