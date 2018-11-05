//
//  SignInViewController.swift
//  Car Charge Checker
//
//  Created by Michael Filippini on 10/30/18.
//  Copyright © 2018 Michael Filippini. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate {
    
    var signInListener: AuthStateDidChangeListenerHandle? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
//      GIDSignIn.sharedInstance().signIn()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        signInListener =    Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                if(self.userDataAvailable()){
                    self.performSegue(withIdentifier: "toMainViewController", sender: nil)
                }
                else{
                    self.performSegue(withIdentifier: "toSetUpScreen", sender: nil)
                }
            } else {
                print("no User")
                print(Auth.auth().currentUser)
            }
        }
    }
    
    func userDataAvailable() -> Bool{
        let userID = Auth.auth().currentUser?.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
//            let user = User(username: username)
            return true
        }) { (error) in
            
        }
        return false
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        print("here")
        if let error = error {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                return
            }
            // User is signed in
            // ...
        }
    }
    
    @IBAction func questionBlockHit(_ sender: Any) {
        print(Auth.auth().currentUser)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(signInListener!)
    }
    

}
