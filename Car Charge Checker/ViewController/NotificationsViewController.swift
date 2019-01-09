//
//  NotificationsViewController.swift
//  Car Charge Checker
//
//  Created by Michael Filippini on 1/4/19.
//  Copyright © 2019 Michael Filippini. All rights reserved.
//
import UIKit
import Firebase
import GoogleSignIn

class NotificationsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var requestsCollectionView: UICollectionView!
    
    var groupRequests: [String] = []
    
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
        
        
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        slideMenuController()?.addLeftGestures()
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
