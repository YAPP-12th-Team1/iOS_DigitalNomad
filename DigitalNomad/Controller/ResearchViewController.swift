//
//  ResearchViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 20..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class ResearchViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    //마음에 드는 사진에 하트를 누르는 뷰컨트롤러
    //배열을 미리 두고 하트나 다음 누를 때마다 다음 사진을 보여주게 하고
    //하트 카운트를 세는 식으로 하면 될까나
    //일단 무조건 ResearchResultViewController로 넘어가게 함

    // 1.서울, 2.제주, 3.부산, 4.안동, 5.김천, 6.창원, 7.대전, 8.경주, 9.청주, 10.김해, 11.전주, 12.과천, 13.여수, 14.강릉
    let cityData = [555055555/*서울*/, 432532225/*제주*/, 551455453/*부산*/, 325022325/*안동*/, 313011113/*김천*/, 442444343/*창원*/,
                    552033442/*대전*/, 315022225/*경주*/, 432033331/*청주*/, 432344441/*김해*/, 435043345/*전주*/,
                    511022431/*과천*/,
                    311442234/*여수*/]
    
    // 1.Internet, 2.Sport, 3.Traditional, 4.Sea, 5.Fun(<->Calm), 6.NightLife, 7.Culture 8.City(<->Natural), 9.Tour
    // 0.None, 1.Terrible, 2.Bad, 3.Normal, 4.Good, 5.Awesome
    
    let picData = [050000000, 050000000, 005011010, 005000000, 000510010, 000555050, 000511010, 000503004, 050000010, 000500015,
                   000500015, 500510010, 005010000, 000055550, 000055550, 000020500, 000010010, 000010010, 000010010, 500000550,
                   500005550, 500020050, 000055050, 000055050, 005000005, 005000005, 000011010, 000311013, 000533033, 000010010,
                   000420015]
    
    var status : UInt64 = 0
    var index = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = #imageLiteral(resourceName: "1.jpg")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clickLike(_ sender: UIButton) {
        chPic(index)
        index += 1;
    }
    
    @IBAction func clickNext(_ sender: UIButton) {
        chPic(index)
        index += 1;
    }
    
    @IBAction func clickSkip(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ResearchResultViewController")
        present(controller, animated: true, completion: nil)
    }
    
    func chPic(_ index: Int) {
        switch index {
        case 1:
            self.imageView.image = #imageLiteral(resourceName: "2.jpg")
        case 2:
            self.imageView.image = #imageLiteral(resourceName: "3.jpg")
        case 3:
            self.imageView.image = #imageLiteral(resourceName: "4.jpg")
        case 4:
            self.imageView.image = #imageLiteral(resourceName: "5.jpg")
        case 5:
            self.imageView.image = #imageLiteral(resourceName: "6.jpg")
        case 6:
            self.imageView.image = #imageLiteral(resourceName: "7.jpg")
        case 7:
            self.imageView.image = #imageLiteral(resourceName: "8.jpg")
        case 8:
            self.imageView.image = #imageLiteral(resourceName: "9.jpg")
        case 9:
            self.imageView.image = #imageLiteral(resourceName: "10.jpg")
        case 10:
            self.imageView.image = #imageLiteral(resourceName: "11.bmp")
        case 11:
            self.imageView.image = #imageLiteral(resourceName: "12.jpeg")
        case 12:
            self.imageView.image = #imageLiteral(resourceName: "13.jpg")
        case 13:
            self.imageView.image = #imageLiteral(resourceName: "14.jpg")
        case 14:
            self.imageView.image = #imageLiteral(resourceName: "15.jpg")
        case 15:
            self.imageView.image = #imageLiteral(resourceName: "26.jpg")
        case 16:
            self.imageView.image = #imageLiteral(resourceName: "17.jpeg")
        case 17:
            self.imageView.image = #imageLiteral(resourceName: "18.jpg")
        case 18:
            self.imageView.image = #imageLiteral(resourceName: "19.jpg")
        case 19:
            self.imageView.image = #imageLiteral(resourceName: "20.jpg")
        case 20:
            self.imageView.image = #imageLiteral(resourceName: "21.jpg")
        case 21:
            self.imageView.image = #imageLiteral(resourceName: "22.jpeg")
        case 22:
            self.imageView.image = #imageLiteral(resourceName: "23.jpg")
        case 23:
            self.imageView.image = #imageLiteral(resourceName: "24.jpg")
        case 24:
            self.imageView.image = #imageLiteral(resourceName: "25.jpeg")
        case 25:
            self.imageView.image = #imageLiteral(resourceName: "26.jpg")
        case 26:
            self.imageView.image = #imageLiteral(resourceName: "27.jpeg")
        case 27:
            self.imageView.image = #imageLiteral(resourceName: "28.jpeg")
        case 28:
            self.imageView.image = #imageLiteral(resourceName: "29.jpeg")
        case 29:
            self.imageView.image = #imageLiteral(resourceName: "30.jpeg")
        case 30:
            self.imageView.image = #imageLiteral(resourceName: "31.jpeg")
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ResearchResultViewController")
            present(controller, animated: true, completion: nil)
        default:
            self.imageView.image = #imageLiteral(resourceName: "kamel.png")
        }
    }
}
