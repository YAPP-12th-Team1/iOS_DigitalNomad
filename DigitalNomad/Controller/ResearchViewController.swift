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

    // 1.서울, 2.제주, 3.부산, 4.안동, 5.김천, 6.창원, 7.대전, 8.경주, 9.청주, 10.김해, 11.전주, 12.과천, 13.여수, 14.강릉
    
    
    let cityData = [555055555/*서울*/,
                    432532225/*제주*/,
                    551455453/*부산*/,
                    325022325/*안동*/,
                    313011113/*김천*/,
                    442444343/*창원*/,
                    552033442/*대전*/,
                    315022225/*경주*/,
                    432033331/*청주*/,
                    432344441/*김해*/,
                    435043345/*전주*/,
                    511022431/*과천*/,
                    311442234/*여수*/]
    
    // 1.Internet, 2.Sport, 3.Traditional, 4.Sea, 5.Fun(<->Calm), 6.NightLife, 7.Culture 8.City(<->Natural), 9.Tour
    // 0.None, 1.Terrible, 2.Bad, 3.Normal, 4.Good, 5.Awesome
    
    let picData = [050000000, 050000000, 005011010, 005000000, 000510010, 000555050, 000511010, 000503004, 050000010, 000500015,
                   000500015, 500510010, 005010000, 000055550, 000055550, 000020500, 000010010, 000010010, 000010010, 500000550,
                   500005550, 500020050, 000055050, 000055050, 005000005, 005000005, 000011010, 000311013, 000533033, 000010010,
                   000420015]
    
    var status : UInt64 = 0
    
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
