//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Dominique Adapon on 6/27/17.
//  Copyright © 2017 Dominique Adapon. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    
    var allPosts: [PFObject] = []
    
    
    

    @IBAction func logoutButton(_ sender: UIButton) {
        PFUser.logOutInBackground { (error: Error?) in
            // logOutInBackgroundow be nil
        }
        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        profileCollectionView.dataSource = self
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.queryParse), userInfo: nil, repeats: true)
        
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
        
        query.limit = 20
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                self.allPosts = posts
                self.profileCollectionView.reloadData()
            }
            else {
                print(error!.localizedDescription)
            }
        }
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

        let cell = sender as! UICollectionViewCell
        if let indexPath = profileCollectionView.indexPath(for: cell) {
            let post = allPosts[indexPath.row]
            let detailViewController = segue.destination as! PostDetailsViewController
            
            detailViewController.post = post
            
        }
    }
}
