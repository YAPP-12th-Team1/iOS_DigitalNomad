//
//  MyViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 14..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import FSPagerView
import RealmSwift

class MyViewController: UIViewController {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pagerView: FSPagerView!
    @IBOutlet var listLabel: UILabel!
    @IBOutlet var cardLabel: UILabel!
    
    var realm: Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        self.pagerView.register(MeetUpCell.self, forCellWithReuseIdentifier: "meetUpCell")
        self.pagerView.transformer = FSPagerViewTransformer(type: .linear)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //리스트, 카드, 해시태그 초기화
        self.listLabel.text = {
            guard let objects = self.realm.objects(ProjectInfo.self).last?.goalLists else { return nil }
            let entire = objects.count
            let complete = objects.filter("status = true").count
            return "\(complete)/\(entire)"
        }()
        self.cardLabel.text = {
            guard let objects = self.realm.objects(ProjectInfo.self).last?.wishLists else { return nil }
            let entire = objects.count
            let complete = objects.filter("status = true").count
            return "\(complete)/\(entire)"
        }()
    }
    
    @IBAction func touchUpSettingButton(_ sender: UIButton) {
        guard let next = storyboard?.instantiateViewController(withIdentifier: "MyDetailViewController") as? MyDetailViewController else { return }
        self.navigationController?.pushViewController(next, animated: true)
    }
}

extension MyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hashtagCell", for: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}

extension MyViewController: UICollectionViewDelegate {
    
}

extension MyViewController: UICollectionViewDelegateFlowLayout {
    
}

extension MyViewController: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 1
    }
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "meetUpCell", at: index)
        return cell
    }
}

extension MyViewController: FSPagerViewDelegate {
    
}
