//
//  ChooseThreadViewController.swift
//  SnapchatCloneV3
//
//  Created by Anish Saha on 4/12/16.
//  Copyright © 2016 asaha. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChooseThreadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var threadTableView: UITableView!
    @IBOutlet weak var chosenThreadLabel: UILabel!
    var chosenImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        threadTableView.delegate = self
        threadTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func postToFeed(_ sender: UIButton) {
        if let threadName = chosenThreadLabel.text, threadName != "" {
            if let imageToPost = chosenImage {
                let auth = FIRAuth.auth()
                let user = auth?.currentUser
                let dname: String? = user?.displayName
                var name = "anon"
                if let dname = dname {
                    name = dname
                }                
                addPost(postImage: imageToPost, thread: threadName, username: name)
                performSegue(withIdentifier: "unwindToImagePicker", sender: nil)
            }
        }
        else {
            let alert = UIAlertController(title: "Error", message: "You must select at least one thread to post your snap to.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    // MARK: Tableview delegate and datasource methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chooseThreadCell") as! ChooseThreadTableViewCell
        cell.threadNameLabel.text = threadNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threadNames.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenThreadLabel.text = threadNames[indexPath.row]
    }
}
