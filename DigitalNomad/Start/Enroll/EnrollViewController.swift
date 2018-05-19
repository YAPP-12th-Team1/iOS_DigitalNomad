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

    var recommendedPlace: String?
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
    
    func validateEnrollButton() {
        
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
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        print(item)
    }
}

//MARK:- 유목민 연결 셀 커스텀 델리게이트 구현
extension EnrollViewController: ConnectCellDeleagte {
    func touchUpYesButton() {
        
    }
    func touchUpNoButton() {
        
    }
}

//MARK:- 테이블 뷰 데이터 소스 구현
extension EnrollViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as? LocationCell else { return UITableViewCell() }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as? DateCell else { return UITableViewCell() }
            cell.pickerView.delegate = self
            cell.pickerView.dataSource = self
            cell.pickerView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            cell.pickerView.textColor = #colorLiteral(red: 0.3725490196, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
            cell.pickerView.pickerViewStyle = .wheel
            cell.pickerView.viewDepth = self.view.frame.width
            cell.pickerView.selectItem(6)
            cell.pickerView.reloadData()
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "purposeCell", for: indexPath) as? PurposeCell else { return UITableViewCell() }
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "connectCell", for: indexPath) as? ConnectCell else { return UITableViewCell() }
            cell.delegate = self
            
            return cell
        case 4:
            return UITableViewCell()
        case 5:
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
        case 4: return 3
        case 5: return 1
        default: return 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
        //return 6
    }
}

//MARK:- 테이블 뷰 델리게이트 구현
extension EnrollViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 91
        case 1: return 89
        case 2: return 96
        case 3: return 154
        case 4: return 0
        case 5: return 0
        default: return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 17
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 17))
        view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        return view
    }
}


