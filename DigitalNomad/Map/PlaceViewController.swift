//
//  PlaceViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 19..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import RealmSwift
import Alamofire
import SwiftyJSON
import MapKit
import CoreLocation
import Firebase
import FirebaseStorage
import SnapKit

class PlaceViewController: UIViewController {
    var filteredData: [String]!
    var loctaion_name_array = [String]()
    
    var placeNameArr = [String]()
    var addressNameArr = [String]()
    var distance = [String]()
    var xArr = [String]()
    var yArr = [String]()
    var categoryNameArr = [String]()
    
    let realm = try! Realm()
    
    let locationManager = CLLocationManager()
    var myLat : Double = 0.0
    var myLong : Double = 0.0
    
    var mapView: MTMapView!
    
    var flag : Int = 0 // 0,3 : 더 보기(거리순), 1,4 : 더 보기(최신순) ,2 : 지도 보기
    var isFirst : Bool = true
    var isFirstExecuted: Bool = false
    
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
        
        initMapView()
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.centerView.snp.bottom)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom).offset(-49)
        }
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
        self.flag = 3
        self.tableView.reloadData()
    }
    
    //MARK: 거리순 라디오 버튼 액션 메소드
    @objc func touchUpDistanceCheckButton(_ sender: UIButton) {
        if sender.isSelected { return }
        sender.isSelected = !sender.isSelected
        self.recentCheckButton.isSelected = !sender.isSelected
        self.flag = 4
        self.tableView.reloadData()
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
        
        self.placeNameArr.removeAll()
        self.addressNameArr.removeAll()
        self.distance.removeAll()
        self.xArr.removeAll()
        self.yArr.removeAll()
        self.categoryNameArr.removeAll()
        
        print("search : ", textField.text!)
        
        
        let baseUrl: String = "https://dapi.kakao.com/v2/local/search/keyword.json?query="
        let query: String = textField.text!
        let encode = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let modi = encode?.replacingOccurrences(of: "%25", with: "%")
        
        Alamofire.request(baseUrl+modi!+"&radius=20000&x=\(myLong)&y=\(myLat)", method: .get ,headers: ["Authorization": "KakaoAK 8add144f51d5e214bb8d9008445c817d"])
            .responseJSON { response in
                // check for errors
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /todos/1")
                    print(response.result.error!)
                    return
                }
                
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    print("Error: \(String(describing: response.result.error))")
                    return
                }
                
                // get and print the title
                guard let searchedPlace = json["documents"] as? [[String: Any]] else {
                    print("Could not get todo title from JSON")
                    return
                }
                
                for placeIndex in searchedPlace {
                    self.placeNameArr.append(placeIndex["place_name"] as! String)
                    self.addressNameArr.append(placeIndex["address_name"] as! String)
                    self.distance.append(placeIndex["distance"] as! String)
                    self.xArr.append(placeIndex["x"] as! String)
                    self.yArr.append(placeIndex["y"] as! String)
                    self.categoryNameArr.append(placeIndex["category_group_name"] as! String)
                }
                
                var items = [MTMapPOIItem]()
                
                for index in 0..<self.placeNameArr.count {
                    items.append(self.poiItem(name: self.placeNameArr[index], address: self.addressNameArr[index], distance: "\(self.distance(lat1: self.myLat, lng1: self.myLong, lat2: Double(self.yArr[index])!, lng2: Double(self.xArr[index])!))" , latitude: self.yArr[index], longitude: self.xArr[index], category: self.categoryNameArr[index]))
                }
                
                self.mapView.removeAllPOIItems()
                self.mapView?.addPOIItems(items)
                
                print(self.placeNameArr)
                print(self.categoryNameArr)
                
                self.mapView?.fitAreaToShowAllPOIItems()
        }
        
        textField.endEditing(true)
        return true
    }
}

