//
//  EnrollViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 19..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import AKPickerView_Swift

class EnrollViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var enrollButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //등록 버튼 초기화
        self.enrollButton.isEnabled = false
        self.enrollButton.addTarget(self, action: #selector(touchUpEnrollButton(_:)), for: .touchUpInside)

    }
    
    @objc func touchUpEnrollButton(_ sender: UIButton) {
        
    }
}

//MARK:- 수평 피커 뷰 데이터소스 구현
extension EnrollViewController: AKPickerViewDataSource {
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return 30
    }
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        return "\(item + 1)일"
    }
}

//MARK:- 수평 피커 뷰 델리게이트 구현
extension EnrollViewController: AKPickerViewDelegate {
    
}

extension EnrollViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as? LocationCell else { return UITableViewCell() }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as? DateCell else { return UITableViewCell() }
            cell.pickerView.delegate = self
            return cell
        case 2:
            return UITableViewCell()
        case 3:
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        case 3: return 1
        default: return 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
}

extension EnrollViewController: UITableViewDelegate {
    
}
