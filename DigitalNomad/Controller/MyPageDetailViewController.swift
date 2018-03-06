//
//  MyPageDetailViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 6..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit

class MyPageDetailViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MyPageDetailImageCell", bundle: nil), forCellReuseIdentifier: "myPageDetailImageCell")
        tableView.register(UINib(nibName: "MyPageDetailInfoCell", bundle: nil), forCellReuseIdentifier: "myPageDetailInfoCell")
        tableView.register(UINib(nibName: "MyPageDetailMailCell", bundle: nil), forCellReuseIdentifier: "myPageDetailMailCell")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clickCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension MyPageDetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.section){
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "myPageDetailImageCell") as! MyPageDetailImageCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "myPageDetailInfoCell") as! MyPageDetailInfoCell
            switch(indexPath.row){
            case 0:
                cell.title.text = "사용자 이름"
                cell.textField.isUserInteractionEnabled = false
                cell.textField.text = "유목민"
            case 1:
                cell.title.text = "이메일"
                cell.textField.isUserInteractionEnabled = false
                cell.textField.text = "umokmin@gmail.com"
            case 2:
                cell.title.text = "유목 장소"
                cell.textField.isUserInteractionEnabled = false
                cell.textField.text = "서울특별시 광진구"
            default:
                break
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "myPageDetailInfoCell") as! MyPageDetailInfoCell
            switch(indexPath.row){
            case 0:
                cell.title.text = "직업"
                cell.textField.isUserInteractionEnabled = false
                cell.textField.text = "개발자"
            case 1:
                cell.title.text = "소개말"
                cell.textField.placeholder = "소개말"
                cell.textField.text = "저녁 식사 함께해요!"
            case 2:
                cell.title.text = "밋업 목적"
                cell.textField.placeholder = "밋업 목적"
                cell.textField.text = "유목민친구 만들기"
            default:
                break
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "myPageDetailMailCell") as! MyPageDetailMailCell
            cell.view.frame.size.width = tableView.frame.size.width
            return cell
        default:
            return UITableViewCell()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 3
        case 3:
            return 1
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 2){
            return "Co-working"
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 2){
            return 20
        }
        return 5
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.backgroundView?.backgroundColor = .clear
        header.textLabel?.textColor = UIColor(red: 239/255, green: 144/255, blue: 130/255, alpha: 1)
        header.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        if(section == 2){
            let coworkingAllowingSwitch = UISwitch(frame: CGRect(x: tableView.frame.width - 60, y: 0, width: 20, height: 20))
            header.addSubview(coworkingAllowingSwitch)
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.backgroundView?.backgroundColor = .clear
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch(indexPath.section){
        case 0:
            return 200
        case 1, 2:
            return 51
        case 3:
            return 140
        default:
            return 0
        }
    }
}

extension MyPageDetailViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
