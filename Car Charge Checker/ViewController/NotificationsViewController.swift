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
        
        cell.acceptButton.backgroundColor = toothpaste
        cell.rejectButton.backgroundColor = softRed
        cell.acceptButton.layer.cornerRadius = 10
        cell.rejectButton.layer.cornerRadius = 10
        cell.acceptButton.tag = indexPath.row
        cell.rejectButton.tag = indexPath.row
        
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
                        print("groups: \(groups!)")
                        for (_, group) in groups!{
                            print("group: \(group)")
                            self.groupRequests.append(group as? String ?? "error")
                        }
                    }
                }
                self.groupRequestsInfo = [[String]](repeating: ["",""], count: self.groupRequests.count)
                print("grouprequest: \(self.groupRequests)")
                for group in self.groupRequests{
                    print("group: \(group)")
                    self.ref.child("groups").child(group).observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        let name = value?["groupName"] as? String ?? "nameError"
                        let createdBy = value?["creator"] as? String ?? "createError"
                        print("name: \(name)+\(createdBy)")
                        self.groupRequestsInfo[self.groupRequests.firstIndex(of: group) ?? 0][0] = name
                        self.groupRequestsInfo[self.groupRequests.firstIndex(of: group) ?? 0][1] = createdBy
                        self.requestsCollectionView.reloadData()
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }

    }
    
    
    @IBAction func acceptTapped(_ sender: UIButton) {
        print(groupRequests[sender.tag])
        
    }
    
    @IBAction func rejectTapped(_ sender: UIButton) {
        print(groupRequests[sender.tag])
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
