//
//  ReachabilityManager.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 17..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import Reachability
import Toaster

class ReachabilityManager: NSObject {
    static let shared = ReachabilityManager()
    var reachabilityStatus: Reachability.Connection = .none
    var isNetworkAvailable: Bool {
        return reachabilityStatus != .none
    }
    let reachability = Reachability()!
    
    @objc func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        switch reachability.connection {
        case .none:
            print("인터넷 연결 없음")
            Toast(text: "인터넷 연결을 확인해 주세요.", delay: 0, duration: Delay.short).show()
        case .wifi:
            print("와이파이 연결중")
        case .cellular:
            print("셀룰러 연결중")
        }
    }
    func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(notification:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachablity notifier")
        }
    }
    func stopMonitoring() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
}
