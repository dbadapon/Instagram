//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Dominique Adapon on 6/27/17.
//  Copyright © 2017 Dominique Adapon. All rights reserved.
//

import UIKit
import Parse
import ParseUI

let notifyLogout = "logoutUser"

class ProfileViewController: UIViewController, UICollectionViewDataSource {
    
    
    @IBOutlet weak var profilePicture: PFImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var bioLabel: UILabel!
    
    var profileImage: PFObject! {
        didSet {
            let file = profileImage["image"] as? PFFile
            self.profilePicture.file = file
            self.profilePicture.loadInBackground()
        }
    }
    
    
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    var allPosts: [PFObject] = []
    
    @IBAction func editProfileButton(_ sender: UIButton) {
        
    }
    
    
    
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        PFUser.logOutInBackground { (error: Error?) in
            // logOutInBackgroundow be nil
        }
        
    }
    

    @IBAction func logoutTest(_ sender: UIButton) {
        print("tapped TEST logout button!")
    
        PFUser.logOutInBackground { (error: Error?) in
            // logOutInBackgroundow be nil
            print("Logged out!")
        }
    }

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        profileCollectionView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        profileCollectionView.insertSubview(refreshControl, at: 0)
        

        if PFUser.current() != nil {
            usernameLabel.text = PFUser.current()?.username
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.queryParse), userInfo: nil, repeats: true)
    
            profileImage = PFUser.current()
            
        } else
        {
            usernameLabel.text = ""
        }
        
        
        
        
        let layout = profileCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.minimumInteritemSpacing = 1
//        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        let cellsPerLine: CGFloat = 3
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = profileCollectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layout.itemSize = CGSize(width: width-1, height: width-1)
    }

    
    func queryParse() {
        let query = PFQuery(className: "Post")
        query.includeKey("author")
        if PFUser.current() != nil {
            query.whereKey("author", equalTo: PFUser.current())
        }
        
        query.addDescendingOrder("createdAt")
        query.limit = 20
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                self.allPosts = posts
                self.profileCollectionView.reloadData()
                self.profileImage = PFUser.current()
            }
            else {
                print(error!.localizedDescription)
            }
        }
    }
    
    
    func refreshProfile() {
        let query = PFQuery(className: "_User")
        query.findObjectsInBackground()
    }
    

    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        queryParse()
        refreshControl.endRefreshing()
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        
        cell.profileImage = allPosts[indexPath.row]
        
//        let post = allPosts[indexPath.item]
        
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "detailSegue" {
            let cell = sender as! UICollectionViewCell
            if let indexPath = profileCollectionView.indexPath(for: cell) {
                let post = allPosts[indexPath.row]
                let detailViewController = segue.destination as! PostDetailsViewController
                
                detailViewController.post = post
            }
        }
    }
}
