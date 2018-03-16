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
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if(user != nil){
                let storyboard = UIStoryboard(name: "Research", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "ResearchViewController") as! ResearchViewController
                //controller.modalTransitionStyle = .crossDissolve
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: GIDSignInButton) {
        GIDSignIn.sharedInstance().signIn()
    }
}

