//
//  MapViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 2. 24..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import MapKit
import CoreLocation
import DZNEmptyDataSet
import DLRadioButton
typealias JSON = [String:Any]

class MapViewController: UIViewController {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnMore: UIButton!
    @IBOutlet var radioButton: DLRadioButton!
    @IBOutlet var radioButton2: DLRadioButton!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnMore.layer.cornerRadius = 5
        btnMore.setTitleColor(.white, for: .normal)
        btnMore.applyGradient([#colorLiteral(red: 0.5019607843, green: 0.7215686275, blue: 0.8745098039, alpha: 1), #colorLiteral(red: 0.6980392157, green: 0.8470588235, blue: 0.7725490196, alpha: 1)])
        
        // 위치 사용 동의 알람창 최초
        isAuthorizedtoGetUserLocation()
        
        // 위치 동의 완료 위치 정보 사용
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation() // 위치 정보 받음
        }
        
        self.navigationController?.navigationBar.isHidden = true
        self.filteredData = self.loctaion_name_array
        
        mapView = MTMapView(frame: CGRect(x: 0, y: searchBar.frame.origin.y + searchBar.frame.height, width: self.view.frame.width, height: self.view.frame.width))
        btnMore.frame.origin.y =  mapView.frame.origin.y + mapView.frame.height + 5
        tableView.frame.origin = CGPoint(x: 0, y: btnMore.frame.origin.y + btnMore.frame.height + 5)
        tableView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height - tableView.frame.origin.y - 49)
        
        //mapView.daumMapApiKey = "YOUR_DAUM_API_KEY"
        self.mapView!.delegate = self
        self.mapView!.baseMapType = .standard
        self.view.addSubview(self.mapView!)
        self.loadStoredItems()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    @IBAction func btnMore(_ sender: UIButton) {
        if flag==0 || flag==1 || flag==5 {
            UIView.animate(withDuration: 0.4, animations: {
                self.mapView.frame.origin.y = UIApplication.shared.statusBarFrame.height - self.view.frame.width
                self.searchBar.frame.origin.y = self.mapView.frame.origin.y - self.searchBar.frame.height
//                self.btnMore.frame.origin.y = self.searchBar.frame.origin.y + self.searchBar.frame.height + 5
                self.btnMore.frame.origin.y = UIApplication.shared.statusBarFrame.height + 5
                self.btnMore.frame.origin.x = 10
                self.radioButton.frame.origin.y = UIApplication.shared.statusBarFrame.height + 5
                self.radioButton2.frame.origin.y = UIApplication.shared.statusBarFrame.height + 5
                self.radioButton.isSelected = true
//                self.tableView.frame.origin.y = self.btnMore.frame.origin.y + self.btnMore.frame.height + 5
//                self.tableView.frame.size.height = self.view.frame.height - self.btnMore.frame.origin.y - self.btnMore.frame.height - 49
                self.tableView.frame.origin.y = self.btnMore.frame.origin.y + self.btnMore.frame.height + 5
                self.tableView.frame.size.height = self.view.frame.height - self.btnMore.frame.origin.y - self.btnMore.frame.height - 49
                self.flag = 0
                self.tableView.reloadData()
            }, completion: { _ in
                self.btnMore.setTitle("지도보기", for: .normal)
                self.view.addSubview(self.radioButton)
                self.view.addSubview(self.radioButton2)
                self.flag = 2
            })
        } else if flag==2 || flag==3 || flag==4 {
            UIView.animate(withDuration: 0.4, animations: {
//                self.searchBar.frame.origin.y = UIApplication.shared.statusBarFrame.height
//                self.mapView.frame.origin.y += self.view.frame.width
//                self.btnMore.frame.origin.y =  self.mapView.frame.origin.y + self.mapView.frame.height + 5
//                self.tableView.frame.origin = CGPoint(x: 0, y: self.btnMore.frame.origin.y + self.btnMore.frame.height + 5)
//                self.tableView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height - self.tableView.frame.origin.y - 49)
                self.searchBar.frame.origin.y = UIApplication.shared.statusBarFrame.height
                self.mapView.frame.origin.y = self.searchBar.frame.origin.y + self.searchBar.frame.height
                self.btnMore.frame.origin.y = self.mapView.frame.origin.y + self.mapView.frame.height + 5
                self.btnMore.layer.position.x = self.view.frame.width/2
                self.radioButton.removeFromSuperview()
                self.radioButton2.removeFromSuperview()
                self.tableView.frame.origin.y = self.btnMore.frame.origin.y + self.btnMore.frame.height + 5
                self.tableView.frame.size.height = self.view.frame.height - (self.mapView.frame.origin.y + self.mapView.frame.height + 49)
                
                
            }, completion: { _ in
                self.btnMore.setTitle("더 보기", for: .normal)
                
                if self.flag == 4 {
                    self.flag = 5
                } else {
                    self.flag = 0
                }
            })
        }
    }
    
