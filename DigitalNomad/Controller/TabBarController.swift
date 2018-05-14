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
        self.tabBar.tintColor = .salmon
//        self.tabBar.tintColor = .aquamarine
        self.tabBar.backgroundImage = #imageLiteral(resourceName: "TabbarBackgroundImage")
        let tabOne  = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        let tabOneBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "Tab1"), tag: 0)
        tabOneBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabOne.tabBarItem = tabOneBarItem
        let tabTwo = UIStoryboard(name: "Note", bundle: nil).instantiateViewController(withIdentifier: "ParentViewController") as! ParentViewController
        let tabTwoBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "Tab2"), tag: 1)
        tabTwoBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabTwo.tabBarItem = tabTwoBarItem
        let tabThree = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "MyPageViewController") as! MyPageViewController
        let tabThreeBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "Tab3"), tag: 2)
        tabThreeBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabThree.tabBarItem = tabThreeBarItem
        self.viewControllers = [tabOne, tabTwo, tabThree]
        self.selectedIndex = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
}
