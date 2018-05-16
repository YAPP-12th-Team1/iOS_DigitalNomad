//
//  NomadLifeViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 6..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit


class NomadViewController: UIViewController {
    
 

    override func viewDidLoad() {
        super.viewDidLoad()

        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        
        //프로젝트 종료시 알려주기
//        if(diffDay > realm.objects(ProjectInfo.self).last!.day) {
//            let alert = UIAlertController(title: "프로젝트 종료", message: "설정한 프로젝트가 종료되었습니다. 앱을 삭제하세요?", preferredStyle: .alert)
//            present(alert, animated: true, completion: nil)
//            return
//        }
        //노마드 일차 파이어베이스 정보 갱신
//        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).updateChildValues(["day" : diffDay])

    }


}

extension NomadViewController: UISearchBarDelegate{
    
}

