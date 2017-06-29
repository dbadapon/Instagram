//
//  PostDetailsViewController.swift
//  Instagram
//
//  Created by Dominique Adapon on 6/28/17.
//  Copyright © 2017 Dominique Adapon. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PostDetailsViewController: UIViewController {
    
    @IBOutlet weak var image: PFImageView!
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    
    var post: PFObject!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let date = post.createdAt { // have to do the same with username :o
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            let dateString = dateFormatter.string(from: date)
            timestampLabel.text = dateString
        }
    
        
        if let post = post {
            let user = post["author"] as! PFUser
            userLabel.text = user.username!

            captionLabel.text = post["caption"] as? String
            let file = post["media"] as? PFFile
            
            image.file = file
            self.image.loadInBackground()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
*/

}
