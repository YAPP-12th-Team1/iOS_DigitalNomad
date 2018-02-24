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
typealias JSON = [String:Any]

class MapViewController: UIViewController, MTMapViewDelegate, UISearchBarDelegate {
    @IBOutlet var searchBar: UISearchBar!
    var filteredData: [String]!
    var loctaion_name_array = [String]()
    
    var placeNameArr = [String]()
    var addressNameArr = [String]()
    var placeUriArr = [String]()
    var xArr = [String]()
    var yArr = [String]()
    var categoryNameArr = [String]()
    
    let realm = try! Realm()
    
    var mapView: MTMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        searchBar.layer.zPosition = 1
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Search Keyword"
        self.filteredData = self.loctaion_name_array

        mapView = MTMapView(frame: CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: self.view.frame.size.height))

        //mapView.daumMapApiKey = "YOUR_DAUM_API_KEY"
        self.mapView!.delegate = self
        self.mapView!.baseMapType = .standard
        self.view.addSubview(self.mapView!)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search : ", self.searchBar.text!)


        let baseUrl: String = "https://dapi.kakao.com/v2/local/search/keyword.json?query="
        let query: String = self.searchBar.text!
        let encode = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let modi = encode?.replacingOccurrences(of: "%25", with: "%")

        Alamofire.request(baseUrl+modi!+"&x=126.969599&y=37.546782&radius=5000", method: .get ,headers: ["Authorization": "KakaoAK 8add144f51d5e214bb8d9008445c817d"])
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
                    self.placeUriArr.append(placeIndex["place_url"] as! String)
                    self.xArr.append(placeIndex["x"] as! String)
                    self.yArr.append(placeIndex["y"] as! String)
                    self.categoryNameArr.append(placeIndex["category_group_name"] as! String)
                    addMyLocation(Double(self.xArr.last!)!, Double(self.yArr.last!)!, getCategory(self.categoryNameArr.last!), self.placeNameArr.last!, self.addressNameArr.last!, self.placeUriArr.last!, Date())
                }

                var items = [MTMapPOIItem]()

                for index in 0..<self.placeNameArr.count {
                    items.append(self.poiItem(name: self.placeNameArr[index], address: self.addressNameArr[index], uri: self.placeUriArr[index], latitude: self.yArr[index], longitude: self.xArr[index], category: self.categoryNameArr[index]))
                }

                self.mapView?.addPOIItems(items)
                print(self.placeNameArr)
                print(self.categoryNameArr)
                self.mapView?.fitAreaToShowAllPOIItems()
        }
    }

    func poiItem(name: String, address: String, uri: String, latitude: String, longitude: String, category: String) -> MTMapPOIItem {
        let item = MTMapPOIItem()
        item.itemName = name
        item.markerType = .redPin
        item.markerSelectedType = .redPin
        item.mapPoint = MTMapPoint(geoCoord: .init(latitude: Double(latitude)!, longitude: Double(longitude)!))
        item.showAnimationType = .noAnimation
        item.customImageAnchorPointOffset = .init(offsetX: 30, offsetY: 0)    // 마커 위치 조정

        return item
    }

    override func viewDidAppear(_ animated: Bool) {

    }
}
