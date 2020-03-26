//
//  SignInViewController.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-15.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn

class SignInViewController:UIViewController {
    
    var googleSignInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        //GIDSignIn.sharedInstance().signIn()
        
        googleSignInButton = GIDSignInButton()
        view.addSubview(googleSignInButton)
        
        googleSignInButton.constraintHeight(to: 64)
        googleSignInButton.constraintToSuperview(nil, 64, 64, 64, ignoreSafeArea: true)
        
        
    }
    
}
