//
//  LoginViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 2. 24..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if(user != nil){
                let storyboard = UIStoryboard(name: "Start", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "StartViewController")
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func clickLogin(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
}

