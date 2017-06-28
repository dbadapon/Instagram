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
    
    
//    @IBAction func testLogout(_ sender: UIButton) {
//        PFUser.logOutInBackground { (error: Error?) in
//            // logOutInBackgroundow be nil
//        }
//        self.performSegue(withIdentifier: "testLogoutSegue", sender: nil)
//    }


    override func viewDidLoad() {
        super.viewDidLoad()
        postTableView.dataSource = self
        postTableView.delegate = self // what is this tho...
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postTableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell // so what is indexPath, anyway?
        return cell
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
