//
//  PostViewController.swift
//  Instagram
//
//  Created by Dominique Adapon on 6/27/17.
//  Copyright © 2017 Dominique Adapon. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var postTableView: UITableView!

    
    var allPosts: [PFObject] = []
    


    override func viewDidLoad() {
        super.viewDidLoad()
        postTableView.dataSource = self
        postTableView.delegate = self

        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        postTableView.insertSubview(refreshControl, at: 0)
        
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.queryParse), userInfo: nil, repeats: true)
        
    }
    
    
    func queryParse() {
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                self.allPosts = posts
                self.postTableView.reloadData()
            }
            else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        queryParse()
        refreshControl.endRefreshing()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postTableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        cell.postImage = allPosts[indexPath.row]

        let caption = (allPosts[indexPath.row]["caption"] ?? "") as! String
        
        cell.captionLabel.text = caption
    
        
        let user = allPosts[indexPath.row]["author"] as! PFUser
        cell.topUserLabel.text = user.username!
        cell.bottomUserLabel.text = cell.topUserLabel.text

    
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let cell = sender as! UITableViewCell
        if let indexPath = postTableView.indexPath(for: cell) {
            let post = allPosts[indexPath.row]
            let detailViewController = segue.destination as! PostDetailsViewController
 
            detailViewController.post = post
        }
    }


}
