//
//  PostCell.swift
//  Instagram
//
//  Created by Dominique Adapon on 6/27/17.
//  Copyright © 2017 Dominique Adapon. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PostCell: UITableViewCell {

    @IBOutlet weak var postImageView: PFImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var topUserLabel: UILabel!
    @IBOutlet weak var bottomUserLabel: UILabel!
    
    @IBOutlet weak var timestampLabel: UILabel!
    
    var postImage: PFObject! {
        didSet {
            let file = postImage["media"] as? PFFile
            self.postImageView.file = file
            self.postImageView.loadInBackground()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
