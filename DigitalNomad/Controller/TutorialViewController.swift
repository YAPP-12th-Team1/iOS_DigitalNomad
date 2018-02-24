//
//  TutorialViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 2. 24..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class TutorialViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        dataSource = self
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = .gray
        appearance.currentPageIndicatorTintColor = .red
        appearance.backgroundColor = .white
        
        if let firstViewController = orderedTutorialViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

private(set) var orderedTutorialViewControllers: [UIViewController] = {
    let storyboard = UIStoryboard(name: "Tutorial", bundle: nil)
    return [storyboard.instantiateViewController(withIdentifier: "Tutorial1ViewController"), storyboard.instantiateViewController(withIdentifier: "Tutorial2ViewController"), storyboard.instantiateViewController(withIdentifier: "Tutorial3ViewController")]
}()


extension TutorialViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = orderedTutorialViewControllers.index(of: viewController) else { return nil }
        let previousIndex = index - 1
        guard previousIndex >= 0 else { return nil }
        guard orderedTutorialViewControllers.count > previousIndex else { return nil }
        return orderedTutorialViewControllers[previousIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = orderedTutorialViewControllers.index(of: viewController) else { return nil }
        let nextIndex = index + 1
        let orderedViewControllersCount = orderedTutorialViewControllers.count
        guard orderedViewControllersCount != nextIndex else { return nil }
        guard orderedViewControllersCount > nextIndex else { return nil }
        return orderedTutorialViewControllers[nextIndex]
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 3
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
