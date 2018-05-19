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
import DLRadioButton
import SnapKit

class PlaceViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UITextField!
    @IBOutlet var toggleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //텍스트필드 패딩 설정
        self.searchBar.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: self.searchBar.frame.height))
        self.searchBar.leftViewMode = .always
        
        //타겟 등록
        self.searchBar.addTarget(self, action: #selector(editingSearchBar), for: .editingChanged)
    }
    
    @objc func editingSearchBar(_ sender: UITextField) {
        
    }
}

extension PlaceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //검색
        textField.endEditing(true)
        return true
    }
}

extension PlaceViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
}

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

extension PlaceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mapCell", for: indexPath) as? PlaceCell else { return UITableViewCell() }
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}

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
