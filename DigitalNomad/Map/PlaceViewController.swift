//
//  PlaceViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 19..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Alamofire
import SwiftyJSON
import MapKit
import CoreLocation
import SnapKit

class PlaceViewController: UIViewController {

    
    //MARK:- IBOutlets
    @IBOutlet var upperView: UIImageView!
    @IBOutlet var centerView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UITextField!
    @IBOutlet var searchImage: UIImageView!
    @IBOutlet var toggleButton: UIButton!
    
    //MARK:- 프로퍼티
    var recentCheckButton: UIButton!
    var distanceCheckButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //체크 버튼 생성, 초기화
        self.initializeCheckButtons()
        
        //텍스트필드 패딩 설정
        self.searchBar.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: self.searchBar.frame.height))
        self.searchBar.leftViewMode = .always
        
        //타겟 등록
        self.toggleButton.addTarget(self, action: #selector(touchUpToggleButton(_:)), for: .touchUpInside)
        self.recentCheckButton.addTarget(self, action: #selector(touchUpRecentCheckButton(_:)), for: .touchUpInside)
        self.distanceCheckButton.addTarget(self, action: #selector(touchUpDistanceCheckButton(_:)), for: .touchUpInside)
    }

    //MARK:- 커스텀 메소드
    //MARK: 토글 버튼 액션 메소드
    @objc func touchUpToggleButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "  더보기" {
            sender.setTitle("  지도", for: .normal)
            sender.setImage(#imageLiteral(resourceName: "Map"), for: .normal)
            self.tableView.snp.removeConstraints()
            self.tableView.snp.makeConstraints { (make) in
                make.top.equalTo(self.upperView.snp.bottom)
            }
            self.searchBar.isHidden = true
            self.searchImage.isHidden = true
            self.recentCheckButton.isHidden = false
            self.distanceCheckButton.isHidden = false
        } else {
            sender.setTitle("  더보기", for: .normal)
            sender.setImage(#imageLiteral(resourceName: "Flag"), for: .normal)
            self.tableView.snp.removeConstraints()
            self.tableView.snp.makeConstraints { (make) in
                make.top.equalTo(self.centerView.snp.bottom)
            }
            self.searchBar.isHidden = false
            self.searchImage.isHidden = false
            self.recentCheckButton.isHidden = true
            self.distanceCheckButton.isHidden = true
        }
    }
    
    //MARK: 최근 추가순 라디오 버튼 액션 메소드
    @objc func touchUpRecentCheckButton(_ sender: UIButton) {
        if sender.isSelected { return }
        sender.isSelected = !sender.isSelected
        self.distanceCheckButton.isSelected = !sender.isSelected
    }
    
    //MARK: 거리순 라디오 버튼 액션 메소드
    @objc func touchUpDistanceCheckButton(_ sender: UIButton) {
        if sender.isSelected { return }
        sender.isSelected = !sender.isSelected
        self.recentCheckButton.isSelected = !sender.isSelected
    }
    
    //MARK: 라디오 버튼 생성
    func initializeCheckButtons() {
        self.recentCheckButton = UIButton(type: .custom)
        self.distanceCheckButton = UIButton(type: .custom)
        self.recentCheckButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        self.recentCheckButton.setTitle("  최신 추가순", for: .normal)
        self.recentCheckButton.setTitleColor(#colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1), for: .normal)
        self.recentCheckButton.setTitleColor(#colorLiteral(red: 0.3725490196, green: 0.3725490196, blue: 0.3725490196, alpha: 1), for: .selected)
        self.recentCheckButton.setImage(#imageLiteral(resourceName: "LocationCheckOff"), for: .normal)
        self.recentCheckButton.setImage(#imageLiteral(resourceName: "LocationCheckOn"), for: .selected)
        self.distanceCheckButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        self.distanceCheckButton.setTitle("  거리순", for: .normal)
        self.distanceCheckButton.setTitleColor(#colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1), for: .normal)
        self.distanceCheckButton.setTitleColor(#colorLiteral(red: 0.3725490196, green: 0.3725490196, blue: 0.3725490196, alpha: 1), for: .selected)
        self.distanceCheckButton.setImage(#imageLiteral(resourceName: "LocationCheckOff"), for: .normal)
        self.distanceCheckButton.setImage(#imageLiteral(resourceName: "LocationCheckOn"), for: .selected)
        self.view.addSubview(self.recentCheckButton)
        self.view.addSubview(self.distanceCheckButton)
        self.distanceCheckButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view.snp.right).offset(-28)
            make.centerY.equalTo(self.toggleButton.snp.centerY)
        }
        self.recentCheckButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.distanceCheckButton.snp.left).offset(-31)
            make.centerY.equalTo(self.toggleButton.snp.centerY)
        }
        self.recentCheckButton.isHidden = true
        self.distanceCheckButton.isHidden = true
        self.recentCheckButton.isSelected = !self.recentCheckButton.isSelected
    }
}

//MARK:- 검색 텍스트 필드 델리게이트 구현
extension PlaceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //검색 로직
        textField.endEditing(true)
        return true
    }
}

extension PlaceViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
}

//MARK:- 맵뷰 델리게이트 구현
extension PlaceViewController: MTMapViewDelegate {
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        if poiItem.markerType == .yellowPin { return true }
        let alert = UIAlertController(title: nil, message: "마커를 추가할까요?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "예", style: .default) { (action) in
            
        }
        let noAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
        return true
    }
}

//MARK:- 테이블 뷰 데이터 소스 구현
extension PlaceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mapCell", for: indexPath) as? PlaceCell else { return UITableViewCell() }
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}

//MARK:- 테이블 뷰 델리게이트 구현
extension PlaceViewController: UITableViewDelegate {
    
}

extension PlaceViewController: DZNEmptyDataSetSource {
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let description = NSAttributedString(string: "저장한 지역이 없습니다.", attributes: [
            NSAttributedStringKey.font: UIFont.textStyle2
            ])
        return description
    }
}

extension PlaceViewController: DZNEmptyDataSetDelegate {
    
}
