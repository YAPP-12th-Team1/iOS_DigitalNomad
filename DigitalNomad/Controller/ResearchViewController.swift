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

    // 1.서울, 2.광주, 3.대전, 4.대구, 5.부산, 6.제주, 7.인천, 8.강원, 9.전주, 10.남해
    let cityData = [553155, 121233, 121253, 121233, 324514, 424515, 123424, 125512, 1512511, 125511]
    let citynature = [
        [3,3,4,2,4,5],
        [5,3,1,1,5,5],
        [4,3,1,1,5,5]
    ]
    let coworking1 = [
        [2,2,2,3,5,2],
        [3,3,3,2,5,1],
        [5,3,3,1,1,1],
        [2,2,3,4,3,1]
    ]
    let coworking2 = [
        [4,2,2,2,1,5],
        [5,3,1,1,5,5],
        [2,2,2,2,2,5],
        [5,2,3,2,2,5]
    ]
    let culture = [
        [5,2,2,4,2,1],
        [5,2,2,2,2,1],
        [4,2,3,2,2,5],
        [5,2,2,3,4,1]
    ]
    let history = [
        [3,5,2,4,3,2],
        [2,5,2,5,3,1],
        [2,5,2,4,3,3]
    ]
    let leports = [
        [3,4,4,5,3,4],
        [5,2,5,5,2,3],
        [5,2,4,5,2,3],
        [5,2,5,5,2,1],
        [3,2,5,4,2,1],
    ]
    let nature = [
        [4,3,5,4,3,4],
        [3,3,5,4,2,3],
        [2,2,5,5,2,3],
        [3,3,4,5,3,4],
        [2,2,4,5,4,2],
        [2,2,2,5,2,2]
    ]
    var state = 0   // 0: citynatrue, 1: coworking1, 2: coworking2, 3: culture, 4: history, 5:leports, 6: nature
    var preState = 0
    var visited = [
        [false, false, false],
        [false, false, false, false],
        [false, false, false, false],
        [false, false, false, false],
        [false, false, false],
        [false, false, false, false, false],
        [false, false, false, false, false, false]
    ]
    
    var count = [0, 0, 0, 0, 0, 0, 0]
    var must = [2, 1, 0, 2, 2, 2, 2]
    var totalCount = 0
    var value = [0, 0, 0, 0, 0, 0]
    
    
    var status : UInt64 = 0
    var index : UInt32 = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = #imageLiteral(resourceName: "citynature_111151.jpg")
        visited[0][0] = true
        count[0] += 1
        totalCount += 1
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clickLike(_ sender: UIButton) {
        switch state {
        case 0:
            value[0] += citynature[Int(index)][0]
            value[1] += citynature[Int(index)][1]
            value[2] += citynature[Int(index)][2]
            value[3] += citynature[Int(index)][3]
            value[4] += citynature[Int(index)][4]
            value[5] += citynature[Int(index)][5]
        case 1:
            value[0] += coworking1[Int(index)][0]
            value[1] += coworking1[Int(index)][1]
            value[2] += coworking1[Int(index)][2]
            value[3] += coworking1[Int(index)][3]
            value[4] += coworking1[Int(index)][4]
            value[5] += coworking1[Int(index)][5]
        case 2:
            value[0] += coworking2[Int(index)][0]
            value[1] += coworking2[Int(index)][1]
            value[2] += coworking2[Int(index)][2]
            value[3] += coworking2[Int(index)][3]
            value[4] += coworking2[Int(index)][4]
            value[5] += coworking2[Int(index)][5]
        case 3:
            value[0] += culture[Int(index)][0]
            value[1] += culture[Int(index)][1]
            value[2] += culture[Int(index)][2]
            value[3] += culture[Int(index)][3]
            value[4] += culture[Int(index)][4]
            value[5] += culture[Int(index)][5]
        case 4:
            value[0] += history[Int(index)][0]
            value[1] += history[Int(index)][1]
            value[2] += history[Int(index)][2]
            value[3] += history[Int(index)][3]
            value[4] += history[Int(index)][4]
            value[5] += history[Int(index)][5]
        case 5:
            value[0] += leports[Int(index)][0]
            value[1] += leports[Int(index)][1]
            value[2] += leports[Int(index)][2]
            value[3] += leports[Int(index)][3]
            value[4] += leports[Int(index)][4]
            value[5] += leports[Int(index)][5]
        case 6:
            value[0] += nature[Int(index)][0]
            value[1] += nature[Int(index)][1]
            value[2] += nature[Int(index)][2]
            value[3] += nature[Int(index)][3]
            value[4] += nature[Int(index)][4]
            value[5] += nature[Int(index)][5]
        default:
            value[0] += 0
            value[1] += 0
            value[2] += 0
            value[3] += 0
            value[4] += 0
            value[5] += 0
        }
        selectImage()
        print(value)
    }
    
    @IBAction func clickNext(_ sender: UIButton) {
        selectImage()
    }
    
    @IBAction func clickSkip(_ sender: UIButton) {
        let cityIndex = matchCity()
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ResearchResultViewController") as! ResearchResultViewController
        controller.city_f = cityIndex
        present(controller, animated: true, completion: nil)
    }
    
    // 0: citynatrue, 1: coworking1(111111), 2: coworking2(111115), 3: culture, 4: history, 5:leports, 6: nature
    
    func selectImage() {
        index = arc4random_uniform(UInt32(visited[state].count))
        while visited[state][Int(index)] == true {
            index = arc4random_uniform(UInt32(visited[state].count))
            
        }
        
        loadImage(state, Int(index))
        
        count[state] += 1
        totalCount += 1
        
        preState = state
        
        if totalCount <= 11 {
            if count[state] == must[state] {
                if totalCount < 11 && state == 1 {
                    state += 2
                } else {
                    state += 1
                }
            }
        } else {
            if count[state] == visited[state].count {
                state += 1
            }
        }
        
        if state == 7 && totalCount == 11 {
            state = 0
        } else if state == 7 && totalCount == 29 {
            let cityIndex = matchCity()
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ResearchResultViewController") as! ResearchResultViewController
            controller.city_f = cityIndex
            present(controller, animated: true, completion: nil)
        }
    }
    
    func loadImage(_ category: Int, _ index: Int) {
        visited[category][index] = true
        
        switch category {
        case 0:
            if index == 1 {
                self.imageView.image = #imageLiteral(resourceName: "citynature(1)_111151.jpg")
            } else if index == 2 {
                self.imageView.image = #imageLiteral(resourceName: "citynature(2)_111151.jpg")
            }
        case 1:
            if index == 0 {
                self.imageView.image = #imageLiteral(resourceName: "coworking_111111.jpg")
            } else if index == 1 {
                self.imageView.image = #imageLiteral(resourceName: "coworking(1)_111111.jpg")
            } else if index == 2 {
                self.imageView.image = #imageLiteral(resourceName: "coworking(2)_111111.jpg")
            } else if index == 3 {
                self.imageView.image = #imageLiteral(resourceName: "coworking(3)_111111.jpg")
            }
        case 2:
            if index == 0 {
                self.imageView.image = #imageLiteral(resourceName: "coworking_111115.jpg")
            } else if index == 1 {
                self.imageView.image = #imageLiteral(resourceName: "coworking(1)_111115.jpg")
            } else if index == 2 {
                self.imageView.image = #imageLiteral(resourceName: "coworking(2)_111115.jpg")
            } else if index == 3 {
                self.imageView.image = #imageLiteral(resourceName: "coworking(3)_111115.jpg")
            }
        case 3:
            if index == 0 {
                self.imageView.image = #imageLiteral(resourceName: "culture_511111.jpg")
            } else if index == 1 {
                self.imageView.image = #imageLiteral(resourceName: "culture(1)_511111.jpg")
            } else if index == 2 {
                self.imageView.image = #imageLiteral(resourceName: "culture(2)_511111.jpg")
            } else if index == 3 {
                self.imageView.image = #imageLiteral(resourceName: "culture(3)_511111.jpg")
            }
        case 4:
            if index == 0 {
                self.imageView.image = #imageLiteral(resourceName: "history_151111.jpg")
            } else if index == 1 {
                self.imageView.image = #imageLiteral(resourceName: "history(1)_151111.jpg")
            } else if index == 2 {
                self.imageView.image = #imageLiteral(resourceName: "history(2)_151111.jpg")
            }
        case 5:
            if index == 0 {
                self.imageView.image = #imageLiteral(resourceName: "leports_115111.jpg")
            } else if index == 1 {
                self.imageView.image = #imageLiteral(resourceName: "leports(1)_115111.jpg")
            } else if index == 2 {
                self.imageView.image = #imageLiteral(resourceName: "leports(2)_115111.jpg")
            } else if index == 3 {
                self.imageView.image = #imageLiteral(resourceName: "leports(3)_115111.jpg")
            } else if index == 4 {
                self.imageView.image = #imageLiteral(resourceName: "leports(4)_115111.jpg")
            }
        case 6:
            if index == 0 {
                self.imageView.image = #imageLiteral(resourceName: "nature_111511.jpg")
            } else if index == 1 {
                self.imageView.image = #imageLiteral(resourceName: "nature(1)_111511.jpg")
            } else if index == 2 {
                self.imageView.image = #imageLiteral(resourceName: "nature(2)_111511.jpg")
            } else if index == 3 {
                self.imageView.image = #imageLiteral(resourceName: "nature(3)_111511.jpg")
            } else if index == 4 {
                self.imageView.image = #imageLiteral(resourceName: "nature(4)_111511.jpg")
            } else if index == 5 {
                self.imageView.image = #imageLiteral(resourceName: "nature(5)_111511.jpg")
            }
        default:
            self.imageView.image = #imageLiteral(resourceName: "kamel.png")
        }
    }
    
    func matchCity() -> Int {
        let value_f: Int = (value[0]/totalCount)*100000 + (value[1]/totalCount)*10000 + (value[2]/totalCount)*1000 + (value[3]/totalCount)*100 + (value[4]/totalCount)*10 + (value[5]/totalCount)
        
        print(value_f)
        
        var min = 555555555
        var minIndex = 10
        for index in 0..<cityData.count {
            if abs((value_f - cityData[index])) < min {
                min = abs((value_f - cityData[index]))
                minIndex = index
            }
        }
        
        return minIndex
    }
}
