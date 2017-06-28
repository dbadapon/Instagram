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
    @IBOutlet weak var captionLabel: UILabel!
    
    var post: PFObject!
    
//        {
//        didSet {
//            let file = post["media"] as? PFFile
//            self.image.file = file
//            self.image.loadInBackground()
//            
//        }
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let post = post {
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
