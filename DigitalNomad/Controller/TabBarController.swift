//
//  TabBarController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 2. 24..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabOne  = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        let tabOneBarItem = UITabBarItem(title: "유목지살펴보기", image: nil, tag: 0)
        tabOne.tabBarItem = tabOneBarItem
        let tabTwo = UIStoryboard(name: "Nomad", bundle: nil).instantiateViewController(withIdentifier: "NomadViewController") as! NomadViewController
        let tabTwoBarItem = UITabBarItem(title: "유목생활노트", image: nil, tag: 1)
        tabTwo.tabBarItem = tabTwoBarItem
        let tabThree = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "MyPageViewController") as! MyPageViewController
        let tabThreeBarItem = UITabBarItem(title: "마이페이지", image: nil, tag: 2)
        tabThree.tabBarItem = tabThreeBarItem
        self.viewControllers = [tabOne, tabTwo, tabThree]
        self.selectedIndex = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
