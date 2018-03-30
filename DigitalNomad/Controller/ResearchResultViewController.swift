//
//  ResearchResultViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 20..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class ResearchResultViewController: UIViewController {
    @IBOutlet var researchResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickRecommendedPlace(_ sender: UIButton) {
        //다음 뷰컨트롤러에 장소 스트링을 같이 보내주기
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EnrollmentViewController") as! EnrollmentViewController
        controller.str = researchResult.text!
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func clickAnotherPlace(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EnrollmentViewController")
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func clickAgain(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ResearchViewController")
        present(controller, animated: true, completion: nil)
    }
}
