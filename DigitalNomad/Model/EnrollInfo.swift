//
//  EnrollInfo.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 5. 20..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

class EnrollInfo {
    static let shared = EnrollInfo()
    var address: String?
    var days: Int?
    var purpose: String?
    var isCoworking: Bool?
    var job: String?
    var introducing: String?
    var meetupPurpose: String?
    var emailTitle: String?
    var emailContent: String? 
}
