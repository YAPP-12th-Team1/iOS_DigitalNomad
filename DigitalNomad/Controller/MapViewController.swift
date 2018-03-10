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
typealias JSON = [String:Any]

class MapViewController: UIViewController {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnMore: UIButton!
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
    
    var flag : Bool = true // true : 더 보기, false : 지도 보기
    
    var isFirstExecuted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.layer.zPosition = 1
        btnMore.layer.cornerRadius = 5
        btnMore.setTitleColor(.white, for: .normal)
        btnMore.applyGradient([UIColor(red: 128/255, green: 184/255, blue: 223/255, alpha: 1), UIColor(red: 178/255, green: 216/255, blue: 197/255, alpha: 1)])
        
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
    
    func loadStoredItems() -> Void {
        var str: String
        var items = [MTMapPOIItem]()
        let obj = self.realm.objects(MyLocationRealm.self)
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
            
            items.append(storedPoiItem(name: obj[index].name, address: obj[index].address, distance: obj[index].distance, latitude: String(obj[index].latitude), longitude: String(obj[index].longitude), category: str))
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
        if flag {
            //self.mapView!.removeFromSuperview()
            UIView.animate(withDuration: 0.4, animations: {
                //self.mapView.frame.size.height = 0
                self.mapView.frame.origin.y -= self.mapView.frame.height
                self.btnMore.frame.origin.y = self.searchBar.frame.origin.y + self.searchBar.frame.height + 5
                self.tableView.frame.origin.y = self.btnMore.frame.origin.y + self.btnMore.frame.height + 5
                self.tableView.frame.size.height = self.view.frame.height - self.btnMore.frame.origin.y - self.btnMore.frame.height - 49
            }, completion: { _ in
                self.btnMore.setTitle("지도보기", for: .normal)
                self.flag = false
                self.view.bringSubview(toFront: self.searchBar)
            })
        } else {
            //self.view.addSubview(self.mapView!)
            UIView.animate(withDuration: 0.4, animations: {
                //self.mapView.frame.size.height = self.mapView.frame.width
                self.mapView.frame.origin.y += self.mapView.frame.height
                self.btnMore.frame.origin.y =  self.mapView.frame.origin.y + self.mapView.frame.height + 5
                self.tableView.frame.origin = CGPoint(x: 0, y: self.btnMore.frame.origin.y + self.btnMore.frame.height + 5)
                self.tableView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height - self.tableView.frame.origin.y - 49)
            }, completion: { _ in
                self.btnMore.setTitle("더 보기", for: .normal)
                self.flag = true
            })
        }
    }
}

extension MapViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let obj = self.realm.objects(MyLocationRealm.self)
        return obj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView!.dequeueReusableCell(withIdentifier: "mapCell", for: indexPath) as! MapCell
        
        let obj = self.realm.objects(MyLocationRealm.self)
        let placeName = obj[indexPath.row].name
        let placeAddress = obj[indexPath.row].address
        let placeCategory = obj[indexPath.row].category
        var curDistance = Double(obj[indexPath.row].distance)
        curDistance = curDistance!/1000
        
        print("rowText:"+placeName)
        
        //cell.textLabel?.text = placeName
        cell.placeName?.text = placeName
        cell.placeAddress?.text = placeAddress
        cell.distance?.text = "\(curDistance!)km"
        
        switch placeCategory {
        case 15:
            cell.imageview.image = #imageLiteral(resourceName: "cafe.png")
        case 14:
            cell.imageview.image = #imageLiteral(resourceName: "restaurant.png")
        default:
            cell.imageview.image = #imageLiteral(resourceName: "kamel.png")
        }
        
        return cell
    }
}

extension MapViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.realm.objects(MyLocationRealm.self)
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
                    items.append(self.poiItem(name: self.placeNameArr[index], address: self.addressNameArr[index], distance: self.distance[index], latitude: self.yArr[index], longitude: self.xArr[index], category: self.categoryNameArr[index]))
                }
                
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
        
        let item = MTMapPOIItem()
        item.itemName = "현 위치"
        item.markerType = .bluePin
        item.markerSelectedType = .bluePin
        item.mapPoint = MTMapPoint(geoCoord: .init(latitude: myLat, longitude: myLong))
        item.showAnimationType = .noAnimation
        item.customImageAnchorPointOffset = .init(offsetX: 30, offsetY: 0)    // 마커 위치 조정
        self.mapView?.add(item)
        
        let mapPoint = MTMapPoint.init(geoCoord: MTMapPointGeo.init(latitude: myLat, longitude: myLong))
        
        self.mapView?.setMapCenter(mapPoint, animated: true)
        self.mapView?.setZoomLevel(3, animated: true)
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
                    addMyLocation(Double(self.xArr[index])!, Double(self.yArr[index])!, getCategory(self.categoryNameArr[index]), self.placeNameArr[index], self.addressNameArr[index], self.distance[index], Date())
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
        return NSAttributedString(string: "검색 결과가 없습니다.")
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
