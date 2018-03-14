//
//  TabBarController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 2. 24..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    let leftButton = UIButton(type: .custom)
    let centerButton = UIButton(type: .custom)
    let rightButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        centerButton.frame.size = CGSize(width: tabBar.frame.height - 10, height: tabBar.frame.height - 10)
        let centerX = tabBar.center.x - centerButton.frame.width / 2
        let centerY = tabBar.center.y - centerButton.frame.height / 2
        centerButton.frame.origin.x = centerX
        centerButton.frame.origin.y = centerY
        centerButton.layer.cornerRadius = centerButton.frame.height / 2
        centerButton.applyGradient([#colorLiteral(red: 0.5019607843, green: 0.7215686275, blue: 0.8745098039, alpha: 1), #colorLiteral(red: 0.6980392157, green: 0.8470588235, blue: 0.7725490196, alpha: 1)])
        centerButton.layer.sublayers?.first?.cornerRadius = centerButton.frame.height / 2
        
        leftButton.frame.size = centerButton.frame.size
        let leftX = centerButton.frame.origin.x / 2
        leftButton.frame.origin.x = leftX - leftButton.frame.width / 2
        leftButton.frame.origin.y = centerY
        leftButton.layer.cornerRadius = leftButton.frame.height / 2
        leftButton.applyGradient([#colorLiteral(red: 0.5019607843, green: 0.7215686275, blue: 0.8745098039, alpha: 1), #colorLiteral(red: 0.6980392157, green: 0.8470588235, blue: 0.7725490196, alpha: 1)])
        leftButton.layer.sublayers?.first?.cornerRadius = leftButton.frame.height / 2
        
        rightButton.frame.size = centerButton.frame.size
        let rightX = centerButton.frame.origin.x * 1.5
        rightButton.frame.origin.x = rightX + rightButton.frame.width / 2
        rightButton.frame.origin.y = centerY
        rightButton.layer.cornerRadius = rightButton.frame.height / 2
        rightButton.applyGradient([#colorLiteral(red: 0.5019607843, green: 0.7215686275, blue: 0.8745098039, alpha: 1), #colorLiteral(red: 0.6980392157, green: 0.8470588235, blue: 0.7725490196, alpha: 1)])
        rightButton.layer.sublayers?.first?.cornerRadius = rightButton.frame.height / 2
        
        
        let tabOne  = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        let tabOneBarItem = UITabBarItem(title: nil, image: nil, tag: 0)
        tabOneBarItem.isEnabled = false
        tabOne.tabBarItem = tabOneBarItem
        
        let tabTwo = UIStoryboard(name: "Nomad", bundle: nil).instantiateViewController(withIdentifier: "NomadViewController") as! NomadViewController
        let tabTwoBarItem = UITabBarItem(title: nil, image: nil, tag: 1)
        tabTwoBarItem.isEnabled = false
        tabTwo.tabBarItem = tabTwoBarItem
        
        let tabThree = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "MyPageViewController") as! MyPageViewController
        let tabThreeBarItem = UITabBarItem(title: nil, image: nil, tag: 2)
        tabThreeBarItem.isEnabled = false
        tabThree.tabBarItem = tabThreeBarItem
        
        self.viewControllers = [tabOne, tabTwo, tabThree]
        self.selectedIndex = 1
        leftButton.addTarget(self, action: #selector(clickLeftButton), for: .touchUpInside)
        centerButton.addTarget(self, action: #selector(clickCenterButton), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(clickRightButton), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        
     
        if(!UserDefaults.standard.bool(forKey: "isFirst")){
            loadTutorialScreen()
            UserDefaults.standard.set(true, forKey: "isFirst")
        }
        self.view.insertSubview(leftButton, aboveSubview: self.tabBar)
        self.view.insertSubview(centerButton, aboveSubview: self.tabBar)
        self.view.insertSubview(rightButton, aboveSubview: self.tabBar)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func clickLeftButton() {
        self.selectedIndex = 0
    }
    @objc func clickCenterButton() {
        self.selectedIndex = 1
    }
    @objc func clickRightButton() {
        self.selectedIndex = 2
    }
    
    func loadTutorialScreen() {
        let storyboard = UIStoryboard(name: "Tutorial", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(controller, animated: true, completion: nil)
    }
}

extension TabBarController: UITabBarControllerDelegate{

}
