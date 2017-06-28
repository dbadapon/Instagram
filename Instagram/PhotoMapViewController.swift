//
//  PhotoMapViewController.swift
//  Instagram
//
//  Created by Dominique Adapon on 6/27/17.
//  Copyright © 2017 Dominique Adapon. All rights reserved.
//

import UIKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available!")
            vc.sourceType = .camera
        } else {
            print("Camera is not available, so we will use the photo library instead!")
            vc.sourceType = .photoLibrary
        }
        
//        vc.sourceType = UIImagePickerControllerSourceType.camera
        self.present(vc, animated: true, completion: nil)


        // Do any additional setup after loading the view.
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
