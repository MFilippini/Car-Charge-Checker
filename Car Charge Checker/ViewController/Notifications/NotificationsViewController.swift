//
//  NotificationsViewController.swift
//  Car Charge Checker
//
//  Created by Michael Filippini on 1/4/19.
//  Copyright © 2019 Michael Filippini. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class NotificationsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var requestsCollectionView: UICollectionView!
    
    var groupRequests: [String] = []
    var groupRequestsInfo: [[String]] = [[]]
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        requestsCollectionView.delegate = self
        requestsCollectionView.dataSource = self
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupRequests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = requestsCollectionView.dequeueReusableCell(withReuseIdentifier: "requestCell", for: indexPath) as! RequestCollectionViewCell
        cell.groupNameLabel.text = groupRequestsInfo[indexPath.row][0]
        cell.createdByLabel.text = "Created By: \(groupRequestsInfo[indexPath.row][1])"
        cell.layer.borderWidth = 2
        cell.layer.borderColor = notBlack.cgColor
        cell.acceptButton.backgroundColor = toothpaste
        cell.rejectButton.backgroundColor = softRed
        cell.acceptButton.layer.cornerRadius = 10
        cell.rejectButton.layer.cornerRadius = 10
        cell.acceptButton.tag = indexPath.row
        cell.rejectButton.tag = indexPath.row
        cell.layer.cornerRadius = 12
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        slideMenuController()?.addLeftGestures()
        ref = Database.database().reference()

        if let userID = Auth.auth().currentUser?.uid {
            ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                self.groupRequests = []
                let value = snapshot.value as? NSDictionary
                let groups = value?["groupRequests"] as? NSDictionary
                if(groups != nil){
                    if(groups?.count != 0){
                        for (_, group) in groups!{
                            self.groupRequests.append(group as? String ?? "error")
                        }
                    }
                }
                self.groupRequestsInfo = [[String]](repeating: ["",""], count: self.groupRequests.count)
                for group in self.groupRequests{
                    self.ref.child("groups").child(group).observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        let name = value?["groupName"] as? String ?? "nameError"
                        let createdBy = value?["creator"] as? String ?? "createError"
                        self.groupRequestsInfo[self.groupRequests.firstIndex(of: group) ?? 0][0] = name
                        self.groupRequestsInfo[self.groupRequests.firstIndex(of: group) ?? 0][1] = createdBy
                        
                        self.requestsCollectionView.reloadData()
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }
                self.requestsCollectionView.reloadData()
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    
    @IBAction func acceptTapped(_ sender: UIButton) {
        print(groupRequests)
        print(sender.tag)
        print(groupRequests[sender.tag])
        
        if let userID = Auth.auth().currentUser?.uid {
            ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                var groups = value?["groupRequests"] as? NSMutableDictionary
                
                for (key,group) in groups ?? [:]{
                    if self.groupRequests[sender.tag] == group as! String{
                        groups![key] = nil
                    }
                }
                let key = self.ref.child("users").childByAutoId().key!
                self.ref.child("groups").child(self.groupRequests[sender.tag]).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as? NSDictionary
                    var inGroup = value?["membersInGroup"] as? NSMutableArray
                    var requestedGroup = value?["membersInvited"] as? NSMutableArray
                
                    let email = Auth.auth().currentUser?.email

                    inGroup?.add(email)
                    requestedGroup?.remove(userID)
  
                    let childUpdates = ["/users/\(userID)/groupRequests/": groups,
                                        "/users/\(userID)/groupsIn/\(key)": self.groupRequests[sender.tag],
                                        "/groups/\(self.groupRequests[sender.tag])/membersInGroup/": inGroup,
                                        "/groups/\(self.groupRequests[sender.tag])/membersInvited/": requestedGroup,] as [String : Any]
                    self.ref.updateChildValues(childUpdates)
                    self.viewWillAppear(true)

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
                var groups = value?["groupRequests"] as? NSMutableDictionary
                
                for (key,group) in groups ?? [:]{
                    if self.groupRequests[sender.tag] == group as! String{
                        groups![key] = nil
                    }
                }
                self.ref.child("groups").child(self.groupRequests[sender.tag]).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as? NSDictionary
                    var requestedGroup = value?["membersInvited"] as? NSMutableArray
                    
                    let email = Auth.auth().currentUser?.email
                    
                    requestedGroup?.remove(userID)
                    
                    let childUpdates = ["/users/\(userID)/groupRequests/": groups,
                                        "/groups/\(self.groupRequests[sender.tag])/membersInvited/": requestedGroup,] as [String : Any]
                    self.ref.updateChildValues(childUpdates)
                    self.viewWillAppear(true)
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func hamburgerTapped(_ sender: Any) {
        slideMenuController()?.openLeft()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
