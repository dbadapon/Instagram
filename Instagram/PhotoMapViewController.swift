//
//  PhotoMapViewController.swift
//  Instagram
//
//  Created by Dominique Adapon on 6/27/17.
//  Copyright © 2017 Dominique Adapon. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var captionField: UITextField!
    
    //do you really need these...???
    var postPhoto: UIImage!
    var postCaption: String!
    
    
    @IBAction func uploadPhotoButton(_ sender: UIButton) {
        pickPhoto()
    }
  
    

    @IBAction func cameraButton(_ sender: UIButton) {
        // you have to account for the case in which the camera is not available!!
        takePhoto()
    }
    
    
    
    @IBAction func submitPost(_ sender: UIButton) {
        //make sure you handle the case where the user has not selected/taken a photo...what should you do in that case?
        // maybe you could show a notification or something...
//        postPhoto = photoImageView
        
        if photoImageView.image != nil {
            Post.postUserImage(image: photoImageView.image, withCaption: captionField.text, withCompletion: {(success, error) in
                if success {
//                    print("I think you posted something?")
                }
                else{
                    print(error?.localizedDescription)
                }
            })
            captionField.text = ""
            photoImageView.image = nil
            tabBarController?.selectedIndex = 0
        }
        
        
    }
    
    
    //var originalImage: UIImage

    override func viewDidLoad() {
        super.viewDidLoad()
        pickPhoto()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Do something with the images (based on your use case)
        
        postPhoto = resize(image: originalImage, newSize: CGSize(width: 500, height: 500))
    
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
        photoImageView.image = postPhoto
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func takePhoto() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            print("Camera is available!")
            vc.sourceType = .camera
        } else {
//            print("Camera is not available, so we will use the photo library instead!")
            vc.sourceType = .photoLibrary
        }
        
        //        vc.sourceType = UIImagePickerControllerSourceType.camera
        self.present(vc, animated: true, completion: nil)
    }
    

    
    func pickPhoto() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        vc.sourceType = .photoLibrary
    
        self.present(vc, animated: true, completion: nil)
        
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
