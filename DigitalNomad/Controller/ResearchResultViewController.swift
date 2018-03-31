//
//  ResearchResultViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 20..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class ResearchResultViewController: UIViewController {
    var city_f = -1
    @IBOutlet var researchResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch city_f {
        case 0:
            researchResult.text = "서울"
        case 1:
            researchResult.text = "광주"
        case 2:
            researchResult.text = "대전"
        case 3:
            researchResult.text = "대구"
        case 4:
            researchResult.text = "부산"
        case 5:
            researchResult.text = "제주"
        case 6:
            researchResult.text = "인천"
        case 7:
            researchResult.text = "강원"
        case 8:
            researchResult.text = "전주"
        case 9:
            researchResult.text = "남해"
        default:
            researchResult.text = "오류가 났어요..ㅠㅠ"
        }
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
