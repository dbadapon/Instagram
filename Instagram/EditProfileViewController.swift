//
//  EditProfileViewController.swift
//  Instagram
//
//  Created by Dominique Adapon on 6/30/17.
//  Copyright © 2017 Dominique Adapon. All rights reserved.
//

import UIKit
import AVFoundation
import Parse
import ParseUI

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    
    @IBOutlet weak var currentProfilePic: PFImageView!
    
    
    var profileImage: PFObject! {
        didSet {
            let file = profileImage["image"] as? PFFile
            self.currentProfilePic.file = file
            self.currentProfilePic.loadInBackground()
        }
    }

    @IBOutlet weak var newPic: UIImageView!
    
    var newPhoto: UIImage!
    
    
    @IBOutlet weak var bioField: UITextField!
    
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    @IBAction func uploadButton(_ sender: UIButton) {
        pickPhoto()
    }
    
    @IBAction func updateButton(_ sender: UIButton) {
        let user = PFUser.current()!
//        print("just set user to current")
        
        let newBio = bioField.text
        if newPhoto != nil {
//            print("bioField text is: \(bioField.text)")
            if newBio != ""
            {
                Post.updateUserInfo(image: newPhoto, withBio: bioField.text) { (success, error) in
                    if success {
                        print("updated profile!")
                    }
                    else {
                        print(error?.localizedDescription)
                    }
                }
                self.bioField.text = ""
            } else {
                print("keeping original bio")
                let originalBio = user["bio"] as! String
                Post.updateUserInfo(image: newPhoto, withBio: originalBio) { (success, error) in
                    if success {
                    }
                    else {
                        print(error?.localizedDescription)
                    }
                }
            }

            self.newPic.image = nil
            self.dismiss(animated: true, completion: nil)
        } else {
            if newBio != ""
            {
                print("photo is nil but bio changed!") // get image from profile and set it
                Post.updateUserInfo(image: currentProfilePic.image, withBio: bioField.text) { (success, error) in
                    if success {
                        print("updated profile!")
                    }
                    else {
                        print(error?.localizedDescription)
                    }
            }
            }
            self.bioField.text = ""
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = PFUser.current()
        if user?["image"] != nil {
            profileImage = user
        }
        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Do something with the images (based on your use case)
        
        newPhoto = resize(image: originalImage, newSize: CGSize(width: 200, height: 200))
        
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
        newPic.image = newPhoto
    }
    
    
    
    func pickPhoto() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        vc.sourceType = .photoLibrary
        
        self.present(vc, animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
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

