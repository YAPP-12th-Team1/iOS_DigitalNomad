//
//  TabBarController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 2. 24..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

//    let button = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        let tabOne  = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        let tabOneBarItem = UITabBarItem(title: "유목지살펴보기", image: UIImage(), tag: 0)
        tabOne.tabBarItem = tabOneBarItem
        
        let tabTwo = UIStoryboard(name: "NomadLife", bundle: nil).instantiateViewController(withIdentifier: "NomadLifeViewController") as! NomadLifeViewController
        let tabTwoBarItem = UITabBarItem(title: "유목생활노트", image: UIImage(), tag: 1)
        tabTwo.tabBarItem = tabTwoBarItem
        
        let tabThree = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "MyPageViewController") as! MyPageViewController
        let tabThreeBarItem = UITabBarItem(title: "마이페이지", image: UIImage(), tag: 2)
        tabThree.tabBarItem = tabThreeBarItem
        
        self.viewControllers = [tabOne, tabTwo, tabThree]
        self.selectedIndex = 1
//        button.addTarget(self, action: #selector(clickCenterButton), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        
     
        if(!UserDefaults.standard.bool(forKey: "isFirst")){
            loadTutorialScreen()
            UserDefaults.standard.set(true, forKey: "isFirst")
        }
        
        
//        button.setTitle("Cam", for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        button.setTitleColor(.yellow, for: .highlighted)
//        button.frame = CGRect(x: 100, y: 0, width: 44, height: 44)
//        button.backgroundColor = .orange
//        button.layer.borderWidth = 4
//        button.layer.borderColor = UIColor.yellow.cgColor
//        self.view.insertSubview(button, aboveSubview: self.tabBar)
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        button.frame = CGRect(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 74, width: 64, height: 64)
//        button.layer.cornerRadius = 32
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func clickCenterButton() {
        
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
