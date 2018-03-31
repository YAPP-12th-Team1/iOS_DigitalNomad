//
//  MyPageDetailViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 6..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import GoogleSignIn
import JTMaterialSwitch
import Toaster
import CoreLocation
import Alamofire

class MyPageDetailViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var coworkingAllowingSwitch: JTMaterialSwitch = JTMaterialSwitch()
    var buttonRefresh: UIButton = UIButton()
    var realm: Realm!
    var userInfo: UserInfo!
    var userLocationInfo: UserLocationInfo?
    
    let locationManager = CLLocationManager()
    var myLat : Double = 0.0
    var myLong : Double = 0.0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        realm = try! Realm()
        userInfo = realm.objects(UserInfo.self).last
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation() // 위치 정보 받음
        }
        
        userLocationInfo = realm.objects(UserLocationInfo.self).first
        
        tableView.register(UINib(nibName: "MyPageDetailImageCell", bundle: nil), forCellReuseIdentifier: "myPageDetailImageCell")
        tableView.register(UINib(nibName: "MyPageDetailInfoCell", bundle: nil), forCellReuseIdentifier: "myPageDetailInfoCell")
        tableView.register(UINib(nibName: "MyPageDetailMailCell", bundle: nil), forCellReuseIdentifier: "myPageDetailMailCell")
        coworkingAllowingSwitch = JTMaterialSwitch(size: JTMaterialSwitchSizeSmall, style: JTMaterialSwitchStyleLight, state: JTMaterialSwitchStateOff)
        coworkingAllowingSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        buttonRefresh = UIButton(type: .custom)
        buttonRefresh.addTarget(self, action: #selector(clickRefresh), for: .touchUpInside)
        buttonRefresh.setTitle("R", for: .normal)
        buttonRefresh.setTitleColor(.black, for: .normal)
        if(userInfo.cowork){
            coworkingAllowingSwitch.setOn(true, animated: false)
        } else {
            coworkingAllowingSwitch.setOn(false, animated: false)
        }
        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickConfirm(_ sender: UIButton) {

        if(tableView.numberOfSections == 4){
            let introducingCell = tableView.cellForRow(at: IndexPath(row: 1, section: 2)) as! MyPageDetailInfoCell
            let purposeCell = tableView.cellForRow(at: IndexPath(row: 2, section: 2)) as! MyPageDetailInfoCell
            let mailCell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! MyPageDetailMailCell
            
            let introducing = introducingCell.textField.text
            let purpose = purposeCell.textField.text
            
            if let emailInfo = realm.objects(EmailInfo.self).first {
                if let title = mailCell.title.text{
                    try! realm.write {
                        emailInfo.title = title
                    }
                }
                if let message = mailCell.message.text{
                    try! realm.write{
                        emailInfo.context = message
                    }
                }
            } else {
                addEmail(mailCell.title.text ?? "", mailCell.message.text ?? "")
            }
            
            try! realm.write{
                userInfo.cowork = true
                userInfo.introducing = introducing
                userInfo.purpose = purpose
            }
            
            /** firebase emailInfo Update **/
            Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("emailInfo").setValue([
                "title": mailCell.title.text,
                "context": mailCell.message.text
            ])
            
            /** firebase User Update **/
            Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).updateChildValues([
                "introducing" : introducing,
                "purpose" : purpose,
                "cowrk": true
            ])

        }
        Toast(text: "저장했습니다.", duration: Delay.short).show()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            if(self.view.frame.origin.y == 0){
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    @objc func keyboardWillHide(_ notification: Notification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            if(self.view.frame.origin.y != 0){
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @objc func clickRefresh(){
        //위치 정보 새로고침
        //위치 정보 UserLocationInfo에 업데이트
        //좌표 값에 따라서 위치 나오면 UserInfo에 업데이트
        //tableView.reloadData()
        
        
        
        let baseUrl: String = "https://dapi.kakao.com/v2/local/geo/coord2address.json?"
        Alamofire.request(baseUrl+"x=\(myLong)&y=\(myLat)", method: .get ,headers: ["Authorization": "KakaoAK 8add144f51d5e214bb8d9008445c817d"]).responseJSON {
            response in
            
            guard response.result.error == nil else {
                print("error calling GET on /todos/1")
                print(response.result.error!)
                return
            }

            guard let json = response.result.value as? [String: Any] else {
                print("didn't get todo objecy as JSON from API")
                print("Error: \(String(describing: response.result.error))")
                return
            }
            
            guard let doc = json["documents"] as? [[String: Any]] else {
                print("Could not get documents from JSON")
                return
            }
            
            let addr = doc[0]["address"] as! [String:String]
            let region1 = addr["region_1depth_name"]!
            let region2 = addr["region_2depth_name"]!
            
            let str = region1+" "+region2
            try! self.realm.write{
                self.userInfo.address = str
            }
            
            Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).updateChildValues([
                "address" : str
                ])
        }
        
    }
    
    @objc func switchValueChanged(_ sender: JTMaterialSwitch){
        if(sender.isOn){
            try! realm.write {
                userInfo.cowork = true
            }
        } else {
            try! realm.write{
                userInfo.cowork = false
            }
        }
        tableView.reloadData()
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
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
                cell.textField.text = userInfo.nickname
                //cell.textField.text = "유목민"
            case 1:
                cell.title.text = "이메일"
                cell.textField.isUserInteractionEnabled = false
                cell.textField.text = userInfo.email
                //cell.textField.text = "umokmin@gmail.com"
            case 2:
                cell.title.text = "유목 장소"
                cell.textField.isUserInteractionEnabled = false
                cell.textField.text = { () in
                    if let address = userInfo.address {
                        return address
                    } else {
                        return "No Info"
                    }
                }()
                //cell.textField.text = "서울특별시 광진구"
                buttonRefresh.frame = CGRect(x: tableView.frame.width - 60, y: cell.frame.height / 2 - 10, width: 40 , height: 20)
                cell.addSubview(buttonRefresh)
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
                cell.textField.text = userInfo.job
                //cell.textField.text = "개발자"
            case 1:
                cell.title.text = "소개말"
                cell.textField.isUserInteractionEnabled = true
                cell.textField.placeholder = "소개말"
                cell.textField.text = { () in
                    if let introducing = userInfo.introducing {
                        return introducing
                    } else {
                        return nil
                    }
                }()
            case 2:
                cell.title.text = "밋업 목적"
                cell.textField.isUserInteractionEnabled = true
                cell.textField.placeholder = "밋업 목적"
                cell.textField.text = { () in
                    if let purpose = userInfo.purpose {
                        return purpose
                    } else {
                        return nil
                    }
                }()
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
        if(coworkingAllowingSwitch.isOn){
            return 4
        } else {
            return 2
        }
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.backgroundView?.backgroundColor = .clear
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if(section == 1){
            return "Co-working"
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section == 1){
            return 20
        }
        return 5
    }
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.backgroundView?.backgroundColor = .clear
        header.textLabel?.textColor = #colorLiteral(red: 0.937254902, green: 0.5647058824, blue: 0.5098039216, alpha: 1)
        header.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        if(section == 1){
            coworkingAllowingSwitch.frame = CGRect(x: tableView.frame.width - 60, y: 0, width: 20, height: header.frame.height)
            header.addSubview(coworkingAllowingSwitch)
        }
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

extension MyPageDetailViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLat = locations[locations.count-1].coordinate.latitude
        myLong = locations[locations.count-1].coordinate.longitude
        
        print(myLat)
        print(myLong)
    }
}
