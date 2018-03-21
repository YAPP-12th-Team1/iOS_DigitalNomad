//
//  ResearchViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 20..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class ResearchViewController: UIViewController {
    
    //마음에 드는 사진에 하트를 누르는 뷰컨트롤러
    //배열을 미리 두고 하트나 다음 누를 때마다 다음 사진을 보여주게 하고
    //하트 카운트를 세는 식으로 하면 될까나
    //일단 무조건 ResearchResultViewController로 넘어가게 함

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clickLike(_ sender: UIButton) {
        
    }
    
    @IBAction func clickNext(_ sender: UIButton) {
        
    }
    
    @IBAction func clickSkip(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ResearchResultViewController")
        present(controller, animated: true, completion: nil)
    }
}
