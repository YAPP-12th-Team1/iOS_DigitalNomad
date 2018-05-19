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
}

extension EnrollmentViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
