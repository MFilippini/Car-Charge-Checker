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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        
        view.layer.insertSublayer({
            let layer = CAGradientLayer()
            layer.frame = view.bounds
            layer.colors = [evqBlue.cgColor, evqTeal.cgColor]
            return layer
        }(), at: 0)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        if(max(screenWidth, screenHeight) > 568.0){
            signInListener = Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil {
                    self.userDataAvailable()
                }else {
                    print("no User")
                }
            }
        }else{
            let alert = UIAlertController(title: "Error", message: "EVQ is not yet compatible with this device.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("googlePressed?2")
        }
        slideMenuController()?.removeLeftGestures()
    }
    
    func userDataAvailable(){
        let user = Auth.auth().currentUser
        let ref = Database.database().reference()
        var groupsInArray: [String] = []
        var inAGroup: Bool = false
        if let userID = Auth.auth().currentUser?.uid {
            ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let groups = value?["groupsIn"] as? NSDictionary
                if(groups != nil){
                    if(groups?.count != 0){
                        inAGroup = true
                        //Add data to groupsInArray
                        for (_, group) in groups!{
                            groupsInArray.append(group as! String)
                        }
                        currentGroup = groupsInArray[0]
                    } else {
                        inAGroup = false
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
        
        
        
        ref.child("users").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if(snapshot.exists()){
                if inAGroup {
                    let mainView = self.storyboard?.instantiateViewController(withIdentifier: "Main")
                    self.slideMenuController()?.changeMainViewController(mainView!, close: true)
                } else {
                    let initialHomeView = self.storyboard?.instantiateViewController(withIdentifier: "greeting")
                    self.slideMenuController()?.changeMainViewController(initialHomeView!, close: true)
                }
            }else{
                print("toSetup")
                let setupScreen = self.storyboard?.instantiateViewController(withIdentifier: "UserData")
                self.slideMenuController()?.changeMainViewController(setupScreen!, close: true)
            }
        }) { (error) in
        }
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
        print("googlePressed?1")
        if error != nil {
            // ...
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if error != nil {
                // ...
                return
            }
            // User is signed in
            // ...
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(signInListener!)
    }

}
