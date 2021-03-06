//
//  InitialHomeScreen.swift
//  Car Charge Checker
//
//  Created by Alush Benitez on 2/8/19.
//  Copyright © 2019 Michael Filippini. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class InitialHomeScreen: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var nameGreetingLabel: UILabel!
    @IBOutlet weak var createAGroupButton: UIButton!
    @IBOutlet weak var invitesCollectionView: UICollectionView!
    
    
    var ref: DatabaseReference!
    var groupRequests: [String] = []
    var groupRequestsInfo: [[String]] = [[]]
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAGroupButton.layer.cornerRadius = 10
        nameGreetingLabel.text = "Hey " + (firstName ?? "wow u found a bug") + "!"
        invitesCollectionView.backgroundColor = .clear
        invitesCollectionView.delegate = self
        invitesCollectionView.dataSource = self
        
        
        view.layer.insertSublayer({
            let layer = CAGradientLayer()
            layer.frame = view.bounds
            layer.colors = [evqBlue.cgColor, evqTeal.cgColor]
            return layer
        }(), at: 0)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        callDatabase()
        restrictedMode = true
        self.slideMenuController()?.removeLeftGestures()
    }
    
    
    func callDatabase() {
        ref = Database.database().reference()
        if let userID = Auth.auth().currentUser?.uid {
            print(1)
            ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                print(2)
                self.groupRequests = []
                let value = snapshot.value as? NSDictionary
                let groups = value?["groupRequests"] as? NSDictionary
                if(groups != nil){
                    print(3)
                    if(groups?.count != 0){
                        print(4)
                        for (_, group) in groups!{
                            self.groupRequests.append(group as? String ?? "error")
                        }
                    }
                }
                print(self.groupRequests)
                self.groupRequestsInfo = [[String]](repeating: ["",""], count: self.groupRequests.count)
                for group in self.groupRequests{
                    print(5)
                    print("\(group)")
                    self.ref.child("groups").child("\(group)").observeSingleEvent(of: .value, with: { (snapshot) in
                        print(6)
                        let value = snapshot.value as? NSDictionary
                        let name = value?["groupName"] as? String ?? "nameError"
                        let createdBy = value?["creator"] as? String ?? "createError"
                        self.groupRequestsInfo[self.groupRequests.firstIndex(of: group) ?? 0][0] = name
                        self.groupRequestsInfo[self.groupRequests.firstIndex(of: group) ?? 0][1] = createdBy
                        
                        self.invitesCollectionView.reloadData()
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }
                //self.invitesCollectionView.reloadData()
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func createAGroupPressed(_ sender: Any) {
        let groupCreate = storyboard?.instantiateViewController(withIdentifier: "GroupCreate")
        groupCreate?.restorationIdentifier = "GroupCreate"
        slideMenuController()?.changeMainViewController(groupCreate!, close: true)
    }
    
    @IBAction func reloadPressed(_ sender: Any) {
        callDatabase()
        invitesCollectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupRequestsInfo.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = invitesCollectionView.dequeueReusableCell(withReuseIdentifier: "firstHomeRequestCell", for: indexPath) as! FirstRequestsCollectionViewCell
        if groupRequests.count != 0 && groupRequestsInfo.count != 0 {
            print(groupRequestsInfo[0][0])
            print("indexPath:\(indexPath)")
            cell.isHidden = false
            cell.groupNameLabel.text = groupRequestsInfo[indexPath.row][0]
            cell.createdByLabel.text = "Created By: \(groupRequestsInfo[indexPath.row][1])"
            cell.backgroundColor = .white
//            cell.layer.borderWidth = 2
//            cell.layer.borderColor = notBlack.cgColor
            cell.acceptButton.backgroundColor = toothpaste
            cell.rejectButton.backgroundColor = softRed
            cell.acceptButton.layer.cornerRadius = 10
            cell.rejectButton.layer.cornerRadius = 10
            cell.acceptButton.tag = indexPath.row
            cell.rejectButton.tag = indexPath.row
            cell.acceptButton.tag = indexPath.row
            cell.rejectButton.tag = indexPath.row
            cell.layer.cornerRadius = 12
        } else {
            cell.isHidden = true
        }
        return cell
    }
    
    @IBAction func acceptTapped(_ sender: UIButton) {
        print(groupRequests)
        print(sender.tag)
        print(groupRequests[sender.tag])
        
        if let userID = Auth.auth().currentUser?.uid {
            ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                let groups = value?["groupRequests"] as? NSMutableDictionary
                
                for (key,group) in groups ?? [:]{
                    if self.groupRequests[sender.tag] == group as! String{
                        groups![key] = nil
                    }
                }
                
                let key = self.ref.child("users").childByAutoId().key!
                self.ref.child("groups").child(self.groupRequests[sender.tag]).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as? NSDictionary
                    let inGroup = value?["membersInGroup"] as? NSMutableArray
                    let requestedGroup = value?["membersInvited"] as? NSMutableArray
                    
                    let email = Auth.auth().currentUser?.email ?? "error"
                    
                    inGroup?.add(email)
                    requestedGroup?.remove(userID)
                    
                    let childUpdates = ["/users/\(userID)/groupRequests/": groups as Any,
                                        "/users/\(userID)/groupsIn/\(key)": self.groupRequests[sender.tag],
                                        "/groups/\(self.groupRequests[sender.tag])/membersInGroup/": inGroup as Any,
                                        "/groups/\(self.groupRequests[sender.tag])/membersInvited/": requestedGroup as Any,] as [String : Any]
                    self.ref.updateChildValues(childUpdates)
                    self.viewWillAppear(true)
                    let main = self.storyboard?.instantiateViewController(withIdentifier: "Main")
                    self.slideMenuController()?.changeMainViewController(main!, close: true)
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    
    @IBAction func rejectTapped(_ sender: UIButton) {
        print(groupRequests[sender.tag])
        
        if let userID = Auth.auth().currentUser?.uid {
            ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                let groups = value?["groupRequests"] as? NSMutableDictionary
                
                for (key,group) in groups ?? [:]{
                    if self.groupRequests[sender.tag] == group as! String{
                        groups![key] = nil
                    }
                }
                self.ref.child("groups").child(self.groupRequests[sender.tag]).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as? NSDictionary
                    let requestedGroup = value?["membersInvited"] as? NSMutableArray
                    
                    let email = Auth.auth().currentUser?.email
                    
                    requestedGroup?.remove(email as Any)
                    
                    let childUpdates = ["/users/\(userID)/groupRequests/": groups as Any,
                                        "/groups/\(self.groupRequests[sender.tag])/membersInvited/": requestedGroup as Any,] as [String : Any]
                    self.ref.updateChildValues(childUpdates)
                    self.viewWillAppear(true)
                    self.callDatabase()
                    self.invitesCollectionView.reloadData()
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    
    @IBAction func signOutPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            GIDSignIn.sharedInstance().signOut()
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let signIn = storyboard?.instantiateViewController(withIdentifier: "SignIn")
        slideMenuController()?.changeMainViewController(signIn!, close: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.invitesCollectionView.frame.width - 10, height: (self.invitesCollectionView.frame.width - 10) * (250/344))
    }
    
}
