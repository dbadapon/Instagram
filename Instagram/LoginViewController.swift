//
//  LoginViewController.swift
//  Instagram
//
//  Created by Dominique Adapon on 6/26/17.
//  Copyright © 2017 Dominique Adapon. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var usernameField: UITextField!

    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    
    @IBAction func onSignIn(_ sender: Any) {
        
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Ya logged in!")
                self.performSegue(withIdentifier: "loginSegue", sender: nil) // what is sender and why is it nil?
            }
        }
        
    }
    
    
    @IBAction func onSignUp(_ sender: Any) {
        let newUser = PFUser()
        
        newUser.username = usernameField.text ?? ""
        newUser.password = passwordField.text ?? ""
        
/*
        if usernameField.text!.isEmpty || passwordField.text!.isEmpty {
            self.usernameError()
        }
 */
        //does instagram have this?^
        //it has something a little different, so come back to this...
        
        
        
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if success {
//                print("Ieeei, created a user!")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print(error?.localizedDescription)
                
                
//                if error.code == 202 {
//                    print("Username is taken")
//                } // not sure how to do this; this code is wrong
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