    @IBAction func sortByDistance(_ sender: DLRadioButton) {
        self.flag = 4
        self.tableView.reloadData()
    }
    @IBAction func sortByRecent(_ sender: DLRadioButton) {
        self.flag = 3
        self.tableView.reloadData()
    }
}

extension MapViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let obj = self.realm.objects(MapLocationInfo.self)
        return obj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView!.dequeueReusableCell(withIdentifier: "mapCell", for: indexPath) as! MapCell
        
        var obj = self.realm.objects(MapLocationInfo.self)
        if flag == 1 || flag == 4 || flag == 5 { obj = obj.sorted(byKeyPath: "distance", ascending: true) }
        else if flag == 0 || flag == 3 { obj = obj.sorted(byKeyPath: "update", ascending: false) }
        let placeName = obj[indexPath.row].name
        let placeAddress = obj[indexPath.row].address
        let placeCategory = obj[indexPath.row].category
        let curDistance = self.distance(lat1: self.myLat, lng1: self.myLong, lat2: obj[indexPath.row].latitude, lng2: obj[indexPath.row].longitude)
        
        //cell.textLabel?.text = placeName
        cell.placeName?.text = placeName
        cell.placeAddress?.text = placeAddress
        cell.distance?.text = "\(round(100*curDistance)/100)km"
        
        switch placeCategory {
        case 15:
            cell.imageview.image = #imageLiteral(resourceName: "cafe.png")
        case 14:
            cell.imageview.image = #imageLiteral(resourceName: "restaurant.png")
        default:
            cell.imageview.image = #imageLiteral(resourceName: "kamel.png")
        }
        
//        if(indexPath.row == obj.count-1) {
//            self.flag = 2
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let obj = self.realm.objects(MapLocationInfo.self)
            do {
                try self.realm.write {
                    self.realm.delete(obj[indexPath.row])
                }
            } catch {
                print("\(error)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.mapView.removeAllPOIItems()
            self.loadStoredItems()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension MapViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var obj = self.realm.objects(MapLocationInfo.self)
        if flag == 1 || flag == 4 || flag == 5 { obj = obj.sorted(byKeyPath: "distance", ascending: true) }
        else if flag == 0 || flag == 3 { obj = obj.sorted(byKeyPath: "update", ascending: false) }
        let objClicked = obj[indexPath.row]
        let objClickedMapPoint = MTMapPoint.init(geoCoord: MTMapPointGeo.init(latitude: objClicked.latitude-0.0015, longitude: objClicked.longitude))
        self.mapView?.setMapCenter(objClickedMapPoint, animated: true)
    }
}



extension MapViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //self.tableView.removeFromSuperview()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.placeNameArr.removeAll()
        self.addressNameArr.removeAll()
        self.distance.removeAll()
        self.xArr.removeAll()
        self.yArr.removeAll()
        self.categoryNameArr.removeAll()
        
        searchBar.resignFirstResponder()
        print("search : ", self.searchBar.text!)
        
        
        let baseUrl: String = "https://dapi.kakao.com/v2/local/search/keyword.json?query="
        let query: String = self.searchBar.text!
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
    }
}

extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLat = locations[locations.count-1].coordinate.latitude
        myLong = locations[locations.count-1].coordinate.longitude
        print(myLat)
        
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
        
        //self.tableView.reloadData()
    }
}

extension MapViewController: MTMapViewDelegate{
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        if poiItem.markerType == .yellowPin {
            return true
        }
        
        let alertController = UIAlertController(title: "마커를 추가하시겠습니까??", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "YES", style: .default) { (_) in
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
        let cancelAction = UIAlertAction(title: "NO", style: .cancel) { (_) in }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
        return true
    }
}

extension MapViewController: DZNEmptyDataSetSource{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return nil
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "원하는 장소를 추가해 주세요.")
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return nil
    }
}
extension MapViewController: DZNEmptyDataSetDelegate{
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    func emptyDataSetWillAppear(_ scrollView: UIScrollView!) {
        tableView.separatorStyle = .none
    }
    func emptyDataSetWillDisappear(_ scrollView: UIScrollView!) {
        if(!isFirstExecuted){
            isFirstExecuted = true
            return
        }
        tableView.separatorStyle = .singleLine
    }
}
