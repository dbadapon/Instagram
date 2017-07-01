//
//  PostViewController.swift
//  Instagram
//
//  Created by Dominique Adapon on 6/27/17.
//  Copyright © 2017 Dominique Adapon. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    
    @IBOutlet weak var postTableView: UITableView!

    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    
    var allPosts: [PFObject] = []
    
    var postsToLoad = 20
    


    override func viewDidLoad() {
        super.viewDidLoad()
        postTableView.dataSource = self
        postTableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        postTableView.insertSubview(refreshControl, at: 0)
        
        let frame = CGRect(x: 0, y: postTableView.contentSize.height, width: postTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        postTableView.addSubview(loadingMoreView!)
        
        var insets = postTableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        postTableView.contentInset = insets

        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.queryParse), userInfo: nil, repeats: true)
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = postTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - postTableView.bounds.size.height
            
            if (scrollView.contentOffset.y > scrollOffsetThreshold && postTableView.isDragging) {
                
                isMoreDataLoading = true
                
                let frame = CGRect(x: 0, y: postTableView.contentSize.height, width: postTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        if isMoreDataLoading {
            self.isMoreDataLoading = false
            
            self.loadingMoreView!.stopAnimating()
            
            if allPosts.count >= postsToLoad {
                postsToLoad += 20
            }
            queryParse()
        }
    }
    
    func queryParse() {
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.includeKey("author")
        
        query.limit = postsToLoad
        
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
        
        let post = allPosts[indexPath.row] // consider using this instead
        
        cell.postImage = allPosts[indexPath.row]

        let caption = (allPosts[indexPath.row]["caption"] ?? "") as! String
        
        cell.captionLabel.text = caption
    
        
        let user = allPosts[indexPath.row]["author"] as! PFUser
        cell.topUserLabel.text = user.username!
        cell.bottomUserLabel.text = cell.topUserLabel.text
    
        
        if user["image"] != nil {
            cell.profileImage = user
        }
    
        if let date = post.createdAt { // have to do the same with username :o
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            let dateString = dateFormatter.string(from: date)
            cell.timestampLabel.text = dateString
        }
        

    
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
