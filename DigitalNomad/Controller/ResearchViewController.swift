//
//  ResearchViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 2. 24..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class ResearchViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        dataSource = self
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = .gray
        appearance.currentPageIndicatorTintColor = .red
        appearance.backgroundColor = .white
        
        if let firstViewController = orderedResearchViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

private(set) var orderedResearchViewControllers: [UIViewController] = {
    let storyboard = UIStoryboard(name: "Research", bundle: nil)
    return [storyboard.instantiateViewController(withIdentifier: "Research1ViewController"), storyboard.instantiateViewController(withIdentifier: "Research2ViewController"), storyboard.instantiateViewController(withIdentifier: "Research3ViewController"), storyboard.instantiateViewController(withIdentifier: "Research4ViewController"), storyboard.instantiateViewController(withIdentifier: "Research5ViewController")]
}()


extension ResearchViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = orderedResearchViewControllers.index(of: viewController) else { return nil }
        let previousIndex = index - 1
        guard previousIndex >= 0 else { return nil }
        guard orderedResearchViewControllers.count > previousIndex else { return nil }
        return orderedResearchViewControllers[previousIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = orderedResearchViewControllers.index(of: viewController) else { return nil }
        let nextIndex = index + 1
        let orderedViewControllersCount = orderedResearchViewControllers.count
        guard orderedViewControllersCount != nextIndex else { return nil }
        guard orderedViewControllersCount > nextIndex else { return nil }
        return orderedResearchViewControllers[nextIndex]
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 5
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