extension PlaceViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLat = locations[locations.count-1].coordinate.latitude
        myLong = locations[locations.count-1].coordinate.longitude
        print(myLat)
        
        // userInfo 갱신 부분
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
            
            var userInfo : UserInfo!
            userInfo = self.realm.objects(UserInfo.self).last
            
            try! self.realm.write{
                userInfo.address = str
            }
            Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).updateChildValues([
                "address" : str
                ])
        }
        //
        
        if isFirst {
            isFirst = false
            let item = MTMapPOIItem()
            item.tag = -1
            item.itemName = "현 위치"
            item.markerType = .bluePin
            item.markerSelectedType = .bluePin
            item.mapPoint = MTMapPoint(geoCoord: .init(latitude: myLat, longitude: myLong))
            item.showAnimationType = .noAnimation
            item.customImageAnchorPointOffset = .init(offsetX: 30, offsetY: 0)    // 마커 위치 조정
            self.mapView?.remove(self.mapView.findPOIItem(byTag: -1))
            self.mapView?.add(item)
            
            let mapPoint = MTMapPoint.init(geoCoord: MTMapPointGeo.init(latitude: myLat, longitude: myLong))
            
            self.mapView?.setMapCenter(mapPoint, animated: true)
            self.mapView?.setZoomLevel(3, animated: true)
        }
        
        //distance 배열을 갱신하자.
        let obj = self.realm.objects(MapLocationInfo.self)
        for index in 0..<obj.count {
            try! realm.write {
                obj[index].distance = "\(distance(lat1: myLat, lng1: myLong, lat2: obj[index].latitude, lng2: obj[index].longitude))"
            }
        }
    }
}

//MARK:- 맵뷰 델리게이트 구현
extension PlaceViewController: MTMapViewDelegate {
    func initMapView() {
        // 위치 사용 동의 알람창 최초
        isAuthorizedtoGetUserLocation()
        
        // 위치 동의 완료 위치 정보 사용
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation() // 위치 정보 받음
        }
        
        self.filteredData = self.loctaion_name_array
        
