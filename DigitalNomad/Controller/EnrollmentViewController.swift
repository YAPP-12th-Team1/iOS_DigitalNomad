//
//  EnrollmentViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 20..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import Firebase
import AKPickerView_Swift
import Toaster

class EnrollmentViewController: UIViewController {
    var str: String = ""
    let titles = ["1일", "2일", "3일", "Aichi", "Saitama", "Chiba", "Hyogo", "Hokkaido", "Fukuoka", "Shizuoka"]
    var selectedDay: Int = 7
    var place: String = ""
    var purpose: String = ""
    
    @IBOutlet var tableView: UITableView!
    
    var pickerView: AKPickerView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView = AKPickerView()
        pickerView.frame = CGRect(x: 0, y: 40, width: self.view.frame.width, height: 50)
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.pickerView.font = UIFont(name: "HelveticaNeue-Light", size: 15)!
        self.pickerView.highlightedFont = UIFont(name: "HelveticaNeue", size: 15)!
        self.pickerView.pickerViewStyle = .wheel
        self.pickerView.maskDisabled = false
        self.pickerView.reloadData()
        
        tableView.register(UINib(nibName: "EnrollmentCell", bundle: nil), forCellReuseIdentifier: "enrollmentCell")
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pickerView.selectItem(6)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clickConfirm(_ sender: UIButton) {
        //User 최초 생성, Project 최초 생성
        if(place.isEmpty || purpose.isEmpty){
            Toast(text: "입력해주세요.", duration: Delay.short).show()
            return
        } else {
            addUser(place, selectedDay, purpose)
            addProject(selectedDay)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let next = storyboard.instantiateViewController(withIdentifier: "TabBarController")
            present(next, animated: true)
        }
    }
    
    @objc func clickYesButton(){
        
    }
    @objc func clickNoButton(){
        
    }
}

extension EnrollmentViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "enrollmentCell") as! EnrollmentCell
        switch(indexPath.row){
        case 0:
            cell.textField.delegate = self
            cell.textField.tag = 0
            if str == "" {
                cell.textField.placeholder = "유목지"
            } else {
                cell.textField.text! = str
            }
        case 1:
            cell.addSubview(self.pickerView)
            cell.textField.isHidden = true
        case 2:
            cell.textField.delegate = self
            cell.textField.tag = 1
            cell.textField.placeholder = "유목 목적"
            
        case 3:
            cell.textField.isUserInteractionEnabled = false
            cell.textField.text = "주변 유목민과의 연결을 원하시나요?"
            let yesButton = UIButton()
            let noButton = UIButton()
            yesButton.setTitle("예", for: .normal)
            noButton.setTitle("아니오", for: .normal)
            yesButton.setTitleColor(.black, for: .normal)
            noButton.setTitleColor(.black, for: .normal)
            yesButton.frame.size = CGSize(width: 50, height: 30)
            noButton.frame.size = CGSize(width: 50, height: 30)
            yesButton.frame.origin.y = cell.textField.frame.origin.y + 30
            noButton.frame.origin.y = cell.textField.frame.origin.y + 30
            yesButton.frame.origin.x = self.view.frame.width / 2 - 50 - 30
            noButton.frame.origin.x = self.view.frame.width / 2 + 50
            yesButton.addTarget(self, action: #selector(clickYesButton), for: .touchUpInside)
            noButton.addTarget(self, action: #selector(clickNoButton), for: .touchUpInside)
            yesButton.layer.cornerRadius = 5
            noButton.layer.cornerRadius = 5
            yesButton.layer.borderWidth = 2
            noButton.layer.borderWidth = 2
            yesButton.layer.borderColor = UIColor.black.cgColor
            noButton.layer.borderColor = UIColor.black.cgColor
            cell.addSubview(yesButton)
            cell.addSubview(noButton)
        default:
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 3){
            return 150
        }
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}
extension EnrollmentViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EnrollmentViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.tag == 0){
            place = textField.text!
        } else {
            purpose = textField.text!
        }
    }
}

extension EnrollmentViewController: AKPickerViewDataSource{
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return 30
    }
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        return " \(item+1)일 "
    }
}
extension EnrollmentViewController: AKPickerViewDelegate{
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        selectedDay = item + 1
    }
}
