//
//  AuthenticationViewController.swift
//  Politicall
//
//  Created by Sahil Ambardekar on 9/10/16.
//  Copyright © 2016 Pennhacks. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var loginButton: RoundedButton!
    @IBOutlet weak var registerButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        // Do any additional setup after loading the view.
        authenticateWithSignInHandler(silently: true) { (completion, userID, name, email) in
            if completion {
                PoliticallService.sharedService.login(userID, completionHandler: { (success) in
                    if success {
                        PoliticallService.sharedService.callDataForUserID(userID, completionHandler: { (success, pickedUp, dropped, total) in
                            if success {
                                // logged in silently
                            } else {
                                fatalError()
                            }
                        })
                    } else {
                        print("Failed to login")
                        
                    }
                })
            } else {
                print("Failed to login silently")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func register() {
        authenticateWithSignInHandler { (completion, userID, name, email) in
            if completion {
                PoliticallService.sharedService.createAccount(userID, email: email, name: name) { success in
                    if success {
                        // use no calls, registered
                        
                    } else {
                        print("Failed to register")
                    }
                }
            } else {
                print("Failed to register")
            }
        }
    }
    
    func login() {
        authenticateWithSignInHandler { (completion, userID, name, email) in
            if completion {
                PoliticallService.sharedService.login(userID, completionHandler: { (success) in
                    if success {
                        PoliticallService.sharedService.callDataForUserID(userID, completionHandler: { (success, pickedUp, dropped, total) in
                            if success {
                                // logged in
                            } else {
                                print("Failed to get call data for user \(name)")
                                fatalError()
                            }
                        })
                        
                    } else {
                        print("Failed to login")
                        
                    }
                })
            } else {
                print("Failed to login")
            }
        }
    }
    
    func authenticateWithSignInHandler(silently silently: Bool = false, handler: (completion: Bool, userID: String!, name: String!, email: String!) -> Void) {
        (UIApplication.sharedApplication().delegate as! AppDelegate).signInHandler = handler
        silently ? GIDSignIn.sharedInstance().signInSilently() : GIDSignIn.sharedInstance().signIn()
    }
    
    
    // MARK: Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: Hit Testing
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInView(view)
            if CGRectContainsPoint(loginButton.frame, location) {
                loginButton.isBorderButton = true
            } else if CGRectContainsPoint(registerButton.frame, location) {
                registerButton.isBorderButton = false
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        loginButton.isBorderButton = false
        registerButton.isBorderButton = true
        for touch in touches {
            let location = touch.locationInView(view)
            if CGRectContainsPoint(loginButton.frame, location) {
                login()
            } else if CGRectContainsPoint(registerButton.frame, location) {
                register()
            }
        }
    }
}