        mapView = MTMapView(frame: CGRect(x: 0, y: 0, width: self.centerView.frame.size.width, height: self.centerView.frame.size.height))
        //mapView.daumMapApiKey = "YOUR_DAUM_API_KEY"
        self.mapView!.delegate = self
        self.mapView!.baseMapType = .standard
        self.view.addSubview(self.mapView)
        mapView.snp.makeConstraints { (make) in
            make.size.equalTo(self.centerView.snp.size)
            make.top.equalTo(self.upperView.snp.bottom)
        }
        self.loadStoredItems()
    }
    
    func poiItem(name: String, address: String, distance: String, latitude: String, longitude: String, category: String) -> MTMapPOIItem {
        let item = MTMapPOIItem()
        item.itemName = name
        item.markerType = .redPin
        item.markerSelectedType = .redPin
        item.mapPoint = MTMapPoint(geoCoord: .init(latitude: Double(latitude)!, longitude: Double(longitude)!))
        item.showAnimationType = .noAnimation
        item.customImageAnchorPointOffset = .init(offsetX: 30, offsetY: 0)    // 마커 위치 조정
        
        return item
    }
    
    func storedPoiItem(name: String, address: String, distance: String, latitude: String, longitude: String, category: String) -> MTMapPOIItem {
        let item = MTMapPOIItem()
        item.itemName = name
        item.markerType = .yellowPin
        item.markerSelectedType = .bluePin
        item.mapPoint = MTMapPoint(geoCoord: .init(latitude: Double(latitude)!, longitude: Double(longitude)!))
        item.showAnimationType = .noAnimation
        item.customImageAnchorPointOffset = .init(offsetX: 30, offsetY: 0)    // 마커 위치 조정
        
        return item
    }
    
    // 구 삼각법을 기준으로 대원거리(m단위) 요청
    func distance(lat1: Double, lng1: Double, lat2: Double, lng2: Double) -> Double {
        
        // 위도,경도를 라디안으로 변환
        let rlat1 = lat1 * .pi / 180
        let rlng1 = lng1 * .pi / 180
        let rlat2 = lat2 * .pi / 180
        let rlng2 = lng2 * .pi / 180
        
        // 2점의 중심각(라디안) 요청
        let a =
            sin(rlat1) * sin(rlat2) +
                cos(rlat1) * cos(rlat2) *
                cos(rlng1 - rlng2)
        let rr = acos(a)
        
        // 지구 적도 반경(m단위)
        let earth_radius = 6378140.0
        
        // 두 점 사이의 거리 (m단위)
        let distance = earth_radius * rr
        
        return distance/1000
    }
    
    func loadStoredItems() -> Void {
        var str: String
        var items = [MTMapPOIItem]()
        let obj = self.realm.objects(MapLocationInfo.self)
        for index in 0..<obj.count {
            switch(obj[index].category) {
            case 0:
                str = "대형마트"
            case 1:
                str = "편의점"
            case 2:
                str = "어린이집, 유치원"
            case 3:
                str = "학교"
            case 4:
                str = "학원"
            case 5:
                str = "주차장"
            case 6:
                str = "주유소, 충전소"
            case 7:
                str = "지하철역"
            case 8:
                str = "은행"
            case 9:
                str = "문화시설"
            case 10:
                str = "중개업소"
            case 11:
                str = "공공기관"
            case 12:
                str = "관광명소"
            case 13:
                str = "숙박"
            case 14:
                str = "음식점"
            case 15:
                str = "카페"
            case 16:
                str = "병원"
            case 17:
                str = "약국"
            default:
                str = "Error"
            }
            
            items.append(storedPoiItem(name: obj[index].name, address: obj[index].address, distance: "\(self.distance(lat1: self.myLat, lng1: self.myLong, lat2: obj[index].latitude, lng2: obj[index].longitude))", latitude: String(obj[index].latitude), longitude: String(obj[index].longitude), category: str))
        }
        
        self.mapView!.addPOIItems(items)
        self.mapView?.fitAreaToShowAllPOIItems()
        self.view.addSubview(self.tableView!)
    }
    
    func isAuthorizedtoGetUserLocation() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        if poiItem.markerType == .yellowPin { return true }
        let alert = UIAlertController(title: nil, message: "마커를 추가할까요?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "예", style: .default) { (action) in
            for index in 0..<self.placeNameArr.count {
                if(self.placeNameArr[index] == poiItem.itemName) {
                    addMapLocation(Double(self.xArr[index])!, Double(self.yArr[index])!, getCategory(self.categoryNameArr[index]), self.placeNameArr[index], self.addressNameArr[index], "\(self.distance(lat1: self.myLat, lng1: self.myLong, lat2: Double(self.xArr[index])!, lng2: Double(self.yArr[index])!))", Date())
                    self.mapView?.removeAllPOIItems()
                    self.loadStoredItems()
                    self.tableView.reloadData()
                    break;
                }
            }
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let obj = self.realm.objects(MapLocationInfo.self)
        return obj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mapCell", for: indexPath) as? PlaceCell else { return UITableViewCell() }
        
        var obj = self.realm.objects(MapLocationInfo.self)
        if flag == 1 || flag == 4 || flag == 5 { obj = obj.sorted(byKeyPath: "distance", ascending: true) }
        else if flag == 0 || flag == 3 { obj = obj.sorted(byKeyPath: "update", ascending: false) }
        let placeName = obj[indexPath.row].name
        let placeAddress = obj[indexPath.row].address
        let placeCategory = obj[indexPath.row].category
        let curDistance = self.distance(lat1: self.myLat, lng1: self.myLong, lat2: obj[indexPath.row].latitude, lng2: obj[indexPath.row].longitude)
    
        cell.titleLabel?.text = placeName
        cell.addressLabel?.text = placeAddress
        cell.distanceLabel?.text = "\(round(100*curDistance)/100)km"
        
        switch placeCategory {
        case 15:
            cell.placeImageView.image = #imageLiteral(resourceName: "cafe.png")
        case 14:
            cell.placeImageView.image = #imageLiteral(resourceName: "restaurant.png")
        default:
            cell.placeImageView.image = #imageLiteral(resourceName: "kamel.png")
        }
        
        return cell
    }
}

//MARK:- 테이블 뷰 델리게이트 구현
extension PlaceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var obj = self.realm.objects(MapLocationInfo.self)
        if flag == 1 || flag == 4 || flag == 5 { obj = obj.sorted(byKeyPath: "distance", ascending: true) }
        else if flag == 0 || flag == 3 { obj = obj.sorted(byKeyPath: "update", ascending: false) }
        let objClicked = obj[indexPath.row]
        let objClickedMapPoint = MTMapPoint.init(geoCoord: MTMapPointGeo.init(latitude: objClicked.latitude-0.0015, longitude: objClicked.longitude))
        self.mapView?.setMapCenter(objClickedMapPoint, animated: true)
        
        self.mapView.removeAllPOIItems()
        
        let item = MTMapPOIItem()
        item.itemName = objClicked.name
        item.markerType = .yellowPin
        item.markerSelectedType = .bluePin
        item.mapPoint = objClickedMapPoint
        item.showAnimationType = .noAnimation
        item.customImageAnchorPointOffset = .init(offsetX: 30, offsetY: 0)    // 마커 위치 조정
        
        self.mapView.add(item)
    }
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
