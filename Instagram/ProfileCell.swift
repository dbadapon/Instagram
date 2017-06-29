//
//  ProfileCell.swift
//  Instagram
//
//  Created by Dominique Adapon on 6/29/17.
//  Copyright © 2017 Dominique Adapon. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: PFImageView!
    
    var profileImage: PFObject! {
        didSet {
            let file = profileImage["media"] as? PFFile
            self.profileImageView.file = file
            self.profileImageView.loadInBackground()
        }
    }
    
    
}
